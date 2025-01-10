package com.puter.final_project;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

@Configuration
public class SecurityConfig {

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authorizeRequests ->
                authorizeRequests
                    .requestMatchers("/", "/**", "/**/**", "/home.do", "/login", "/public/**").permitAll()
                    .anyRequest().authenticated()
            )
            .oauth2Login(oauth2 -> 
                oauth2
                    .userInfoEndpoint(e -> e.userService(customOAuth2UserService)) // 사용자 정의 OAuth2UserService 설정
                    .defaultSuccessUrl("http://192.168.219.55:8080/easyLogin.do", true)
                    .failureUrl("/login-error")
            )
            .logout(logout ->
                logout
                    .logoutUrl("/logout")
                    .logoutSuccessUrl("/login?logout")
            )
            .exceptionHandling(exceptions ->
                exceptions
                    .accessDeniedPage("/accessDenied")
            )
            .csrf(csrf -> 
                csrf
                    .ignoringRequestMatchers("/admin/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/user/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/review/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/buyList/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/inquiry/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/payments/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .ignoringRequestMatchers("/api/iamport/**") // 파일 업로드 요청을 CSRF 보호에서 제외
                    .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
            );
        return http.build();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/public/**");
    }

    // @Bean
    // public OAuth2UserService<OAuth2UserRequest, OAuth2User> customOAuth2UserService() {
    //     return new CustomOAuth2UserService();
    // }
}
