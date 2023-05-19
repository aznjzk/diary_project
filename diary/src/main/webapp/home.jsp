<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");
	
	// 3) 쿼리 실행 
	// 3-1) 쿼리 생성 - 최근 공지 5개 : 날짜 내림차순 정렬
	String sql1 = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC LIMIT 0, 5";
	// sql1 쿼리문이 DB로 전송됨
	PreparedStatement stmt1 = conn.prepareStatement(sql1); 
	// 3-1) 디버깅
	System.out.println(stmt1 + " <-- stmt1");
	// 3-1) 한 행 단위로 불러옴
	ResultSet rs1 = stmt1.executeQuery();
	
	// 3-1) ResultSet -> ArrayList<notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs1.next()) {
		Notice n = new Notice();
		n.noticeNo = rs1.getInt("noticeNo");
		n.noticeTitle = rs1.getString("noticeTitle");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
	}
	
	// 3-2) 쿼리 생성 - 오늘 일정 전체
	String sql2 = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, SUBSTR(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor FROM schedule WHERE schedule_date = CURDATE() ORDER BY schedule_time ASC";
	// sql2 쿼리문이 DB로 전송됨
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	// 3-2) 디버깅
	System.out.println(stmt2 + " <-- stmt2");
	// 3-2) 한 행 단위로 불러옴
	ResultSet rs2 = stmt2.executeQuery();
	// 3-2) ResultSet -> ArrayList<Schedule> 
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs2.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleDate = rs2.getString("scheduleDate"); // 전체날짜가 아닌 일(Day)만
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("scheduleMemo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs2.getString("scheduleColor");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
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
	<h1>&#128276; 공지사항</h1>
	<table class="table table-bordered table-hover">
		<thead class="table-primary">
			<tr>
				<th>notice_title</th>
				<th>createdate</th>
			</tr>
		</thead>
		<tbody>
		<%
			for(Notice n : noticeList) {
		%>
			<tr>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>" style="color: #353535">
					<%=n.noticeTitle%>
					</a>
				</td>
				<td>
					<%=n.createdate.substring(0, 10)%>
				</td>
			</tr>
		<%      
			}
		%>
		</tbody>	
	</table>
	</div>
	
	<br>
	
	<div class="container">
	<h1>&#128198; 오늘일정</h1>
	<table class="table table-bordered table-hover">
		<thead class="table-primary">
			<tr>
				<th>schedule_date</th>
				<th>schedule_time</th>
				<th>schedule_memo</th>
			</tr>
		</thead>
		<tbody>
		<%
			for(Schedule s : scheduleList) {
		%>
			<tr>
				<td>
					<a href="./scheduleList.jsp?scheduleNo=<%=s.scheduleNo%>" 
						style="color:<%=s.scheduleColor%>"><%=s.scheduleDate%>
					</a>
				</td>
				<td>
					<%=s.scheduleTime%>
				</td>
				<td>
					<%=s.scheduleMemo%> &nbsp; . . . 생략
				</td>
			</tr>
		<%
			}
		%>
		</tbody>
	</table>
	</div>
	<br>
	<div class="container">
	<h1>&#128214; Diary Project</h1>
	<br>
	<table class="table table-bordered" style="color:#353535">
		<tr class="table-primary fw-bold"><td> [ 프로젝트 내용 ]</td></tr>
		<tr><td> 1. mariadb를 이용하여 데이터 테이블 만들기 </td></tr>
		<tr><td> 2. SQL - DML 쿼리문(Select, Insert, Delete, Update)을 이용하여 공지사항 또는 일정을 조회, 입력, 삭제, 수정할 수 있는 페이지 만들기 </td></tr>
		<tr><td> 3. 기본API Calendar를 이용하여 달력 만들기  </td></tr>
		<tr><td> 4. 달력에 데이터 테이블을 연결시켜 일정 미리보기 </td></tr>
		<tr><td> 5. Bootstrap5를 이용하여 CSS하기 </td></tr>
	</table>
	<table class="table table-bordered" style="color:#353535">
		<tr class="table-primary fw-bold"><td>[ 개발환경 ]</td></tr>
		<tr><td> Eclipse(2022-12), JDK(17.0.6), Mariadb (10.5.19), Apache Tomcat(10), HeidiSQL </td></tr>
	</table>
	<table class="table table-bordered" style="color:#353535">	
		<tr class="table-primary fw-bold"><td>[ 사용언어 ]</td></tr>
		<tr><td> java, sql, html, css, bootstrap5</td></tr>
	</table>
	</div>
	 <br>
</body>
</html>