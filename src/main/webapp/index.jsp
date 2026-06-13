<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Cửa hàng bếp</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">

    <style>
        /* ===== AI CHAT WIDGET ===== */
        #aiChatToggle {
            position: fixed;
            bottom: 28px; right: 28px;
            width: 58px; height: 58px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: #fff;
            border: none;
            cursor: pointer;
            font-size: 1.5rem;
            box-shadow: 0 4px 20px rgba(249,115,22,.45);
            z-index: 9998;
            display: flex; align-items: center; justify-content: center;
            transition: transform .2s, box-shadow .2s;
        }
        #aiChatToggle:hover { transform: scale(1.1); box-shadow: 0 6px 28px rgba(249,115,22,.55); }
        #aiChatToggle .ai-badge {
            position: absolute; top: -4px; right: -4px;
            width: 18px; height: 18px; background: #ef4444;
            border-radius: 50%; font-size: .65rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            border: 2px solid #fff;
            animation: aipulse 2s infinite;
        }
        @keyframes aipulse {
            0%,100% { box-shadow: 0 0 0 0 rgba(239,68,68,.6); }
            50%      { box-shadow: 0 0 0 6px rgba(239,68,68,0); }
        }
        #aiChatWindow {
            position: fixed;
            bottom: 98px; right: 28px;
            width: 370px; height: 520px;
            border-radius: 20px;
            background: #fff;
            box-shadow: 0 8px 40px rgba(0,0,0,.18);
            display: flex; flex-direction: column;
            z-index: 9999;
            overflow: hidden;
            transform: scale(0) translateY(20px);
            transform-origin: bottom right;
            opacity: 0;
            transition: transform .25s cubic-bezier(.34,1.56,.64,1), opacity .2s;
            pointer-events: none;
        }
        #aiChatWindow.open {
            transform: scale(1) translateY(0);
            opacity: 1;
            pointer-events: all;
        }
        .ai-win-header {
            background: linear-gradient(135deg, #f97316, #ea580c);
            padding: 14px 16px;
            display: flex; align-items: center; gap: 12px;
            color: #fff; flex-shrink: 0;
        }
        .ai-bot-avatar {
            width: 38px; height: 38px;
            background: rgba(255,255,255,.25);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
        }
        .ai-bot-info h4 { margin: 0; font-size: .95rem; }
        .ai-bot-info p  { margin: 1px 0 0; font-size: .74rem; opacity: .85; }
        .ai-status-dot  { width: 8px; height: 8px; background: #86efac; border-radius: 50%; display: inline-block; margin-right: 4px; }
        .ai-close-btn {
            margin-left: auto;
            background: rgba(255,255,255,.2);
            border: none; color: #fff;
            width: 30px; height: 30px;
            border-radius: 8px;
            cursor: pointer; font-size: 1rem;
            display: flex; align-items: center; justify-content: center;
            transition: background .15s;
        }
        .ai-close-btn:hover { background: rgba(255,255,255,.35); }
        .ai-win-body {
            flex: 1; overflow-y: auto;
            padding: 14px;
            display: flex; flex-direction: column; gap: 12px;
            background: #fafafa;
        }
        .ai-win-body::-webkit-scrollbar { width: 4px; }
        .ai-win-body::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 4px; }
        .w-msg { display: flex; gap: 8px; align-items: flex-end; }
        .w-msg.user { flex-direction: row-reverse; }
        .w-msg .w-av {
            width: 28px; height: 28px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: .78rem; flex-shrink: 0;
        }
        .w-msg.bot  .w-av { background: linear-gradient(135deg, #f97316, #ea580c); color: #fff; }
        .w-msg.user .w-av { background: #dbeafe; color: #1d4ed8; }
        .w-msg .w-bubble {
            max-width: 82%; padding: 9px 13px;
            border-radius: 14px; font-size: .83rem;
            line-height: 1.55; white-space: pre-wrap; word-break: break-word;
        }
        .w-msg.bot  .w-bubble { background: #fff; border: 1px solid #e5e7eb; color: #111827; border-bottom-left-radius: 4px; }
        .w-msg.user .w-bubble { background: #f97316; color: #fff; border-bottom-right-radius: 4px; }
        .w-quick-wrap {
            display: flex; flex-wrap: wrap; gap: 6px;
            padding: 8px 14px 10px;
            background: #fafafa;
            border-top: 1px solid #f0f0f0;
            flex-shrink: 0;
        }
        .w-quick-wrap.hidden { display: none; }
        .w-qbtn {
            padding: 5px 11px; border-radius: 16px;
            border: 1px solid #fed7aa; background: #fff7ed;
            font-size: .76rem; color: #c2410c;
            cursor: pointer; transition: background .15s;
        }
        .w-qbtn:hover { background: #ffedd5; }
        .w-typing { display: flex; gap: 4px; padding: 5px 2px; align-items: center; }
        .w-typing span {
            width: 7px; height: 7px; background: #d1d5db;
            border-radius: 50%; animation: wbounce 1.2s infinite;
        }
        .w-typing span:nth-child(2) { animation-delay: .2s; }
        .w-typing span:nth-child(3) { animation-delay: .4s; }
        @keyframes wbounce {
            0%,80%,100% { transform: scale(.7); opacity:.5; }
            40%          { transform: scale(1);  opacity:1; }
        }
        .ai-win-footer {
            display: flex; gap: 8px;
            padding: 10px 12px;
            border-top: 1px solid #f0f0f0;
            background: #fff; flex-shrink: 0;
        }
        .ai-win-footer input {
            flex: 1; border: 1px solid #e5e7eb;
            border-radius: 20px; padding: 9px 14px;
            font-size: .84rem; outline: none;
            font-family: inherit; transition: border .15s;
        }
        .ai-win-footer input:focus { border-color: #f97316; }
        .w-send-btn {
            width: 38px; height: 38px; border-radius: 50%;
            background: #f97316; color: #fff; border: none;
            cursor: pointer; font-size: .95rem;
            display: flex; align-items: center; justify-content: center;
            transition: background .15s; flex-shrink: 0;
        }
        .w-send-btn:hover { background: #ea580c; }
        .w-send-btn:disabled { background: #fdba74; cursor: not-allowed; }
        @media (max-width: 480px) {
            #aiChatWindow { width: calc(100vw - 20px); right: 10px; bottom: 80px; }
            #aiChatToggle { bottom: 18px; right: 18px; }
        }
    </style>
</head>

<body>

<jsp:include page="common/header.jsp"></jsp:include>

<main class="main-content">
    <section class="hero-banner swiper" id="hero-slider">
        <div class="swiper-wrapper">
            <c:forEach var ="b" items="${listBN}">
                <div class="swiper-slide hero-slide" style="background-image: url('${b.image}');">
                    <div class="hero-content">
                        <h1>${b.title}</h1>
                        <p>${b.description}</p>
                        <a href="#" class="btn btn-primary">Khám Phá Ngay</a>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="swiper-pagination"></div>
    </section>

    <section class="trust-badges section-padding">
        <div class="container">
            <div class="trust-badge">
                <i class="fa fa-shield-halved"></i>
                <h3>Cam kết 100% Chính Hãng</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-tools"></i>
                <h3>Miễn phí Lắp Đặt &amp; Cài Đặt</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-headset"></i>
                <h3>Hỗ trợ Kỹ thuật 24/7</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-truck-fast"></i>
                <h3>Bảo hành Tận nhà</h3>
            </div>
        </div>
    </section>

    <section class="featured-categories section-padding">
        <div class="container">
            <h2 class="section-title">Danh mục Nổi bật</h2>
            <div class="category-grid">
                <c:forEach var="c" items="${topCategories}">
                    <a href="${pageContext.request.contextPath}/products?categoryId=${c.category_id}" class="category-item">
                        <img src="${c.logo}" alt="${c.category_name}" />
                        <span>${c.category_name}</span>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="best-sellers section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Sản phẩm Bán chạy nhất</h2>
            <div class="swiper" id="bestseller-slider">
                <div class="swiper-wrapper">
                    <c:forEach var="pbs" items="${listP}">
                        <div class="swiper-slide product-card">
                            <img src="${pbs.image}" alt="Sản phẩm" />
                            <h3>${pbs.product_name}</h3>
                            <div class="price">${pbs.priceFormat}</div>
                            <a href="${pageContext.request.contextPath}/product-detail?id=${pbs.product_id}" class="btn btn-secondary">
                                Xem chi tiết
                            </a>
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
            </div>
        </div>
    </section>

    <section class="shop-by-ecosystem section-padding">
        <div class="container">
            <h2 class="section-title">Mua theo Hệ sinh thái</h2>
            <div class="ecosystem-grid">
                <c:forEach var="e" items="${listE}">
                    <a href="detail-ecosystem?id=${e.id}" class="ecosystem-item" style="background-color: #e5e5e5">
                        <img src="${e.image}" alt="" />
                        <span>${e.name}</span>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="solutions-combo section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Gợi ý Giải pháp</h2>
            <div class="solutions-grid">
                <c:forEach var="c" items="${listC}">
                    <a href="combo?id=${c.id}" class="solution-item" style="background-image: url('${c.image}');">
                        <div class="solution-content">
                            <h3>${c.name}</h3>
                            <p>${c.content}</p>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="content-hub section-padding">
        <div class="container">
            <h2 class="section-title">Góc Tư vấn &amp; Đánh giá</h2>
            <div class="hub-grid">
                <div class="hub-video">
                    <iframe width="560" height="315"
                            src="https://www.youtube.com/embed/watch?v=6JdW3GRxF3w&list=RD6JdW3GRxF3w&start_radio=1"
                            title="YouTube video player" frameborder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowfullscreen></iframe>
                </div>
                <div class="hub-articles">
                    <c:forEach var="a" items="${listA}">
                        <a href="detail-article?id=${a.id}" class="article-item">
                            <h4>${a.title}</h4>
                            <p>${a.content}</p>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </section>

    <section class="testimonials section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Khách hàng Nói về Chúng tôi</h2>
            <div class="swiper" id="testimonial-slider">
                <div class="swiper-wrapper">
                    <c:forEach var="t" items="${homeComments}">
                        <div class="swiper-slide testimonial-item">
                            <p>"${t.content}"</p>
                            <h4>- ${t.username}</h4>
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <section class="brands section-padding">
        <div class="container">
            <h2 class="section-title">Các Thương hiệu Hàng đầu</h2>
            <div class="swiper" id="brand-slider">
                <div class="swiper-wrapper">
                    <c:forEach var="b" items="${topBrands}">
                        <div class="swiper-slide brand-item">
                            <a href="brand?id=${b.brand_id}">
                                <img src="${b.logo_url}" alt="${b.brand_name}" />
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>

<!-- ===== AI CHAT WIDGET ===== -->
<button id="aiChatToggle" onclick="toggleAIChat()" title="Tư vấn sản phẩm AI">
    <i class="fa-solid fa-comments"></i>
    <span class="ai-badge">AI</span>
</button>

<div id="aiChatWindow">
    <div class="ai-win-header">
        <div class="ai-bot-avatar"><i class="fa-solid fa-robot"></i></div>
        <div class="ai-bot-info">
            <h4>Tư vấn viên AI</h4>
            <p><span class="ai-status-dot"></span>Trực tuyến 24/7</p>
        </div>
        <button class="ai-close-btn" onclick="toggleAIChat()">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <div class="ai-win-body" id="wChatBody">
        <div class="w-msg bot">
            <div class="w-av"><i class="fa-solid fa-robot"></i></div>
            <div class="w-bubble">Xin chào! 👋 Tôi là trợ lý tư vấn của <strong>WebThietBiBep</strong>.

                Bạn đang tìm kiếm thiết bị bếp gì? Tôi sẽ giúp bạn chọn sản phẩm phù hợp nhất! 😊</div>
        </div>
    </div>

    <div class="w-quick-wrap" id="wQuick">
        <button class="w-qbtn" onclick="wUseQuick(this)">🔥 Bếp gas loại nào tốt?</button>
        <button class="w-qbtn" onclick="wUseQuick(this)">🍳 Chảo chống dính tốt nhất</button>
        <button class="w-qbtn" onclick="wUseQuick(this)">💰 Sản phẩm dưới 5 triệu</button>
        <button class="w-qbtn" onclick="wUseQuick(this)">⭐ Sản phẩm bán chạy nhất</button>
    </div>

    <div class="ai-win-footer">
        <input type="text" id="wChatInput" placeholder="Hỏi tôi về sản phẩm..."
               maxlength="500" onkeydown="if(event.key==='Enter') wSend()"/>
        <button class="w-send-btn" id="wSendBtn" onclick="wSend()">
            <i class="fa-solid fa-paper-plane"></i>
        </button>
    </div>
</div>
<!-- ===== END AI CHAT WIDGET ===== -->

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="assets/js/Main.js"></script>

<script>
    /* ===== AI CHAT LOGIC ===== */
    var wHistory = [];
    var wOpen    = false;
    var W_CTX    = '${pageContext.request.contextPath}';

    function toggleAIChat() {
        wOpen = !wOpen;
        var win = document.getElementById('aiChatWindow');
        var btn = document.getElementById('aiChatToggle');
        if (wOpen) {
            win.classList.add('open');
            btn.innerHTML = '<i class="fa-solid fa-xmark"></i>';
            document.getElementById('wChatInput').focus();
        } else {
            win.classList.remove('open');
            btn.innerHTML = '<i class="fa-solid fa-comments"></i><span class="ai-badge">AI</span>';
        }
    }

    function wUseQuick(btn) {
        document.getElementById('wChatInput').value = btn.textContent.replace(/^[^\wÀ-ỹ]+/, '').trim();
        document.getElementById('wQuick').classList.add('hidden');
        wSend();
    }

    function wAppend(role, text) {
        var body = document.getElementById('wChatBody');
        var div  = document.createElement('div');
        div.className = 'w-msg ' + role;
        var icon = role === 'bot' ? 'fa-robot' : 'fa-user';
        div.innerHTML = '<div class="w-av"><i class="fa-solid ' + icon + '"></i></div>'
            + '<div class="w-bubble">' + wEsc(text) + '</div>';
        body.appendChild(div);
        body.scrollTop = body.scrollHeight;
    }

    function wShowTyping() {
        var body = document.getElementById('wChatBody');
        var div  = document.createElement('div');
        div.className = 'w-msg bot'; div.id = 'wTyping';
        div.innerHTML = '<div class="w-av"><i class="fa-solid fa-robot"></i></div>'
            + '<div class="w-bubble"><div class="w-typing"><span></span><span></span><span></span></div></div>';
        body.appendChild(div);
        body.scrollTop = body.scrollHeight;
    }

    function wRemoveTyping() {
        var t = document.getElementById('wTyping');
        if (t) t.remove();
    }

    function wEsc(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
            .replace(/\n/g,'<br>').replace(/\*\*(.*?)\*\*/g,'<strong>$1</strong>');
    }

    function wSend() {
        var input   = document.getElementById('wChatInput');
        var sendBtn = document.getElementById('wSendBtn');
        var msg = input.value.trim();
        if (!msg || sendBtn.disabled) return;

        sendBtn.disabled = true;
        input.value = '';
        document.getElementById('wQuick').classList.add('hidden');

        wAppend('user', msg);
        wShowTyping();

        var params = new URLSearchParams();
        params.append('mode', 'user');
        params.append('message', msg);
        params.append('history', JSON.stringify(wHistory));

        fetch(W_CTX + '/ai-chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                wRemoveTyping();
                var reply = data.error ? ('⚠️ ' + data.error) : (data.reply || 'Xin lỗi, tôi chưa có câu trả lời.');
                wAppend('bot', reply);
                wHistory.push({ role: 'user', content: msg });
                wHistory.push({ role: 'assistant', content: reply });
                if (wHistory.length > 16) wHistory = wHistory.slice(wHistory.length - 16);
            })
            .catch(function() {
                wRemoveTyping();
                wAppend('bot', '⚠️ Không thể kết nối. Vui lòng thử lại hoặc gọi hotline hỗ trợ.');
            })
            .finally(function() {
                sendBtn.disabled = false;
                input.focus();
            });
    }
</script>

</body>
</html>
