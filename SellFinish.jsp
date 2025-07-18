<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - ご購入完了</title>
    <link rel="stylesheet" type="text/css" href="TopPageStyles.css">
    <link rel="icon" href="image/favicon.ico">
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
            <section class="completion-section">
                <h2>ご購入が完了しました</h2>
                <div class="completion-message">
                    <p>ご注文いただき、誠にありがとうございます．</p>
                    <p>ご注文内容は、ご登録のメールアドレスへお送りいたしました．</p>
                    <p>商品の発送まで今しばらくお待ちください．</p>
                </div>
                <div class="completion-actions">
                    <a href="MyPage.jsp" class="btn-primary">注文履歴を見る</a>
                    <a href="TopPage.jsp" class="btn-secondary">トップページに戻る</a>
                </div>
            </section>
        </main>
    </div>
</body>
</html>