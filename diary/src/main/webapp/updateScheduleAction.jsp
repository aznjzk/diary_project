<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 각 항목마다 유효성 검사
	// scheduleNo으로 들어온게 아니면 첫 페이지로 돌아가기
	if(request.getParameter("scheduleNo")==null) {
        response.sendRedirect("./scheduleList.jsp");
        return;	
	}
		String msg = null;
	    // scheduleDate을 입력하지 않았을때 메세지
		if(request.getParameter("scheduleDate")==null 
				|| request.getParameter("scheduleDate").equals("")) {
				msg = "scheduleDate is required";
		// scheduleTime 입력하지 않았을때 메세지
		} else if(request.getParameter("scheduleTime")==null 
				|| request.getParameter("scheduleTime").equals("")) {
				msg = "scheduleTime is required";
		// scheduleMemo 입력하지 않았을때 메세지
		} else if(request.getParameter("scheduleMemo")==null 
				|| request.getParameter("scheduleMemo").equals("")) {
				msg = "scheduleMemo is required";
		// scheduleColor 입력하지 않았을때 메세지
		} else if(request.getParameter("scheduleColor")==null 
				|| request.getParameter("scheduleColor").equals("")) {
				msg = "scheduleColor is required";
		// schedulePw을 입력하지 않았을때 메세지
		} else if(request.getParameter("schedulePw")==null 
				|| request.getParameter("schedulePw").equals("")) {
				msg = "password is required";
		}
		
	    // 위의 if else문에 하나라도 해당된다면 메세지를 출력하고 수정페이지 재요청
		if(msg != null) { 
			response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
									+request.getParameter("scheduleNo")
									+"&msg="+msg);
	        return;
		}
	
	// 요청값이 null 또는 공백이 아니면 변수에 저장(형변환)
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅
	System.out.println(scheduleNo + " <-- updateScheduleAction param scheduleNo");
	System.out.println(scheduleDate + " <-- updateScheduleAction param scheduleDate");
	System.out.println(scheduleTime + " <-- updateScheduleAction param scheduleTime");
	System.out.println(scheduleMemo + " <-- updateScheduleAction param scheduleMemo");
	System.out.println(scheduleColor + " <-- updateScheduleAction param scheduleColor");
	System.out.println(schedulePw + " <-- updateScheduleAction param schedulePw");
	
	
	// 값들을 DB 테이블에 입력
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");

	// 3) 쿼리 생성	
	// UPDATE [테이블] SET [열]= '변경할값'
	String sql = "update schedule set schedule_date=? , schedule_time=? , schedule_memo=? , schedule_color=? , updatedate=now() where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? : 6개
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	// 3) 디버깅
	System.out.println(stmt + " <-- updateScheduleAction stmt");

	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅  // 1이면 1행 수정 성공, 0이면 수정된 행이 없다"
	System.out.println(row + " <-- updateScheduleAction row");
	
	// DB에서 수정된 행의 개수 확인
	if(row == 0) {		// 0개면 수정화면 재요청
		msg = "password is wrong";
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg); 
	} else { 			// 1개면 수정 성공 → 목록으로 돌아가기
		response.sendRedirect("./scheduleList.jsp"); 
	}

%>