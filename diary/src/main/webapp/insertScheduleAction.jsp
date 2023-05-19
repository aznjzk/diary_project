<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("utf-8");
	
	// 5개의 값을 확인(디버깅)
	System.out.println(request.getParameter("scheduleDate") + " <-- insertScheduleAction param scheduleDate");
	System.out.println(request.getParameter("scheduleTime") + " <-- insertScheduleAction param scheduleTime");
	System.out.println(request.getParameter("scheduleMemo") + " <-- insertScheduleAction param scheduleMemo"); 
	System.out.println(request.getParameter("scheduleWriter") + " <-- insertScheduleAction param scheduleWriter"); 
	System.out.println(request.getParameter("schedulePw") + " <-- insertScheduleAction param schedulePw");

	// 당일 scheduleListByDate.jsp로 Redirect하기 위한 날짜변수 설정 
	String scheduleDate = request.getParameter("scheduleDate");
	
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1; 	// -1 해줘야해서 int로 타입 변환
	String d = scheduleDate.substring(8);
	// 디버깅
	System.out.println(y + " <-- insertScheduleAction y");
	System.out.println(m + " <-- insertScheduleAction m");
	System.out.println(d + " <-- insertScheduleAction d");
	
	// 유효성검사 -> 잘못된 결과 -> 분기 -> 코드진행종료(return)
	// -> 리다이렉션(scheduleListByDate.jsp?&msg=)
	String msg = null;
	if(request.getParameter("scheduleTime") == null 
			|| request.getParameter("scheduleTime").equals("")) {
			msg = "schedule_time is required";
	} else if(request.getParameter("scheduleMemo") == null 
			|| request.getParameter("scheduleMemo").equals("")) {
			msg = "schedule_memo is required";
	} else if(request.getParameter("scheduleColor") == null 
			|| request.getParameter("scheduleColor").equals("")) {
			msg = "schedule_color is required";
	} else if(request.getParameter("schedulePw") == null 
			|| request.getParameter("schedulePw").equals("")) {
			msg = "password is required";
	}
	 // 위 if else문에 하나라도 해당된다면 → 당일 scheduleListByDate.jsp로 Redirect
	if(msg != null) {
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d
								+"&msg="+msg);
		return;
	}
	
	// 요청값들을 변수에 할당
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅
	System.out.println(scheduleDate + " <-- insertScheduleAction scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction scheduleTime");
	System.out.println(scheduleMemo + " <-- insertScheduleAction scheduleMemo");
	System.out.println(scheduleColor + " <-- insertScheduleAction scheduleColor");
	System.out.println(scheduleColor + " <-- insertScheduleAction scheduleColor");
	
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
	String sql = "insert into schedule (schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//	?가 4개
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	// 3) 디버깅
	System.out.println(stmt + " <-- insertScheduleAction stmt");

	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅  // 1이면 1행 수정 성공, 0이면 수정된 행이 없다"
	if(row==1) {
		System.out.println(" insertScheduleAction 정상 입력");
	} else {
		System.out.println(" insertScheduleAction 비정상적인 입력" + row);
	}
	
	
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);

	
%>
