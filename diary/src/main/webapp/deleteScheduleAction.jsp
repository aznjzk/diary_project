<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 유효성 검사
	// scheduleNo으로 들어온게 아니면 목록 페이지로 돌아가기
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("scheduleNo").equals("")) {
     response.sendRedirect("./scheduleList.jsp");
     return;	
	}
	
	// schedulePw을 입력하지 않았을때 오류 메세지 할당
	String msg = null;
	if(request.getParameter("schedulePw") == null 
			|| request.getParameter("schedulePw").equals("")) {
			msg = "password is required";
	}
	// 오류 메세지를 출력하고 삭제페이지 재요청
	if(msg != null) { 
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + request.getParameter("scheduleNo") +"&msg="+msg);
        return;
	}
	
	
	// 요청값이 null 또는 공백이 아니면 변수에 할당(형변환)
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅
	System.out.println(scheduleNo + " <-- deletescheduleAction param scheduleNo");
	System.out.println(schedulePw + " <-- deletescheduleAction param schedulePw");
	
	// 값들을 DB에 입력
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");

	// 3) 쿼리 생성	
	String sql = "delete from schedule where schedule_no=? and schedule_pw=?";
	// sql 쿼리문이 DB로 전송됨
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? = 2개
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	// 3) 디버깅
	System.out.println(stmt + " <-- deletescheduleAction sql");

	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅
	System.out.println(row + " <-- deletescheduleAction row");

	
	// 비밀번호 틀려서 삭제행이 0행일때
	if(row == 0) {		// 삭제 페이지 재요청 및 오류메세지 출력
		msg = "password is wrong";
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg); 
		return;
	} else { 			// 비밀번호 맞아서 삭제가 완료되면, 목록으로 돌아가기
		response.sendRedirect("./scheduleList.jsp"); 
	}	
%>