<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 유효성 코드 추가 -> 분기 -> return
	
			
			
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();		
	/*
	if(rs.next()) {
		
	}
	*/
	rs.next();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm.jsp</title>
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
	<h1>&#128276; 공지 수정 &#129668;</h1>
	<form action="./updateNoticeAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-primary">notice_no</th>
				<td>
					<input type="number" name="noticeNo" 
						value="<%=rs.getInt("notice_no")%>" readonly="readonly"> 
				</td>
			</tr>
			<tr>
				<th class="table-primary">notice_pw</th>
				<td>
					<input type="password" name="noticePw"> 
				</td>
			</tr>
			<tr>
				<th class="table-primary">notice_title</th>
				<td>
					<input type="text" name="noticeTitle" 
						value="<%=rs.getString("notice_title")%>"> 
				</td>
			</tr>
			<tr>
				<th class="table-primary">notice_content</th>
				<td>
					<textarea rows="5" cols="80" name="noticeContent">
						<%=rs.getString("notice_content")%>
					</textarea>
				</td>
			</tr>
			<tr>
				<th class="table-primary">notice_writer</th>
				<td>
					<%=rs.getString("notice_writer")%>
				</td>
			</tr>
			<tr>
				<th class="table-primary">createdate</th>
				<td>
					<%=rs.getString("createdate")%>
				</td>
			</tr>
			<tr>
				<th class="table-primary">updatedate</th>
				<td>
					<%=rs.getString("updatedate")%>
				</td>
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
			<button type="submit">수정</button>
		</div>
		<br>
		<div class="container text-center">	
				<a href="noticeList.jsp" class="btn btn-light">목록으로 돌아가기</a>
		</div>
	</form>
	</div>
</body>
</html>