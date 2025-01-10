package com.puter.final_project.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.puter.final_project.dao.CartMapper;
import com.puter.final_project.dao.CouponBoxMapper;
import com.puter.final_project.dao.DaddressMapper;
import com.puter.final_project.dao.GradeMapper;
import com.puter.final_project.dao.OrdersMapper;
import com.puter.final_project.dao.UserActivityMapper;
import com.puter.final_project.dao.ShopMapper;
import com.puter.final_project.dao.UserMapper;
import com.puter.final_project.vo.CartVo;
import com.puter.final_project.vo.CouponBoxVo;
import com.puter.final_project.vo.DaddressVo;
import com.puter.final_project.vo.GConditionVo;
import com.puter.final_project.vo.GradeVo;
import com.puter.final_project.vo.OrdersVo;
import com.puter.final_project.vo.ProductVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/")
public class UserController {

	// 자동연결(요청시 마다 Injection)
	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	// 처음에 1회연결
	@Autowired
	UserMapper userMapper;

	@Autowired
	DaddressMapper daddressMapper;

	@Autowired
	CartMapper cartMapper;

	@Autowired
	OrdersMapper ordersMapper;

	@Autowired
	GradeMapper gradeMapper;

	@Autowired
	UserActivityMapper userActivityMapper;
	
	@Autowired
	ShopMapper shopMapper;

	// 회원전체목록
	@RequestMapping("list.do")
	public String list(Model model) {

		List<UserVo> list = userMapper.selectList();

		model.addAttribute("list", list);

		return "home";
	}

	@RequestMapping("login.do")
	public String login(String id, String password, String url, RedirectAttributes ra, Model model) {

		UserVo user = userMapper.selectOneFromId(id);

		// 아이디가 없는(틀린)경우
		if (user == null) {
			ra.addAttribute("reason", "fail_id");
			return "redirect:" + url;
		}

		// 비밀번호가 틀린경우
		if (user.getPassword().equals(password) == false) {
			ra.addAttribute("reason", "fail_password");
			return "redirect:" + url;
		}

		// 로그인처리: 현재 로그인된 객체(user)정보를 session저장
		session.setAttribute("user", user);
		model.addAttribute("showSignUpModal", false);

		if (url != null)
			return "redirect:" + url;

		return "redirect:../home.do";
	}

	// 로그아웃
	@RequestMapping("logout.do")
	public String logout() {

		session.removeAttribute("user");

		return "redirect:../home.do";
	}// end:logout()

	@RequestMapping(value = "check_id.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public String check_id(String id) {

		UserVo vo = userMapper.selectOneFromId(id);

		boolean bResult = false;
		if (vo == null)
			bResult = true;
		else
			bResult = false;

		String json = String.format("{\"result\": %b }", bResult);

		return json;
	}// end:check_id()

	@Autowired
	private CouponBoxMapper couponBoxMapper; // CouponBoxMapper 인스턴스를 주입

	// 회원가입 후 축하 쿠폰 발급 메서드
	private void issueWelcomeCoupon(int userIdx) {
		// cIdx 1번과 3번과 4번인 쿠폰을 발급
		int[] welcomeCouponIdxs = { 1, 2, 3, 4, 5 }; // cIdx 쿠폰 ID 배열

		for (int cIdx : welcomeCouponIdxs) {
			CouponBoxVo couponBox = new CouponBoxVo();
			couponBox.setUseridx(userIdx);
			couponBox.setCidx(cIdx);

			// CouponBoxMapper를 사용해 쿠폰 추가
			int result = couponBoxMapper.insertCouponToBox(couponBox);
			if (result > 0) {
				System.out.println("쿠폰 " + cIdx + "번 추가 성공");
			} else {
				System.out.println("쿠폰 " + cIdx + "번 추가 실패");
			}
		}
	}

	@RequestMapping("insert.do")
	public String insert(UserVo vo) {

		int res = userMapper.insert(vo);

		// 사용자 정보 가져오기 (mk)
		UserVo user = userMapper.selectOneFromId(vo.getId());

		// 쿠폰 발급 처리 (회원가입 축하 쿠폰)(mk)
		issueWelcomeCoupon(user.getUserIdx());

		return "redirect:../home.do";
	}

	@RequestMapping("emailInsert.do")
	public String eminsert(UserVo vo) {

		int res = userMapper.insert(vo);

		UserVo user = userMapper.selectOneFromId(vo.getId());
		vo.setUserIdx(user.getUserIdx());

		res = userMapper.emailInsert(vo);

		user = userMapper.selectOneFromEmail(vo.getEmail(), vo.getEsite());
		session.setAttribute("user", user);

		return "redirect:../home.do";
	}

	@RequestMapping("integration.do")
	public String integration(UserVo vo, String url, RedirectAttributes ra) {

		UserVo user = userMapper.selectOneFromId(vo.getId());
		if (user == null) {
			ra.addAttribute("reason", "fail_id");
			return "redirect:../home.do";
		}
		if (user.getPassword().equals(vo.getPassword()) == false) {
			ra.addAttribute("reason", "fail_password");
			return "redirect:../home.do";
		}
		vo.setUserIdx(user.getUserIdx());
		int res = userMapper.emailInsert(vo);

		session.setAttribute("user", user);

		return "redirect:../home.do";
	}

	@RequestMapping("admin.do")
	public String adminPage(Model model) {

		List<UserVo> userList = userMapper.selectList();
		model.addAttribute("userList", userList);

		return "shopPage/adminMain";
	}

	// 마이페이지 이동
	@RequestMapping("mypage.do")
	public String mypage() {

		UserVo user = (UserVo) session.getAttribute("user");
		if (user == null) {
			return "redirect:../home.do"; // 로그아웃 상태이면 홈으로 리다이렉트
		}

		return "shopPage/mypage";
	}

	@RequestMapping("deliveryAddress.do")
	public String deliveryAddress(Model model) {

		UserVo user = (UserVo) session.getAttribute("user");

		List<DaddressVo> addressList = daddressMapper.selectDaddressUser(user.getUserIdx());

		model.addAttribute("addressList", addressList);

		return "myPage/deliveryAddress";
	}

	@RequestMapping("cart.do")
	public String cart(Model model) {

		UserVo user = (UserVo) session.getAttribute("user");
		List<CartVo> cartList = cartMapper.selectMyCart(user.getUserIdx());
		List<ProductVo> imageList = new ArrayList<ProductVo>();
		//user가 주문한 pIdx가져와서 이미지 추출하기
		for (CartVo cart : cartList) {
			ProductVo image = shopMapper.selectFile(cart.getPIdx());
			imageList.add(image);
		}
		
		model.addAttribute("imageList", imageList);
		model.addAttribute("cartList", cartList);
		

		return "myPage/cart";
	}

	@RequestMapping("purchaseHistory.do")
	public String purchaseHistory(Model model) {
		UserVo user = (UserVo) session.getAttribute("user");

		List<OrdersVo> buyList = ordersMapper.selectList(user.getUserIdx());

		model.addAttribute("buyList", buyList);

		return "myPage/purchaseHistory";
	}

	@RequestMapping("shippingTracking.do")
	public String shippingTracking(Model model) {
		UserVo user = (UserVo) session.getAttribute("user");

		List<OrdersVo> orderList = ordersMapper.selectList(user.getUserIdx());

		model.addAttribute("orderList", orderList);

		return "myPage/shippingTracking";
	}

	@RequestMapping("accountInfo.do")
	public String accountInfo() {
		return "myPage/accountInfo";
	}

	@RequestMapping("userModify.do")
	public String userModify(UserVo vo) {

		int res = userMapper.userModify(vo);

		UserVo user = userMapper.selectOneFromId(vo.getId());

		session.setAttribute("user", user);

		return "redirect:mypage.do";
	}

	@PostMapping("/updateQuantity")
	@ResponseBody
	public ResponseEntity<Map<String, String>> updateQuantity(@RequestParam int scIdx, @RequestParam int scamount) {
		// DB에서 해당 상품의 수량을 업데이트하는 로직 추가
		cartMapper.updateQuantity(scIdx, scamount); // 서비스 메서드 호출

		Map<String, String> response = new HashMap<>();
		response.put("message", "수량이 성공적으로 업데이트되었습니다.");
		return ResponseEntity.ok(response);
	}

	@DeleteMapping("cartDelete.do")
	@ResponseBody
	public ResponseEntity<Map<String, String>> cartDelete(@RequestParam int scIdx) {
		// 장바구니에서 해당 항목 삭제 로직 추가
		int result = cartMapper.cartDelete(scIdx); // DB에서 항목 삭제

		Map<String, String> response = new HashMap<>();
		if (result > 0) {
			response.put("message", "항목이 성공적으로 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("message", "항목 삭제에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

	@RequestMapping("grade.do")
	public String Grade(Model model) {

		UserVo user = (UserVo) session.getAttribute("user");

		GradeVo gvo = gradeMapper.selectOne(user.getUserIdx());
		GConditionVo gcvo = gradeMapper.selectGCodition(gvo.getGIdx()+1);

		model.addAttribute("gvo", gvo);
		model.addAttribute("gcvo", gcvo);



		return "myPage/grade"; // grade.jsp로 이동
	}

	@PostMapping("addAddress.do")
	@ResponseBody
	public ResponseEntity<Map<String, String>> addAddress(@RequestBody DaddressVo daddress) {
		int result = daddressMapper.insertDaddress(daddress);

		Map<String, String> response = new HashMap<>();
		if (result > 0) {
			response.put("message", "주소가 성공적으로 추가되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("message", "주소 추가에 실패했습니다." + daddress.getUserIdx());
			return ResponseEntity.badRequest().body(response);
		}
	}

	@PostMapping("updateAddress.do")
	@ResponseBody
	public ResponseEntity<Map<String, String>> updateAddress(@RequestBody DaddressVo daddress) {
		int result = daddressMapper.updateDaddress(daddress);

		Map<String, String> response = new HashMap<>();
		if (result > 0) {
			response.put("message", "주소가 성공적으로 수정되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("message", "주소 수정에 실패했습니다." + daddress.getUserIdx());
			return ResponseEntity.badRequest().body(response);
		}
	}

	@PostMapping("deleteAddress.do")
	@ResponseBody
	public ResponseEntity<Map<String, String>> deleteAddress(@RequestBody DaddressVo daddress) {
		System.out.println(daddress.getDaIdx());
		int result = daddressMapper.deleteDaddress(daddress.getDaIdx());

		Map<String, String> response = new HashMap<>();
		if (result > 0) {
			response.put("message", "주소가 성공적으로 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("message", "주소 삭제에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

}