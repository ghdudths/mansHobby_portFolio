package com.puter.final_project;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Service("customOAuth2UserService")
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final OAuth2UserService<OAuth2UserRequest, OAuth2User> defaultOAuth2UserService = new DefaultOAuth2UserService();

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = defaultOAuth2UserService.loadUser(userRequest);

        Map<String, Object> attributes = oAuth2User.getAttributes();

        String provider = userRequest.getClientRegistration().getRegistrationId(); // Provider name

        String name = null;
        String email = null;

        // Prepare attributes map to include the extracted user information
        Map<String, Object> customAttributes = new HashMap<>(attributes);
        customAttributes.put("esite", provider);

        if ("google".equals(provider)) {
            name = (String) attributes.get("name");
            email = (String) attributes.get("email");
        } else if ("naver".equals(provider)) {
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            name = (String) response.get("name");
            email = (String) response.get("email");
        } else if ("kakao".equals(provider)) {
            Map<String, Object> account = (Map) attributes.get("kakao_account");
            Map<String, String> profile = (Map) account.get("profile");

            name = (String) profile.get("nickname");
            email = (String) account.get("email");
        }    
        customAttributes.put("name", name);
        customAttributes.put("email", email);

        System.out.println("provider: " + provider);

        if (name == null) {
            throw new IllegalArgumentException("Missing attribute 'name' in attributes");
        }

        return new DefaultOAuth2User(
            Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
            customAttributes,
            "name" // Ensure this is the correct key for the user's name in the attributes
        );
    }

}
