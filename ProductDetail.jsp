<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<fmt:requestEncoding value="utf-8" />

<sql:setDataSource var="dataSource" driver="org.h2.Driver" url="jdbc:h2:sdev" />

<c:set var="productCode" value="${param.product_code}" />

<c:choose>
    <c:when test="${not empty productCode}">
        <sql:query var="productRs" dataSource="${dataSource}">
            SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, DETAIL, FEATURE, IMAGE, PRICE, SCENE
            FROM PRODUCT_INFO2
            WHERE PRODUCT_CODE = ?;
            <sql:param value="${productCode}" />
        </sql:query>

        <c:choose>
            <c:when test="${not empty productRs.rows[0]}">
                <c:set var="product" value="${productRs.rows[0]}" />
                <c:set var="productName" value="${product.PRODUCT_NAME}" />
                <c:set var="categoryName" value="${product.CATEGORY_NAME}" />
                <c:set var="detail" value="${product.DETAIL}" />
                <c:set var="feature" value="${product.FEATURE}" />
                <c:set var="image" value="${product.IMAGE}" />
                <c:set var="price" value="${product.PRICE}" />
                <c:set var="scene" value="${product.SCENE}" />
                <c:set var="size" value="S,M,L,LL" />
                
                <sql:query var="reviewsRs" dataSource="${dataSource}">
                    SELECT COMMENT, SCORE
                    FROM PRODUCT_REVIEW
                    WHERE PRODUCT_CODE = ?
                    ORDER BY ID DESC;
                    <sql:param value="${productCode}" />
                </sql:query>

                <c:set var="totalScore" value="0" />
                <c:set var="reviewCount" value="${fn:length(reviewsRs.rows)}" />
                <c:forEach var="review" items="${reviewsRs.rows}">
                    <c:set var="totalScore" value="${totalScore + review.SCORE}" />
                </c:forEach>
                <c:set var="averageScore" value="${(reviewCount > 0) ? (totalScore / reviewCount) : 0}" />
            </c:when>
            <c:otherwise>
                <c:redirect url="AllProduct.jsp?error=notfound" />
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:redirect url="AllProduct.jsp?error=nocode" />
    </c:otherwise>
</c:choose>


<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Suncat Wear - 商品詳細: ${productName}</title>
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
            <section class="product-detail-section">
                <h2>商品詳細</h2>
                <div class="product-detail-wrapper">
                    <div class="product-image-gallery">
                        <img src="image/${image}" alt="${productName}" class="main-product-image" onerror="this.onerror=null;this.src='image/default_product.png';" />
                    </div>
                    <div class="product-info">
                        <h1>${productName}</h1>
                        <p class="product-code">商品コード: ${productCode}</p>
                        <p class="product-category">カテゴリ: ${categoryName}</p>
                        
                        <div class="product-features">
                            <p><strong>特徴:</strong> ${feature}</p>
                            <p><strong>シーン:</strong> ${scene}</p>
                        </div>

                        <p class="product-description">${detail}</p>

                        <form action="Cart.jsp" method="post">
                            <div class="product-options">
                                <div class="option-group">
                                    <label for="size-select">サイズ:</label>
                                    <select id="size-select" name="size">
                                        <c:forTokens var="s" items="${size}" delims=",">
                                            <option value="${s}">${s}</option>
                                        </c:forTokens>
                                    </select>
                                </div>
                                <div class="option-group">
                                    <label for="quantity-select">数量:</label>
                                    <input type="number" id="quantity-select" name="quantity" value="1" min="1" max="10">
                                </div>
                            </div>

                            <p class="product-price">価格: <fmt:formatNumber value="${price}" type="CURRENCY" currencyCode="JPY" maxFractionDigits="0"/></p>
                            
                            <div class="product-actions">
                                <input type="hidden" name="product_code" value="${productCode}">
                                <input type="hidden" name="action" value="add_to_cart">
                                <button type="submit" class="btn-primary add-to-cart-btn">カートに入れる</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="review-section">
                    <h3>お客様の声 (レビュー)</h3>
                    <div class="review-summary">
                        <p>総合評価:
                            <c:set var="roundedAverageScore" value="${Math.round(averageScore)}" /> 
                            <c:forEach begin="1" end="5" var="i">
                                <c:if test="${i <= roundedAverageScore}">★</c:if>
                                <c:if test="${i > roundedAverageScore}">☆</c:if>
                            </c:forEach>
                            (<fmt:formatNumber value="${averageScore}" pattern="0.0" /> / 5)
                        </p>
                        <p>レビュー数: ${reviewCount}件</p>
                    </div>
                    <div class="review-list">
                        <c:if test="${reviewCount > 0}">
                            <c:forEach var="review" items="${reviewsRs.rows}">
                                <div class="review-item">
                                    <p class="review-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:if test="${i <= review.SCORE}">★</c:if>
                                            <c:if test="${i > review.SCORE}">☆</c:if>
                                        </c:forEach>
                                    </p>
                                    <p class="review-comment">${review.COMMENT}</p>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${reviewCount == 0}">
                            <p class="no-reviews-message">この商品にはまだレビューがありません．</p>
                        </c:if>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>