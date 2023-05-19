<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");	

	// 현재페이지
	int currentPage = 1;
	// 유효성 검사
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 디버깅 현재페이지 
	System.out.println(currentPage + " <--currentPage");
	
	// 페이지당 출력할 행의 수 = 10개
	int rowPerPage = 10;
	// 시작 행번호
	int startRow = (currentPage-1)*rowPerPage;
	/*
		currentPage		startRow(rowPerPage 10일때)	
		1				0	<-- (currentPage-1)*rowPerPage
		2				10
		3				20
		4				30
	*/

	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");
	
	// 3-1) 쿼리 생성 및 DB로 전송
	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?"); 
	// ? = 2개
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	// 3) 디버깅
	System.out.println(stmt + " <-- stmt");
	// 출력할 공지 데이터를 한 행 단위로 불러옴
	ResultSet rs = stmt.executeQuery();	
	
	// ResultSet타입 → 일반적인 자료구조 타입{ 자바 배열(=정적) or 기본API 자료구조타입(List, Set, Map) }
	// ResultSet -> ArrayList<notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// 마지막 페이지
	// 3-2) 쿼리 생성, DB로 전송, 한 행 단위로 불러옴
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0; 
	
	// 마지막 행값 저장
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	// 총 페이지 수 = 전체 데이터의 개수를 / 한 페이지당 표시할 데이터의 수로 나눈 몫 
	int lastPage = totalRow / rowPerPage;
	// 딱 나누어 떨어지지않을 경우 페이지 하나 추가
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
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
   	<!-- 날짜순 최근 공지 10개 -->
    <div class="container">
	<h1>&#128276; 공지사항 리스트 &#128221;</h1>
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
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>" style="color: #353535" >
						<%=n.noticeTitle%>
					</a>
				</td>
				<td><%=n.createdate.substring(0, 10)%></td>
			</tr>
		<%		
			}
		%>
		</tbody>	
	</table>
	<div class="text-center">
	<%
		if(currentPage > 1) {
	%>
			<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-light">이전</a>
	<%		
		}
	%>
			<%=currentPage%>페이지
	<%	
		if(currentPage < lastPage) {	
	%>
			<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-light">다음</a>
	<%
		}
	%>
	</div>
	</div>
	<div class="container text-center">
		<br>
		<a href="./insertNoticeForm.jsp" class="btn btn-light">공지입력&#9999;</a>
	</div>
</body>
</html>