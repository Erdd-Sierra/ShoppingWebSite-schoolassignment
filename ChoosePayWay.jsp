<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<%-- AddInformation.jsp からPOSTされたデータを受け取る --%>
<c:set var="deliveryName" value="${param.name}" />
<c:set var="deliveryZipcode" value="${param.zip_code}" />
<c:set var="deliveryAddress1" value="${param.address1}" />
<c:set var="deliveryAddress2" value="${param.address2}" />
<c:set var="deliveryPhone" value="${param.phone}" />
<c:set var="deliveryAddress" value="${deliveryAddress1} ${deliveryAddress2}" />

<%-- Cart.jspからセッションに保存されたカート情報と合計金額を取得 --%>
<c:set var="cartItems" value="${sessionScope.cartItems}" />
<c:set var="totalPrice" value="0" />
<c:forEach var="item" items="${cartItems}">
    <c:set var="totalPrice" value="${totalPrice + (item.price * item.quantity)}" />
</c:forEach>

<%--
    注文番号を生成 (より確実な方法に修正)
    UUIDを生成し、ハイフンを削除して使用する
--%>
<%
    String orderNo = java.util.UUID.randomUUID().toString().replace("-", "");
    pageContext.setAttribute("orderNo", orderNo);
%>

<%--
    ORDERSテーブルへのデータ挿入処理
    ※ 顧客コードはログインしていればセッションから取得、していなければNULLとする
--%>
<c:set var="customerCode" value="${not empty sessionScope.loggedInCustomer ? sessionScope.loggedInCustomer.CUSTOMER_CODE : null}" />

<c:if test="${not empty cartItems}">
    <sql:update var="rowCount" dataSource="${dataSource}">
        INSERT INTO ORDERS (
            ORDER_NO, CUSTOMER_CODE, TOTAL_PRICE, DELIVERY_NAME, DELIVERY_ZIPCODE, DELIVERY_ADDRESS, DELIVERY_PHONE, ORDER_DATE
        ) VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP());
        <sql:param value="${orderNo}" />
        <c:choose>
            <c:when test="${not empty customerCode}">
                <sql:param value="${customerCode}" />
            </c:when>
            <c:otherwise>
                <sql:param value="${null}" />
            </c:otherwise>
        </c:choose>
        <sql:param value="${totalPrice}" />
        <sql:param value="${deliveryName}" />
        <sql:param value="${deliveryZipcode}" />
        <sql:param value="${deliveryAddress}" />
        <sql:param value="${deliveryPhone}" />
    </sql:update>

    <c:if test="${rowCount == 1}">
        <%-- 挿入が成功したら、次のページに渡す注文情報をセッションに保存 --%>
        <c:set var="order" scope="session">
            <c:set var="orderId" value="${lastOrderRs.rows[0].ORDER_ID}" />
            <c:set var="orderNo" value="${orderNo}" />
        </c:set>
        <%-- 注文明細 (ORDER_DETAILS) への挿入ロジックは今回含めない --%>
    </c:if>
</c:if>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - お支払い方法の選択</title>
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
            <section class="payment-section">
                <h2>お支払い方法の選択</h2>
                <div class="form-wrapper">
                    <form action="SellFinish.jsp" method="post" class="standard-form">
                        <div class="form-group payment-options">
                            <h3>お支払い方法</h3>
                            <label class="radio-option">
                                <input type="radio" name="payment_method" value="credit_card" checked>
                                クレジットカード
                                <div class="card-icons">
                                    <img src="image/card_visa.png" alt="Visa" width="40">
                                    <img src="image/card_mastercard.png" alt="Mastercard" width="40">
                                    <img src="image/card_jcb.png" alt="JCB" width="40">
                                </div>
                            </label>
                            <div class="card-details-group">
                                <div class="form-group">
                                    <label for="card_number">カード番号</label>
                                    <input type="text" id="card_number" name="card_number" placeholder="XXXX-XXXX-XXXX-XXXX">
                                </div>
                                <div class="form-group">
                                    <label for="card_exp">有効期限 (MM/YY)</label>
                                    <input type="text" id="card_exp" name="card_exp" placeholder="MM/YY">
                                </div>
                                <div class="form-group">
                                    <label for="card_cvv">セキュリティコード</label>
                                    <input type="text" id="card_cvv" name="card_cvv" placeholder="CVV">
                                </div>
                            </div>

                            <label class="radio-option">
                                <input type="radio" name="payment_method" value="electronic_money">
                                電子マネー (PayPay, LINE Payなど)
                                <div class="emoney-icons">
                                    <img src="image/paypay_icon.png" alt="PayPay" width="40">
                                    <img src="image/linepay_icon.png" alt="LINE Pay" width="40">
                                </div>
                            </label>

                            <label class="radio-option">
                                <input type="radio" name="payment_method" value="konbini">
                                コンビニ決済
                            </label>

                            <label class="radio-option">
                                <input type="radio" name="payment_method" value="postpay">
                                後払い
                            </label>
                        </div>
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn-secondary" onclick="history.back()">お届け先情報に戻る</button>
                            <button type="submit" class="btn-primary">注文を確定する</button>
                        </div>
                        <%-- 注文IDを次のページに渡すための隠しフィールド --%>
                        <c:if test="${not empty orderNo}">
                            <input type="hidden" name="order_no" value="${orderNo}">
                        </c:if>
                    </form>
                </div>
            </section>
        </main>
    </div>
</body>
</html>