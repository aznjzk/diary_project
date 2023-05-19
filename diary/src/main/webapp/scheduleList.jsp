<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 요청값에 넘어오지 않으면, 현재 시스템 날짜의 년/월 값을 불러오도록
	if(request.getParameter("targetYear") == null
		|| request.getParameter("targetYear")== ""
		|| request.getParameter("targetMonth")== null
		|| request.getParameter("targetMonth")== ""){
		// 현재 시스템 날짜 정보
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 디버깅
	System.out.println(targetYear + " <-- scheduleList param targetYear");
	System.out.println(targetMonth + " <-- scheduleList param targetMonth");
	
	
	/* 오늘 날짜*/
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	/* targetMonth 해당 월에서 1일의 요일 구하기 */
	Calendar firstDay = Calendar.getInstance();					// 오늘이라 치면 2023 4 24 인데
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);	
	firstDay.set(Calendar.DATE, 1); 							// 2023 4 1 → 강제로 1일이 되도록
	
	// Calendar API 내부적으로 년23|월12 입력 → 년24|월1  이렇게 변경됨
	// Calendar API 내부적으로 년23|월-1 입력 → 년22|월12 이렇게 변경됨 		
	// 내부적으로 바뀐 후의 값을 다시 저장
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	// 디버깅
	System.out.println(targetYear + " <-- api적용 후 targetYear");
	System.out.println(targetMonth + " <-- api적용 후 targetMonth");
	
	// 1일이 몇번째 요일인지 (일1, 토7)	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);			
	
	/* 1일 앞의 비어있는 공백칸의 수*/
	int startBlank = firstYoil - 1;
	// 디버깅
	System.out.println(startBlank + " <-- startBlank");	
	
	/* targetMonth 해당 월에서 마지막일 구하기*/
	// firstDay에 실제로 저장된 º년|º월 에서, 가질 수 있는 날짜 숫자중에 가장 큰값 	( Actual 할당가능한? )
	int lastDate = firstDay.getActualMaximum(Calendar.DATE); 	
	// 디버깅
	System.out.println(lastDate + " <-- lastDate");
	
	
	/* lastDate 날짜 뒤 공백칸의 수*/
	// 전체 TD의 개수를 7로 나눈 나머지의 값은 0이어야한다 → (lastDate + ?) % 7 == 0
	int endBlank = 0;
	// 나누어떨어지지 않을 때 공백칸 추가
	if((startBlank+lastDate) % 7 != 0) {
		endBlank = 7 - (startBlank+lastDate)%7;
	}
	
	/* 이전 달의 마지막 날짜 구하기*/
	int preLastDate = 0;
	Calendar PreMonth = Calendar.getInstance();
	PreMonth.set(Calendar.YEAR, targetYear);
	PreMonth.set(Calendar.MONTH, targetMonth-1);
	preLastDate = PreMonth.getActualMaximum(Calendar.DATE);
	// 디버깅
	System.out.println(preLastDate + " <-- preLastDate");
	
	/* 전체 TD의 개수*/
	int totalTD = startBlank + lastDate + endBlank;
	// 디버깅
	System.out.println(totalTD + " <-- totalTD");
	
	/* DB 접속 */
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	// 2) mariadb에 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");	
	// 3) 쿼리 생성 및 DB로 전송
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");  
	// ? = 2개
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1);
	// 3) 디버깅
	System.out.println(stmt + " <-- stmt");
	// 출력할 데이터를 한 행 단위로 불러옴
	ResultSet rs = stmt.executeQuery();
	
	// ResultSet -> ArrayList<Schedule> 
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체날짜가 아닌 일(Day)만
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList.jsp</title>
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
	
	<div class="container text-center">
	<table class="container">
		<tr>
			<td>
				<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>" class="btn btn-light">이전달</a>
			</td>
			<td>
				<h1>&#128198; <%=targetYear%>년 <%=targetMonth+1%>월 &#128221;</h1>
			</td>
			<td>
				<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>" class="btn btn-light">다음달</a>
			</td>
		</tr>
	</table>
	
	<table style="table-layout:fixed" class="table table-bordered">
		<thead class="table-primary text-center" >
		<tr>
            <th class="text-danger">일</th>
            <th>월</th>
            <th>화</th>
            <th>수</th>
            <th>목</th>
            <th>금</th>
            <th class="text-primary">토</th>      
         </tr>
		</thead>
		<tbody>
		<tr>
		<%
			for(int i=0; i<totalTD; i+=1) {
				// 실제로 출력할 숫자 num
				int num = i - startBlank + 1;
			
				// i가 7로 나누어 떨어지면 줄바꾸기
				if(i != 0 && i%7==0) { 		
		%>
					</tr><tr>
		<%
				}
				/* 날짜가 0보다 크고 마지막 날짜보다 작거나 같을때는 다이어리 적을 수 있는 화면 표시 */
				if(num>0 && num<=lastDate) {
					// 오늘 날짜에만 배경색 지정
					String tdStyle = "";
					if(today.get(Calendar.YEAR) == targetYear
						&& today.get(Calendar.MONTH) == targetMonth
						&& today.get(Calendar.DATE) == num) {
						tdStyle = "background-color: #FAF4C0";
						}
		%>
					<td style="<%=tdStyle%>">
					
					<!-- 날짜 표시 -->
					<div>
		<%
					if(i%7 == 0) {				// 일요일은 빨간색으로 표시
		%>					
						<a class="fw-bold text-danger" 
							href ="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>">
							<%=num%>
						</a>

		<%
					} else if(i%7 == 6) {		// 토요일은 파란색으로 표시
		%>					
						<a class="fw-bold" style="color:blue" 
							href ="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>">
							<%=num%>
						</a>					
		<%
					} else {
		%>													
						<a class="fw-bold" style="color:#353535"
							href ="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>">
							<%=num%>
						</a>
		<%
					}	
		%>			
					</div>
					
					<!-- 일정 memo(5글자만) -->
					<div>
		<%
						for(Schedule s : scheduleList) {
							if(num == Integer.parseInt(s.scheduleDate)) {
		%>
							<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
		<%
							}
						}
		%>
					</div>
				</td>
		<%				 
					// 시작 날짜보다 작으면 활성 없는 회색으로 표시
					} else if(num < 1) {
						if(i%7 == 0){	// 일요일은 활성없는 빨강
		%>
						<td class="text-danger">
							<%=num + preLastDate%>
						</td>
		<%
						} else if (i%7 == 6){	// 토요일은 활성없는 파랑
		%>			
						<td style="color:blue">
							<%=num + preLastDate%>
						</td>
		<%
						} else {
		%>			
						<td class="text-muted">
							<%=num + preLastDate%>
						</td>
		<%
						}
			
					// 마지막 날짜보다 크면 활성 없는 회색으로 표시
					} else if(num > lastDate) {
						if(i%7 == 0){	// 일요일은 활성없는 빨강
		%>
						<td class="text-danger">
							<%=num - lastDate%>
						</td>
		<%
						} else if (i%7 == 6){	// 토요일은 활성없는 파랑
		%>			
						<td style="color:blue">
							<%=num - lastDate%>
						</td>
		<%
						} else {
		%>			
						<td class="text-muted">
							<%=num - lastDate%>
						</td>
		<%
					}
				}
			}
		%>
		</tr>
		</tbody>
	</table>
	</div>
	<br>
</body>
</html>