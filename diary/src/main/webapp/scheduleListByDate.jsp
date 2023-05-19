<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// y, m, d의 값을 확인(디버깅)
	System.out.println(request.getParameter("y") + "<-- scheduleListByDate param y" );
	System.out.println(request.getParameter("m") + "<-- scheduleListByDate param m" );
	System.out.println(request.getParameter("d") + "<-- scheduleListByDate param d" );

	// 유효성 검사
	// y, m, d의 값이 null or "" 이면 → redirecrion scheduleList.jsp
	if(request.getParameter("y") == null 
		|| request.getParameter("y").equals("") 
		|| request.getParameter("m") == null 
		|| request.getParameter("m").equals("")
		|| request.getParameter("d") == null 
		|| request.getParameter("d").equals("")) {
		System.out.println("<--  test" );
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	
	/* 여기는 Calendar API를 쓰지 않으므로 +1 다 해서 데이터베이스에 넘겨줘야됨 */
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m")) + 1; 	// 자바API : 12월 = 11	// 마리아DB : 12월 = 12로 표시되기 때문에 +1 해서 넘겨줘야함
	int d = Integer.parseInt(request.getParameter("d"));
	// 디버깅
	System.out.println(y + " <-- scheduleListByDate 변수 y");
	System.out.println(m + " <-- scheduleListByDate 변수 m");
	System.out.println(d + " <-- scheduleListByDate 변수 d");
	
	// m, d 는 int 타입인데 공백 붙여서 문자로 만들어버리기 ( 숫자 + 문자 = 문자로 인식 ) 	
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0"+strD;
	}
	
	// 일별 스케줄 리스트
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	// 3) 쿼리 생성
	String sql = "select * from schedule where schedule_date = ? order by schedule_time desc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//	?가 1개
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <-- scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate.jsp</title>
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
	<!-- 최근 공지 5개 & 오늘 일정 전체-->
	<div class="container">
	<h1><%=y%>년 <%=m%>월 <%=d%>일</h1>
	<br>
	<h2>&#128198; 오늘 스케줄 입력 &#9999;</h2>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-primary">schedule_date</th>
				<td><input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_time</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_color</th>
				<td><input type="color" name="scheduleColor" value="#000000"></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th class="table-primary">schedule_pw</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
		
		</table>
		<br>
		<!-- 오류발생시 메세지를 붉은색으로 출력 -->
		<div class="text-danger container text-center">
		<%
			if(request.getParameter("msg") != null ){
		%>		
			<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
		
		<br>
		
		<div class="container text-center">
		<button type="submit">스케줄 입력</button>
		</div>
	</form>
	
	<br>
	
	<h2>&#128198; 오늘 스케줄 목록 &#128221;</h2>
	<table class="table table-bordered table-hover">
		<thead class="table-primary">
		<tr>
			<th>schedule_time</th>
			<th>schedule_memo</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		</thead>
		<tbody>
		<%
			 while(rs.next()) {
		%>
				<tr>
					<td><%=rs.getString("schedule_time")%></td>
					<td><%=rs.getString("schedule_memo")%></td>
					<td><%=rs.getString("createdate")%></td>
					<td><%=rs.getString("updatedate")%></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>" style="text-decoration: none;">&#129668;</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>" style="text-decoration: none;">&#9986;</a></td>
				</tr>
		<%
			 }
		%>
		</tbody>
	</table>
	</div>
	
	<br>
		
	<div class="container text-center">	
			<a href="scheduleList.jsp" class="btn btn-light">목록으로 돌아가기</a>
	</div>
</body>
</html>