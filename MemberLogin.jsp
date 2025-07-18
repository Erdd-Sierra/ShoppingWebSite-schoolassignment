<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<%-- POSTリクエスト（フォーム送信時）のみ処理を実行 --%>
<c:if test="${pageContext.request.method == 'POST'}">
    <%-- 新規会員登録フォームからのデータかを確認 --%>
    <c:if test="${not empty param.register_submit}">
        <c:set var="name" value="${param.name}" />
        <c:set var="email" value="${param.email}" />
        <c:set var="password" value="${param.password}" />
        <c:set var="passwordConfirm" value="${param.password_confirm}" />

        <c:if test="${password != passwordConfirm}">
            <c:set var="message" value="パスワードと確認用パスワードが一致しません．" scope="request" />
            <c:set var="messageClass" value="error" scope="request" />
        </c:if>
        <c:if test="${empty message}">
            <sql:query var="existingUser" dataSource="${dataSource}">
                SELECT COUNT(*) AS count FROM CUSTOMER_INFO WHERE EMAIL = ?;
                <sql:param value="${email}" />
            </sql:query>
            <c:if test="${existingUser.rows[0].count > 0}">
                <c:set var="message" value="このメールアドレスは既に登録されています．" scope="request" />
                <c:set var="messageClass" value="error" scope="request" />
            </c:if>
        </c:if>

        <c:if test="${empty message}">
            <sql:update var="rowCount" dataSource="${dataSource}">
                INSERT INTO CUSTOMER_INFO (CUSTOMER_NAME, EMAIL, PASSWORD, REGISTRATION_DATE) VALUES (?, ?, ?, CURRENT_TIMESTAMP);
                <sql:param value="${name}" />
                <sql:param value="${email}" />
                <sql:param value="${password}" />
            </sql:update>
            <c:if test="${rowCount == 1}">
                <c:set var="message" value="会員登録が完了しました！ログインしてください．" scope="request" />
                <c:set var="messageClass" value="success" scope="request" />
                <%-- 登録成功時は入力値をクリア --%>
                <c:set var="param.name" value="" scope="request" />
                <c:set var="param.email" value="" scope="request" />
            </c:if>
            <c:if test="${rowCount != 1}">
                <c:set var="message" value="会員登録に失敗しました．もう一度お試しください．" scope="request" />
                <c:set var="messageClass" value="error" scope="request" />
            </c:if>
        </c:if>
    </c:if>

    <%-- ログインフォームからのデータかを確認 --%>
    <c:if test="${not empty param.login_submit}">
        <c:set var="loginEmail" value="${param.login_email}" />
        <c:set var="loginPassword" value="${param.login_password}" />

        <sql:query var="customerLogin" dataSource="${dataSource}">
            SELECT CUSTOMER_CODE, CUSTOMER_NAME, EMAIL FROM CUSTOMER_INFO WHERE EMAIL = ? AND PASSWORD = ?;
            <sql:param value="${loginEmail}" />
            <sql:param value="${loginPassword}" />
        </sql:query>

        <c:if test="${not empty customerLogin.rows[0]}">
            <%-- ログイン成功: セッションに顧客情報を保存 --%>
            <c:set var="loggedInCustomer" value="${customerLogin.rows[0]}" scope="session" />
            <c:set var="message" value="ログインしました！" scope="request" />
            <c:set var="messageClass" value="success" scope="request" />

            <%-- ログイン後にリダイレクトすべきページがあればそこへ遷移 --%>
            <c:if test="${not empty param.redirect_to}">
                <c:redirect url="${param.redirect_to}" />
            </c:if>
            <%-- なければマイページへ --%>
            <c:if test="${empty param.redirect_to}">
                <c:redirect url="MyPage.jsp" />
            </c:if>
        </c:if>
        <c:if test="${empty customerLogin.rows[0]}">
            <%-- ログイン失敗 --%>
            <c:set var="message" value="メールアドレスまたはパスワードが正しくありません．" scope="request" />
            <c:set var="messageClass" value="error" scope="request" />
        </c:if>
    </c:if>
</c:if>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - ログイン / 会員登録</title>
    <link rel="stylesheet" type="text/css" href="TopPageStyles.css">
</head>
<body>
    <header>
        <div class="header-inner">
            <a href="TopPage.jsp">
                <h1 class="site-title">Suncat Wear</h1>
            </a>
            <div class="header-icons">
                <a href="Cart.jsp" class="icon-link">
                    <img src="image/cart_icon.png" alt="カート" width="32" height="32">
                    <span class="icon-name">カート</span>
                </a>
                <a href="MemberLogin.jsp" class="icon-link">
                    <img src="image/user_icon.png" alt="マイページ" width="32" height="32">
                    <span class="icon-name">マイページ</span>
                </a>
            </div>
        </div>
    </header>

    <div class="container">
        <main class="main-content">
            <section class="auth-section">
                <h2>ログイン / 会員登録</h2>
                <%-- ログイン・登録メッセージの表示 --%>
                <c:if test="${not empty message}">
                    <p class="message ${messageClass}">${message}</p>
                </c:if>
                <div class="auth-forms-wrapper">
                    <div class="form-wrapper login-form">
                        <h3>ログイン</h3>
                        <form action="MemberLogin.jsp" method="post" class="standard-form">
                            <div class="form-group">
                                <label for="login-email">メールアドレス</label>
                                <input type="email" id="login-email" name="login_email" placeholder="your@example.com" required value="${param.login_email}">
                            </div>
                            <div class="form-group">
                                <label for="login-password">パスワード</label>
                                <input type="password" id="login-password" name="login_password" required>
                            </div>
                            <div class="form-actions">
                                <button type="submit" name="login_submit" value="true" class="btn-primary">ログイン</button>
                            </div>
                            <c:if test="${not empty param.redirect_to}">
                                <input type="hidden" name="redirect_to" value="${param.redirect_to}">
                            </c:if>
                        </form>
                    </div>

                    <div class="form-wrapper register-form">
                        <h3>新規会員登録</h3>
                        <form action="MemberLogin.jsp" method="post" class="standard-form">
                            <div class="form-group">
                                <label for="register-name">お名前</label>
                                <input type="text" id="register-name" name="name" placeholder="山田 太郎" required value="${param.name}">
                            </div>
                            <div class="form-group">
                                <label for="register-email">メールアドレス</label>
                                <input type="email" id="register-email" name="email" placeholder="your@example.com" required value="${param.email}">
                            </div>
                            <div class="form-group">
                                <label for="register-password">パスワード</label>
                                <input type="password" id="register-password" name="password" required>
                            </div>
                            <div class="form-group">
                                <label for="register-password-confirm">パスワード (確認)</label>
                                <input type="password" id="register-password-confirm" name="password_confirm" required>
                            </div>
                            <div class="form-actions">
                                <button type="submit" name="register_submit" value="true" class="btn-primary">新規登録</button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>