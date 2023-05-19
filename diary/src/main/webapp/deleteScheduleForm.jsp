<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 유효성 검사
	if(request.getParameter("scheduleNo") == null 
		|| request.getParameter("scheduleNo") == ""){
	    response.sendRedirect("./scheduleList.jsp");
	    return; 
	 }
	// 요청값이 null 또는 공백이 아닐때 변수에 할당(형변환)
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅
	System.out.println(scheduleNo + " <-- deleteScheduleForm param scheduleNo");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleAction.jsp</title>
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
	<h1 class="center">&#128198; 일정 삭제 &#9986;</h1>
	<form action="./deleteScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th class="table-primary">schedule_no</th>
				<td>
					<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-primary">password</th>
				<td>
					<input type="password" name="schedulePw">
				</td>
			</tr>
			</table>
			
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
			
			<!-- 삭제 버튼 누르면 DB데이터 삭제 -->
			<div class="text-center">
				<button type="submit">삭제</button>
			</div>
			
			<br>
		
			<!-- 일정리스트 페이지로 돌아갈 수 있는 버튼-->
			<div class="text-center">
				<a href="./scheduleList.jsp" class="btn btn-light">목록으로 돌아가기</a>
			</div>
	</form>
	</div>
</body>
</html>