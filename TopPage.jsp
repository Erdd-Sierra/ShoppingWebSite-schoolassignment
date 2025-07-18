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
    <title>Suncat Wear</title>
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

    <div class="main-visual">
        <img src="image/hero_uvwear.png" alt="紫外線から肌を守る、私らしいスタイル" class="hero-image">
        <div class="hero-text">
            <h2>この夏の物語を、もっと美しく。</h2>
            <p>太陽の下、もっと自由に。</p>
            <a href="AllProduct.jsp" class="btn-primary">全ての商品を見る</a>
        </div>
    </div>

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
            <%-- <div class="sidebar-section"> --%> <%-- 並び替えセクション全体を削除 --%>
            <%--     <h2>並び替え</h2> --%>
            <%--     <ul> --%>
            <%--         <li><a href="AllProduct.jsp">標準 (商品コード順)</a></li> --%>
            <%--         <li><a href="AllProduct.jsp?sort=price_asc">価格が安い順</a></li> --%>
            <%--         <li><a href="AllProduct.jsp?sort=price_desc">価格が高い順</a></li> --%>
            <%--         <li><a href="AllProduct.jsp?filter=new">新着順</a></li> --%>
            <%--     </ul> --%>
            <%-- </div> --%>
        </aside>

        <main class="main-content">
            <section class="concept-visuals">
                <h2>私らしく、陽射しと遊ぶ。</h2>
                <div class="image-gallery">
                    <img src="image/concept_summer_fun.png" alt="夏を楽しむ女性たち" />
                    <img src="image/concept_active.png" alt="アウトドアを楽しむ" />
                    <img src="image/concept_daily.png" alt="日常のUVケア" />
                    <img src="image/concept_family.png" alt="家族でのUVケア" />
                </div>
                <p class="concept-text">Suncat Wearは、高機能なUVカットウェアで、あなたの日常をもっと自由に、もっと美しく輝かせます．太陽の下、どんな時も、あなたらしいスタイルで自信を持って過ごしてください．</p>
            </section>
        </main>
    </div>
</body>
</html>