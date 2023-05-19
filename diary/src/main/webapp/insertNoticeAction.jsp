<%@ page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "jakarta.security.auth.message.callback.PrivateKeyCallback.Request"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<% 
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeTitle") + " <-- insertNoticeAction param noticeTitle");
	System.out.println(request.getParameter("noticeContent") + " <-- insertNoticeAction param noticeContent");
	System.out.println(request.getParameter("noticeWriter") + " <-- insertNoticeAction param noticeWriter"); 
	System.out.println(request.getParameter("noticePw") + " <-- insertNoticeAction param noticePw");


	// 유효성검사 -> 잘못된 결과 -> 분기 -> 코드진행종료(return)
	// -> 리다이렉션(insertNoticeForm.jsp?&msg=)
	String msg = null;
	if(request.getParameter("noticeTitle") == null 
			|| request.getParameter("noticeTitle").equals("")) {
			msg = "notice_title is required";
	} else if(request.getParameter("noticeContent") == null 
			|| request.getParameter("noticeContent").equals("")) {
			msg = "notice_content is required";
	} else if(request.getParameter("noticeWriter") == null 
			|| request.getParameter("noticeWriter").equals("")) {
			msg = "notice_writer is required";
	} else if(request.getParameter("noticePw") == null 
			|| request.getParameter("noticePw").equals("")) {
			msg = "password is required";
	}
	if(msg != null) { // 위 ifelse문에 하나라도 해당된다
		response.sendRedirect("./insertNoticeForm.jsp?"
								+"&msg="+msg);
		return;
	}
	
	// 요청값들을 변수에 할당
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	// 디버깅
	System.out.println(noticeTitle + " <--insertNoticeAction noticeTitle");
	System.out.println(noticeContent + " <--insertNoticeAction noticeContent");
	System.out.println(noticeWriter + " <--insertNoticeAction noticenoticeWriter");
	System.out.println(noticePw + " <--insertNoticeAction noticePw");
		
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
		/* 
		INSERT INTO 테이블이름 ( 열1,열2,열3,열4 ….)
		SELECT 테이블에 들어갈 값
		FROM selct값을 구하기 위한 테이블
		WHERE 조건
		*/
	String sql = "insert into notice(notice_title, notice_content, notice_writer, createdate, updatedate) values(?,?,?,now(),now())";
	// sql 쿼리문이 DB로 전송됨
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	// conn.commit(); //conn.setAutoCommit(true); 디폴트값이 true라 자동 commit되어 생략 가능
	// 3) 디버깅
	System.out.println(stmt + " <-- insertNoticeAction sql");
	
	
	// 4) 데이터베이스에서 영향받은 행 수 반환
	int row = stmt.executeUpdate();
	// 4) 디버깅
	System.out.println(row + " <-- insertNoticeAction row");
	
	// 입력행이 0행이면,
	if(row == 0) {		// 입력 페이지 재요청 
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	} else {			// 입력이 완료되면 목록으로 돌아가기
		response.sendRedirect("./noticeList.jsp");
	}

%>