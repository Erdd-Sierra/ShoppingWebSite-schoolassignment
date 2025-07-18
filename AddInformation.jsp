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
    <title>Suncat Wear - お届け先情報の入力</title>
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
            <section class="form-section">
                <h2>お届け先情報の入力</h2>
                <div class="form-wrapper">
                    <form action="ChoosePayWay.jsp" method="post" class="standard-form">
                        <div class="form-group">
                            <label for="name">お名前</label>
                            <input type="text" id="name" name="name" placeholder="山田 太郎" required>
                        </div>
                        <div class="form-group">
                            <label for="zip-code">郵便番号</label>
                            <input type="text" id="zip-code" name="zip_code" placeholder="例: 123-4567" required>
                        </div>
                        <div class="form-group">
                            <label for="address1">住所1 (都道府県、市区町村)</label>
                            <input type="text" id="address1" name="address1" placeholder="例: 東京都新宿区" required>
                        </div>
                        <div class="form-group">
                            <label for="address2">住所2 (番地、建物名など)</label>
                            <input type="text" id="address2" name="address2" placeholder="例: 西新宿1-1-1 Suncatビル101" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">電話番号</label>
                            <input type="tel" id="phone" name="phone" placeholder="例: 090-1234-5678" required>
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn-secondary" onclick="history.back()">カートに戻る</button>
                            <button type="submit" class="btn-primary">お支払い方法へ進む</button>
                        </div>
                    </form>
                </div>
            </section>
        </main>
    </div>
</body>
</html>