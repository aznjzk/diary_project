<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 유효성 검사
	// noticeNo으로 들어온게 아니면 첫 페이지로 돌아가기
	if(request.getParameter("noticeNo") == null 
		|| request.getParameter("noticeNo").equals("")) {
	response.sendRedirect("/noticeList.jsp");
	return;
	}
	
	// noticePw을 입력하지 않았을때 오류 메세지 할당
	String msg = null;
	if(request.getParameter("noticePw") == null 
			|| request.getParameter("noticePw").equals("")) {
			msg = "password is required";
	}
	// 오류 메세지를 출력하고 삭제페이지 재요청
	if(msg != null) { 
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" +request.getParameter("noticeNo") +"&msg="+msg);
        return;
	}
	
	// 요청값이 null 또는 공백이 아니면 변수에 할당(형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");	
	//디버깅 
	System.out.println(noticeNo + " <-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + " <-- deleteNoticeAction param noticePw");
	   
	// 값들을 DB에 입력
	// 1) 장치드라이버를 로딩      
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받음
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");
	
	// 3) 쿼리 생성
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	// sql 쿼리문이 DB로 전송됨
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? = 2개
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	// 3) 디버깅
	System.out.println(stmt + " <-- deleteNoticeAction sql");
	
	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅
	System.out.println(row + " <-- deleteNoticeAction row");
	
	// 비빌번호 틀려서 삭제행이 0행이면,
	if(row == 0) {		// 삭제 페이지 재요청 및 오류메세지 출력
		msg = "password is wrong";
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=" + msg);
		return;
	} else {			// 비밀번호 맞아서 삭제가 완료되면 목록으로 돌아가기
		response.sendRedirect("./noticeList.jsp");
	}
%>