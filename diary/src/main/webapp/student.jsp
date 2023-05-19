<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	// select 쿼리를 mariadb에 전송 후 결과셋을 받아서 출력하는 페이지
	// select notice_no, notice_title from notice order bu notice_no desc
	
	// 1) mariadb 프로그램을 사용가능하도록 장치드라이버를 로딩(=메모리에 올린다)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null; // 접속정보 타입
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234"); 
	System.out.println("접속 성공" + conn);
	
	// 3) 쿼리 생성
	String sql = "select s_no, s_name, s_age from student";
	PreparedStatement stmt = conn.prepareStatement(sql); // 위에 문자열을 진짜 쿼리로 바꿔서 conn에 넣어주는것
	ResultSet rs = stmt.executeQuery();
	System.out.println("쿼리실행성공" + rs);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>studentList.jsp</title>
</head>
<body>
	<table border='1'>
		<tr>
			<th>s_no</th>
			<th>s_name</th>
			<th>s_age</th>
		</tr>
		
		<%
			while(rs.next()) {
		%>
				<tr>
					<td><%=rs.getInt("s_no")%></td>
					<td><%=rs.getString("s_name")%></td>
					<td><%=rs.getInt("s_age")%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>