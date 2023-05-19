<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNo") + " <-- updateNoticeAction param noticeNo");
	System.out.println(request.getParameter("noticeTitle") + " <-- updateNoticeAction param noticeTitle");
	System.out.println(request.getParameter("noticeContent") + " <-- updateNoticeAction param noticeContent");
	System.out.println(request.getParameter("noticePw") + " <-- updateNoticeAction param noticePw");


	// 3. 2번 유효성검정 -> 잘못된 결과 -> 분기 -> 코드진행종료(return)
	// -> 리다이렉션(updateNoticeForm.jsp?noticeNo=&msg=)
	String msg = null;
	if(request.getParameter("noticeTitle") == null 
			|| request.getParameter("noticeTitle").equals("")) {
			msg = "notice_title is required";
	} else if(request.getParameter("noticeContent") == null 
			|| request.getParameter("noticeContent").equals("")) {
			msg = "notice_content is required";
	} else if(request.getParameter("noticePw") == null 
			|| request.getParameter("noticePw").equals("")) {
			msg = "password is required";
	}
	if(msg != null) { // 위 ifelse문에 하나라도 해당된다
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
								+request.getParameter("noticeNo")
								+"&msg="+msg);
		return;
	}
	
	// 4. 요청값들을 변수에 할당(형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	System.out.println(noticeNo
			+" <--updateNoticeAction noticeNo");
	System.out.println(noticeTitle
			+" <--updateNoticeAction noticeTitle");
	System.out.println(noticeContent
			+" <--updateNoticeAction noticeContent");
	System.out.println(noticePw
			+" <--updateNoticeAction noticePw");
		
	// 값들을 DB 테이블에 입력
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 1) 디버깅 
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 2) 디버깅
	System.out.println(conn + " <-- 접속성공");

	// 3) 쿼리 생성	
	// UPDATE [테이블] SET [열]= '변경할값'
	String sql = "update notice set notice_title=? , notice_content=? , updatedate=now() where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	// 3) 디버깅
	System.out.println(stmt + " <-- updatenoticeAction sql");

	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅  // 1이면 1행 수정 성공, 0이면 수정된 행이 없다"
	System.out.println(row + " <-- updatenoticeAction row");
	
	// DB에서 수정된 행의 개수 확인
	if(row == 0) {			// 위에서 문제가 없었으므로 pw가 틀린것 → // 수정 페이지 재요청 및 오류메세지 출력
		msg = "password is wrong";
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=" + msg);
		return;
	} else {				// 비밀번호 맞아서 수정이 완료되면, 상세페이지로 돌아간다.
		response.sendRedirect("./noticeOne.jsp?noticeNo=" + noticeNo);
	}
%>