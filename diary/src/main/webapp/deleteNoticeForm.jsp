<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 유효성 검사
	// noticeNo으로 들어온게 아니면 목록 페이지로 돌아가기
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
	return; 
	}
	// 요청값이 null 또는 공백이 아닐때 변수에 할당(형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅
    System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm.jsp</title>
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
	<h1>&#128276; 공지 삭제 &#9986;</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
	<table class="table table-bordered table-hover">
		<tr>
			<th class="table-primary">notice_no</th>
			<td>
				<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
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
		<div class="text-danger text-center">
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
			<button type="submit">삭제</button>
		</div>

		<br>
		
		<div class="container text-center">	
				<a href="noticeList.jsp" class="btn btn-light">목록으로 돌아가기</a>
		</div>
	</form>
	</div>
</body>
</html>