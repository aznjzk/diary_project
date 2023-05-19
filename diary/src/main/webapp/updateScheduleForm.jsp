<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 요청값 유효성 검사
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 요청값이 null이거나 공백이 아니면 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅
	System.out.println(scheduleNo + " <-- updatescheduleForm param scheduleNo");
	
	// DB연결 설정
	// 1) 장치 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");
	
	// 3) 쿼리 생성 : schedule_no의 값이 같을때만!
	String sql = "select schedule_no, schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate, schedule_pw from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo); // stmt의 첫 번째 ? -> scheduleNo
	// 3) 디버깅
	System.out.println(stmt + " <-- stmt");
	
	// 저장된 값 가져오기
	ResultSet rs = stmt.executeQuery();	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateScheduleForm.jsp</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
   
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<br>
	<!-- 메인메뉴 -->
	<nav class="navbar container">
		<div class="container-fluid">
		<ul class="navbar-nav">
		<li class="nav-item">
			<a class="nav-link" href="./home.jsp">&#127968; 홈으로</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="./noticeList.jsp">&#128276; 공지 리스트</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="./scheduleList.jsp">&#128198; 일정 리스트</a>
		</li>
		</ul>
		</div>
	</nav>
	
	<br>
   
	<div class="container">
	<h1>&#128198; 일정 수정 &#129668;</h1>
	<form action="./updateScheduleAction.jsp" method="post">
		<table class="table table-bordered">
		<%
			while(rs.next()) {
		%>
			<tr>
			<th class="table-primary">schedule_date</th>
				<td>
					<input type="hidden" name="scheduleNo" value="<%=rs.getString("schedule_no") %>">
					<input type="date" name="scheduleDate" value="<%=rs.getString("schedule_date") %>">
				</td>
			</tr>
			<tr>
				<th class="table-primary">schedule_time</th>
				<td><input type="time" name="scheduleTime" value="<%=rs.getString("schedule_time") %>"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_pw</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_color</th>
				<td><input type="color" name="scheduleColor" value="<%=rs.getString("schedule_color") %>"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_memo</th>
				<td><textarea rows="10" cols="50" name="scheduleMemo"><%=rs.getString("schedule_memo") %></textarea></td>
			</tr>
		<%		
			}
		%>
		</table>
			
		<br>
		<!-- 오류발생시 메세지를 붉은색으로 출력 -->
		<div class="text-center container text-danger">
		<%
			if(request.getParameter("msg") != null ){
		%>		
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
		
		<br>
		
		<!-- 수정 버튼 누르면 DB데이터 수정 -->
		<div class="container text-center">
			<button type="submit">수정</button>
		</div>
		
		<br>
		
		<!-- 이전 화면으로 돌아갈 수 있는 버튼 추가 -->
		<div class="container text-center">
			<a href="./scheduleList.jsp" class="btn btn-light">목록으로 돌아가기</a>
		</div>	
	</form>
	</div>
</body>
</html>