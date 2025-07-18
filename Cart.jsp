<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<%-- カートデータをセッションから取得、存在しなければ初期化 --%>
<c:if test="${empty sessionScope.cartItems}">
    <%
        session.setAttribute("cartItems", new java.util.ArrayList<java.util.HashMap<String, Object>>());
    %>
</c:if>
<c:set var="cartItems" value="${sessionScope.cartItems}" />

<%-- POSTリクエストで商品がカートに追加された場合 --%>
<c:if test="${pageContext.request.method == 'POST' && param.action == 'add_to_cart'}">
    <%
        String newProductCode = request.getParameter("product_code");
        String newQuantityStr = request.getParameter("quantity");
        String newSize = request.getParameter("size"); // サイズは受け取るが、カート内のユニーク性判断には使用しない
        int newQuantity = Integer.parseInt(newQuantityStr);

        java.util.ArrayList<java.util.HashMap<String, Object>> currentCartItems = 
            (java.util.ArrayList<java.util.HashMap<String, Object>>)session.getAttribute("cartItems");
        
        boolean itemExistsInCart = false;
        
        // 既存のカートアイテムをチェックし、同じ商品があれば数量を更新
        // 新しいリストを作成して更新内容を反映
        java.util.ArrayList<java.util.HashMap<String, Object>> updatedCartItemsList = new java.util.ArrayList<>();
        for (java.util.HashMap<String, Object> item : currentCartItems) {
            // productCode が一致する場合、数量を更新
            // サイズも考慮する場合はここに && item.get("size").equals(newSize) を追加
            if (item.get("productCode").equals(newProductCode)) { 
                item.put("quantity", (Integer)item.get("quantity") + newQuantity);
                itemExistsInCart = true;
            }
            updatedCartItemsList.add(item);
        }

        // 新しい商品の場合、データベースから詳細情報を取得し、カートに追加
        if (!itemExistsInCart) {
    %>
            <sql:query var="addedProductRs" dataSource="${dataSource}">
                SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, DETAIL, FEATURE, IMAGE, PRICE, SCENE
                FROM PRODUCT_INFO2
                WHERE PRODUCT_CODE = ?;
                <sql:param value="<%= newProductCode %>" />
            </sql:query>
    <%
            org.apache.taglibs.standard.tag.common.sql.ResultImpl addedProductResult =
                (org.apache.taglibs.standard.tag.common.sql.ResultImpl)pageContext.findAttribute("addedProductRs");

            if (addedProductResult != null && addedProductResult.getRows() != null && addedProductResult.getRows().length > 0) {
                java.util.SortedMap addedProductRow = addedProductResult.getRows()[0];
                java.util.HashMap<String, Object> cartItemMap = new java.util.HashMap<>();
                cartItemMap.put("productCode", addedProductRow.get("PRODUCT_CODE"));
                cartItemMap.put("productName", addedProductRow.get("PRODUCT_NAME"));
                cartItemMap.put("categoryName", addedProductRow.get("CATEGORY_NAME"));
                cartItemMap.put("feature", addedProductRow.get("FEATURE"));
                cartItemMap.put("image", addedProductRow.get("IMAGE"));
                cartItemMap.put("price", ((Integer)addedProductRow.get("PRICE")));
                cartItemMap.put("quantity", newQuantity);
                cartItemMap.put("size", newSize); // サイズは保持するが、結合ロジックには使わない

                updatedCartItemsList.add(cartItemMap);
            }
        }
        session.setAttribute("cartItems", updatedCartItemsList);
    %>
    <c:set var="message" value="商品がカートに追加されました．" scope="request" />
    <c:set var="messageClass" value="success" scope="request" />
</c:if>

<%-- カートからの削除処理 --%>
<c:if test="${pageContext.request.method == 'POST' && param.action == 'remove_from_cart'}">
    <%
        String removeProductCode = request.getParameter("product_code");
        // String removeSize = request.getParameter("size"); // サイズは無視
        
        java.util.ArrayList<java.util.HashMap<String, Object>> currentCartItems = 
            (java.util.ArrayList<java.util.HashMap<String, Object>>)session.getAttribute("cartItems");
        java.util.ArrayList<java.util.HashMap<String, Object>> updatedCartItemsList = new java.util.ArrayList<>();
        
        for (java.util.HashMap<String, Object> item : currentCartItems) {
            // productCodeが一致しないもののみを新しいリストに追加
            if (!item.get("productCode").equals(removeProductCode)) { 
                updatedCartItemsList.add(item);
            }
        }
        session.setAttribute("cartItems", updatedCartItemsList);
    %>
    <c:set var="message" value="商品がカートから削除されました．" scope="request" />
    <c:set var="messageClass" value="info" scope="request" />
</c:if>

<%-- カート内の合計金額を計算 --%>
<c:set var="totalPrice" value="0" />
<c:forEach var="item" items="${cartItems}">
    <c:set var="totalPrice" value="${totalPrice + (item.price * item.quantity)}" />
</c:forEach>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - カート</title>
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
            <section class="cart-section">
                <h2>カート</h2>
                <%-- カート操作後のメッセージ表示 --%>
                <c:if test="${not empty message}">
                    <p class="message ${messageClass}">${message}</p>
                </c:if>

                <%-- カートに商品がある場合のみ表示 --%>
                <c:if test="${not empty cartItems && fn:length(cartItems) > 0}"> <%-- fn:lengthでカートのアイテム数をチェック --%>
                    <div class="cart-items">
                        <c:forEach var="item" items="${cartItems}" varStatus="loop">
                            <div class="cart-item">
                                <div class="item-image">
                                    <img src="image/${item.image}" alt="${item.productName}" onerror="this.onerror=null;this.src='image/default_product.png';" />
                                </div>
                                <div class="item-details">
                                    <h3>${item.productName}</h3>
                                    <p class="item-category">${item.categoryName}</p>
                                    <c:if test="${not empty item.feature}"><p class="item-feature">${item.feature}</p></c:if>
                                    <p class="item-size">サイズ: ${item.size}</p> <%-- サイズは表示する --%>
                                    <div class="item-quantity">
                                        <label for="quantity_${loop.index}">数量:</label>
                                        <input type="number" id="quantity_${loop.index}" value="${item.quantity}" min="1" readonly />
                                    </div>
                                    <p class="item-price"><fmt:formatNumber value="${item.price * item.quantity}" type="CURRENCY" currencyCode="JPY" maxFractionDigits="0"/></p>
                                    <form action="Cart.jsp" method="post" class="remove-form">
                                        <input type="hidden" name="action" value="remove_from_cart">
                                        <input type="hidden" name="product_code" value="${item.productCode}">
                                        <input type="hidden" name="size" value="${item.size}"> <%-- 削除時にサイズも渡す --%>
                                        <button type="submit" class="remove-item-btn">削除</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="cart-summary">
                        <h3>合計金額: <span class="total-price"><fmt:formatNumber value="${totalPrice}" type="CURRENCY" currencyCode="JPY" maxFractionDigits="0"/></span></h3>
                    </div>

                    <div class="cart-actions">
                        <a href="AllProduct.jsp" class="btn-secondary">買い物を続ける</a>
                        <a href="AddInformation.jsp" class="btn-primary">購入手続きへ進む</a>
                    </div>
                </c:if>

                <%-- カートが空の場合のメッセージ --%>
                <c:if test="${empty cartItems || fn:length(cartItems) == 0}"> <%-- カートが空の場合の条件を修正 --%>
                    <p class="no-products-message">カートに商品はありません．</p>
                </c:if>
            </section>
        </main>
    </div>
</body>
</html>