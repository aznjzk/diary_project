<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 유효성 검사
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; 
	}
	// 요청값이 null 또는 공백이 아닐때 변수에 할당(형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");

	// 3) 쿼리 실행 
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	// sql1 쿼리문이 DB로 전송됨
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 1개
	stmt.setInt(1, noticeNo);
	// 3) 디버깅
	System.out.println(stmt + " <-- stmt");
	
	// 한 행 단위로 불러옴
	ResultSet rs = stmt.executeQuery();
	
	// 하나만 출력해서 보여주는거니까 while할 필요 없음
	Notice n = null;
	if(rs.next()) {
		n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeOne.jsp</title>
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
	<h1>&#128276; 공지 상세 &#128270;</h1>
	<table class="table table-bordered" >
		<tr>
			<th class="table-primary">notice_no</th>
			<td><%=n.noticeNo%></td>
		</tr>
		<tr>
			<th class="table-primary">notice_title</th>
			<td><%=n.noticeTitle%></td>
		</tr>
		<tr>
			<th class="table-primary">notice_content</th>
			<td><%=n.noticeContent%></td>
		</tr>
		<tr>
			<th class="table-primary">notice_writer</th>
			<td><%=n.noticeWriter%></td>
		</tr>
		<tr>
			<th class="table-primary">createdate</th>
			<td><%=n.createdate%></td>
		</tr>
		<tr>
			<th class="table-primary">updatedate</th>
			<td><%=n.updatedate%></td>
		</tr>
	</table>
	</div>
	
	<br>
	
	<div class="container text-center">
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-light">수정&#129668;</a>
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-light">삭제&#9986;</a>
	</div>
	<br>
	<div class="container text-center">	
			<a href="noticeList.jsp" class="btn btn-light">목록으로 돌아가기</a>
	</div>
</body>
</html>