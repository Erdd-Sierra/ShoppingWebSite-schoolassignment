<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<c:set var="whereClause" value="" />

<c:if test="${not empty param.category}">
    <c:set var="whereClause" value=" WHERE CATEGORY_NAME = '${param.category}'" />
</c:if>

<c:if test="${not empty param.feature}">
    <c:choose>
        <c:when test="${param.feature == 'upf50plus'}">
            <c:set var="featureCondition" value="FEATURE LIKE '%UPF50%'" />
        </c:when>
        <c:when test="${param.feature == 'quick_dry'}">
            <c:set var="featureCondition" value="FEATURE LIKE '%吸汗速乾%'" />
        </c:when>
        <c:when test="${param.feature == 'cool_touch'}">
            <c:set var="featureCondition" value="FEATURE LIKE '%接触冷感%'" />
        </c:when>
        <c:when test="${param.feature == 'water_repellent'}">
            <c:set var="featureCondition" value="FEATURE LIKE '%撥水%'" />
        </c:when>
    </c:choose>

    <c:if test="${not empty featureCondition}">
        <c:choose>
            <c:when test="${not empty whereClause}">
                <c:set var="whereClause" value="${whereClause} AND ${featureCondition}" />
            </c:when>
            <c:otherwise>
                <c:set var="whereClause" value=" WHERE ${featureCondition}" />
            </c:otherwise>
        </c:choose>
    </c:if>
</c:if>

<c:if test="${not empty param.scene}">
    <c:set var="sceneCondition" value="SCENE = '${param.scene}'" />
    <c:choose>
        <c:when test="${not empty whereClause}">
            <c:set var="whereClause" value="${whereClause} AND ${sceneCondition}" />
        </c:when>
        <c:otherwise>
            <c:set var="whereClause" value=" WHERE ${sceneCondition}" />
        </c:otherwise>
    </c:choose>
</c:if>

<c:set var="orderByClause" value=" ORDER BY PRODUCT_CODE" />
<c:if test="${param.filter == 'new'}">
    <c:set var="orderByClause" value=" ORDER BY PRODUCT_CODE DESC" />
</c:if>
<c:if test="${param.sort == 'price_asc'}">
    <c:set var="orderByClause" value=" ORDER BY PRICE ASC" />
</c:if>
<c:if test="${param.sort == 'price_desc'}">
    <c:set var="orderByClause" value=" ORDER BY PRICE DESC" />
</c:if>

<c:set var="sql">
    SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, DETAIL, FEATURE, IMAGE, PRICE, SCENE
    FROM PRODUCT_INFO2
    ${whereClause} ${orderByClause}
</c:set>

<sql:query var="rs" dataSource="${dataSource}" sql="${sql}" />


<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - 商品一覧</title>
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
        <aside class="sidebar">
            <div class="sidebar-section">
                <h2>カテゴリで探す</h2>
                <ul>
                    <li><a href="AllProduct.jsp?category=UVパーカー">UVパーカー</a></li>
                    <li><a href="AllProduct.jsp?category=UVカーディガン">UVカーディガン</a></li>
                    <li><a href="AllProduct.jsp?category=UVTシャツ/トップス">UVTシャツ/トップス</a></li>
                    <li><a href="AllProduct.jsp?category=UVレギンス/ボトムス">UVレギンス/ボトムス</a></li>
                    <li><a href="AllProduct.jsp?category=帽子/アームカバー">帽子/アームカバー</a></li>
                    <%-- <li><a href="AllProduct.jsp?category=キッズUVウェア">キッズUVウェア</a></li> --%> <%-- 不要なので削除 --%>
                </ul>
            </div>
            <div class="sidebar-section">
                <h2>機能で探す</h2>
                <ul>
                    <li><a href="AllProduct.jsp?feature=upf50plus">UPF50+</a></li>
                    <li><a href="AllProduct.jsp?feature=quick_dry">吸汗速乾</a></li>
                    <li><a href="AllProduct.jsp?feature=cool_touch">接触冷感</a></li>
                    <li><a href="AllProduct.jsp?feature=water_repellent">撥水</a></li>
                </ul>
            </div>
            <div class="sidebar-section">
                <h2>シーンで探す</h2>
                <ul>
                    <li><a href="AllProduct.jsp?scene=日常使い">日常使い</a></li>
                    <li><a href="AllProduct.jsp?scene=アウトドア/レジャー">アウトドア/レジャー</a></li>
                    <li><a href="AllProduct.jsp?scene=スポーツ">スポーツ</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <section class="product-list-section">
                <h2>商品一覧</h2>
                <div class="product-list-grid">
                    <c:forEach var="row" items="${rs.rows}">
                        <div class="product-item">
                            <a href="ProductDetail.jsp?product_code=${row.PRODUCT_CODE}">
                                <img src="image/${row.IMAGE}" alt="${row.PRODUCT_NAME}" onerror="this.onerror=null;this.src='image/default_product.png';" />
                                <h3>${row.PRODUCT_NAME}</h3>
                                <p class="category-name">${row.CATEGORY_NAME}</p>
                                <c:if test="${not empty row.FEATURE}">
                                    <p class="feature-tag">${row.FEATURE}</p>
                                </c:if>
                                <p class="price">
                                    <fmt:formatNumber value="${row.PRICE}" type="CURRENCY" currencyCode="JPY" maxFractionDigits="0"/>
                                </p>
                            </a>
                        </div>
                    </c:forEach>
                    <c:if test="${empty rs.rows}">
                        <p class="no-products-message">現在、条件に合う商品はございません．</p>
                    </c:if>
                </div>
            </section>
        </main>
    </div>
</body>
</html>