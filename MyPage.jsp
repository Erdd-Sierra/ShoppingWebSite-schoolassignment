<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<c:set var="loggedInCustomer" value="${sessionScope.loggedInCustomer}" />

<c:if test="${empty loggedInCustomer}">
    <c:redirect url="MemberLogin.jsp?msg=mypage_login_required" />
</c:if>

<c:if test="${not empty loggedInCustomer}">
    <c:set var="customerName" value="${loggedInCustomer.CUSTOMER_NAME}" />
    <c:set var="customerCode" value="${loggedInCustomer.CUSTOMER_CODE}" />

    <sql:query var="purchaseHistoryRs" dataSource="${dataSource}">
        SELECT
            ph.PURCHASE_CODE,
            ph.PURCHASE_DATE,
            ph.PRODUCT_CODE,
            ph.PRODUCT_NUM,
            ph.PRICE AS PURCHASE_PRICE,
            pi.PRODUCT_NAME,
            pi.IMAGE
        FROM
            PURCHASE_HISTORY ph
        JOIN
            PRODUCT_INFO2 pi ON ph.PRODUCT_CODE = pi.PRODUCT_CODE
        WHERE
            ph.CUSTOMER_NAME = ? <%-- CUSTOMER_NAMEで絞り込む --%>
        ORDER BY
            ph.PURCHASE_DATE DESC;
        <sql:param value="${customerName}" /> <%-- ログインしている顧客名で検索 --%>
    </sql:query>
</c:if>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - マイページ</title>
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
            <section class="mypage-section">
                <h2>マイページ</h2>
                <c:if test="${not empty loggedInCustomer}">
                    <p>ようこそ、${customerName}様！</p>
                    <div id="order-history" class="mypage-content-section">
                        <h3>購入履歴</h3>
                        <div class="order-list">
                            <c:if test="${empty purchaseHistoryRs.rows}">
                                <p class="no-history-message">購入履歴はございません．</p>
                            </c:if>
                            <c:forEach var="order" items="${purchaseHistoryRs.rows}">
                                <div class="order-item">
                                    <p class="order-date">購入日: <fmt:formatDate value="${order.PURCHASE_DATE}" pattern="yyyy/MM/dd HH:mm"/></p>
                                    <p class="order-id">商品コード: ${order.PRODUCT_CODE}</p>
                                    <div class="order-products">
                                        <div class="order-product-item">
                                            <img src="image/${order.IMAGE}" alt="${order.PRODUCT_NAME}" onerror="this.onerror=null;this.src='image/default_product.png';" />
                                            <div class="details">
                                                <h4>${order.PRODUCT_NAME}</h4>
                                                <p>数量: ${order.PRODUCT_NUM}点</p>
                                                <p><fmt:formatNumber value="${order.PURCHASE_PRICE}" type="CURRENCY" currencyCode="JPY" maxFractionDigits="0"/></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </section>
        </main>
    </div>
</body>
</html>