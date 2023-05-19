<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
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
	<h1>&#128276; 공지 입력 &#9999;</h1>
	<form action="./insertNoticeAction.jsp" method="post">
	<table class="table table-bordered">
		<tr>
			<th class="table-primary">notice_title</th>
			<td>
				<input type="text" name="noticeTitle">
			</td>
		</tr>
		<tr>
			<th class="table-primary">notice_content</th>
			<td>
				<textarea rows="5" cols="80" name="noticeContent"></textarea>
			</td>
		</tr>
		<tr>
			<th class="table-primary">notice_writer</th>
			<td>
				<input type="text" name="noticeWriter">
			</td>
		</tr>
		<tr>
			<th class="table-primary">notice_pw</th>
			<td>
				<input type="password" name="noticePw">
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
			<button type="submit">입력</button>
		</div>
		<br>
		<div class="container text-center">	
			<a href="noticeList.jsp" class="btn btn-light">목록으로 돌아가기</a>
		</div>
	</form>
	</div>
</body>
</html>