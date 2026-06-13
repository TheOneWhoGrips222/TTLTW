Dưới đây là toàn bộ mã nguồn file JSP của bạn sau khi đã xóa bỏ tất cả các chú thích (comments):

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.webthietbibep.model.User currentUser =
            (com.webthietbibep.model.User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Trợ lý AI - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .ai-page-wrap {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 80px);
            max-width: 860px;
            margin: 0 auto;
            padding: 24px 20px 0;
        }
        .ai-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .ai-header .ai-icon {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1.4rem;
        }
        .ai-header h2 { margin: 0; font-size: 1.3rem; color: #111827; }
        .ai-header p  { margin: 2px 0 0; font-size: .83rem; color: #6b7280; }

        .quick-prompts {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 14px;
        }
        .quick-btn {
            padding: 7px 14px;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            background: #f9fafb;
            font-size: .82rem;
            color: #374151;
            cursor: pointer;
            transition: all .15s;
        }
        .quick-btn:hover { background: #ede9fe; border-color: #a5b4fc; color: #4f46e5; }

        .chat-box {
            flex: 1;
            overflow-y: auto;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            background: #f9fafb;
            padding: 18px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 14px;
        }
        .chat-msg { display: flex; gap: 10px; align-items: flex-start; }
        .chat-msg.user { flex-direction: row-reverse; }
        .chat-msg .avatar {
            width: 34px; height: 34px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: .9rem; flex-shrink: 0;
        }
        .chat-msg.assistant .avatar { background: linear-gradient(135deg, #4f46e5, #7c3aed); color: #fff; }
        .chat-msg.user     .avatar { background: #e0f2fe; color: #0369a1; }
        .chat-msg .bubble {
            max-width: 78%;
            padding: 12px 16px;
            border-radius: 14px;
            font-size: .88rem;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .chat-msg.assistant .bubble { background: #fff; border: 1px solid #e5e7eb; color: #111827; border-top-left-radius: 4px; }
        .chat-msg.user     .bubble { background: #4f46e5; color: #fff; border-top-right-radius: 4px; }

        .typing-dot { display: flex; gap: 5px; align-items: center; padding: 4px 0; }
        .typing-dot span {
            width: 8px; height: 8px; background: #9ca3af;
            border-radius: 50%; animation: bounce 1.2s infinite;
        }
        .typing-dot span:nth-child(2) { animation-delay: .2s; }
        .typing-dot span:nth-child(3) { animation-delay: .4s; }
        @keyframes bounce {
            0%,80%,100% { transform: scale(0.7); opacity:.5; }
            40%          { transform: scale(1);   opacity:1; }
        }

        .chat-input-area {
            display: flex;
            gap: 10px;
            padding-bottom: 20px;
        }
        .chat-input-area textarea {
            flex: 1;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: .9rem;
            resize: none;
            outline: none;
            font-family: inherit;
            transition: border .15s;
            min-height: 48px;
            max-height: 160px;
        }
        .chat-input-area textarea:focus { border-color: #4f46e5; }
        .btn-send {
            width: 48px; height: 48px;
            border-radius: 12px;
            background: #4f46e5;
            color: #fff;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            flex-shrink: 0;
            transition: background .15s;
        }
        .btn-send:hover { background: #4338ca; }
        .btn-send:disabled { background: #a5b4fc; cursor: not-allowed; }
        .btn-clear {
            padding: 0 16px; height: 48px;
            border-radius: 12px;
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            color: #6b7280;
            cursor: pointer;
            font-size: .82rem;
            transition: background .15s;
        }
        .btn-clear:hover { background: #fee2e2; color: #ef4444; border-color: #fca5a5; }
        .char-hint { font-size: .75rem; color: #9ca3af; text-align: right; margin-top: -10px; margin-bottom: 8px; }
    </style>
</head>
<body>
<div class="admin-layout">
    <%@ include file="/admin/common/sidebar.jsp" %>
    <main class="admin-main">
        <div class="ai-page-wrap">
            <div class="ai-header">
                <div class="ai-icon"><i class="fa-solid fa-robot"></i></div>
                <div>
                    <h2>Trợ lý AI Quản trị</h2>
                    <p>Hỗ trợ nghiệp vụ, phân tích, gợi ý chiến lược cho cửa hàng thiết bị bếp</p>
                </div>
            </div>

            <div class="quick-prompts" id="quickPrompts">
                <button class="quick-btn" onclick="useQuick(this)">📊 Cách xem báo cáo doanh thu</button>
                <button class="quick-btn" onclick="useQuick(this)">📦 Gợi ý khi hàng sắp hết</button>
                <button class="quick-btn" onclick="useQuick(this)">🎟️ Chiến lược voucher hiệu quả</button>
                <button class="quick-btn" onclick="useQuick(this)">📝 Cách viết mô tả sản phẩm hút khách</button>
                <button class="quick-btn" onclick="useQuick(this)">📣 Ý tưởng chương trình khuyến mãi</button>
                <button class="quick-btn" onclick="useQuick(this)">🔍 Cách xử lý đơn hàng bị huỷ</button>
            </div>

            <div class="chat-box" id="chatBox">
                <div class="chat-msg assistant">
                    <div class="avatar"><i class="fa-solid fa-robot"></i></div>
                    <div class="bubble">Xin chào <strong><%= currentUser.getFullname() != null ? currentUser.getFullname() : currentUser.getUsername() %></strong>! 👋
                        Tôi là trợ lý AI của <strong>WebThietBiBep</strong>. Tôi có thể giúp bạn:

                        • Hướng dẫn thao tác trên hệ thống admin
                        • Gợi ý chiến lược bán hàng & marketing
                        • Phân tích và tư vấn quản lý tồn kho
                        • Hỗ trợ soạn nội dung sản phẩm, voucher

                        Bạn cần hỗ trợ gì hôm nay?</div>
                </div>
            </div>

            <div class="char-hint" id="charHint"></div>

            <div class="chat-input-area">
                <button class="btn-clear" onclick="clearChat()" title="Xoá cuộc hội thoại">
                    <i class="fa-solid fa-trash-can"></i>
                </button>
                <textarea id="chatInput" placeholder="Nhập câu hỏi... (Enter để gửi, Shift+Enter xuống dòng)"
                          rows="1" maxlength="1000"></textarea>
                <button class="btn-send" id="sendBtn" onclick="sendMessage()" title="Gửi">
                    <i class="fa-solid fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </main>
</div>

<script>
    const chatBox   = document.getElementById('chatBox');
    const input     = document.getElementById('chatInput');
    const sendBtn   = document.getElementById('sendBtn');
    const charHint  = document.getElementById('charHint');
    const CTX       = '${pageContext.request.contextPath}';

    let history = [];

    input.addEventListener('input', () => {
        input.style.height = 'auto';
        input.style.height = Math.min(input.scrollHeight, 160) + 'px';
        charHint.textContent = input.value.length > 0 ? input.value.length + '/1000' : '';
    });

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
    });

    function useQuick(btn) {
        input.value = btn.textContent.replace(/^[^\w\u00C0-\u024F\u1E00-\u1EFF]+/, '').trim();
        input.dispatchEvent(new Event('input'));
        input.focus();
        document.getElementById('quickPrompts').style.display = 'none';
    }

    function appendMsg(role, text) {
        const div = document.createElement('div');
        div.className = 'chat-msg ' + role;
        const icon = role === 'assistant' ? 'fa-robot' : 'fa-user';
        div.innerHTML = `
            <div class="avatar"><i class="fa-solid ${icon}"></i></div>
            <div class="bubble">${escHtml(text)}</div>`;
        chatBox.appendChild(div);
        chatBox.scrollTop = chatBox.scrollHeight;
        return div;
    }

    function showTyping() {
        const div = document.createElement('div');
        div.className = 'chat-msg assistant';
        div.id = 'typingIndicator';
        div.innerHTML = `
            <div class="avatar"><i class="fa-solid fa-robot"></i></div>
            <div class="bubble"><div class="typing-dot"><span></span><span></span><span></span></div></div>`;
        chatBox.appendChild(div);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function removeTyping() {
        const t = document.getElementById('typingIndicator');
        if (t) t.remove();
    }

    function escHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
            .replace(/\n/g,'<br>').replace(/\*\*(.*?)\*\*/g,'<strong>$1</strong>');
    }

    function clearChat() {
        if (!confirm('Xoá toàn bộ cuộc hội thoại?')) return;
        history = [];
        chatBox.innerHTML = '';
        appendMsg('assistant', 'Cuộc hội thoại đã được xoá. Tôi có thể giúp gì cho bạn?');
        document.getElementById('quickPrompts').style.display = 'flex';
    }

    async function sendMessage() {
        const msg = input.value.trim();
        if (!msg || sendBtn.disabled) return;

        sendBtn.disabled = true;
        input.value = '';
        input.style.height = 'auto';
        charHint.textContent = '';

        appendMsg('user', msg);
        showTyping();

        const formData = new FormData();
        formData.append('mode', 'admin');
        formData.append('message', msg);
        formData.append('history', JSON.stringify(history));

        try {
            const res  = await fetch(CTX + '/ai-chat', { method: 'POST', body: formData });
            const data = await res.json();
            removeTyping();

            if (data.error) {
                appendMsg('assistant', '⚠️ ' + data.error);
            } else {
                const reply = data.reply || 'Không có phản hồi.';
                appendMsg('assistant', reply);
                history.push({ role: 'user', content: msg });
                history.push({ role: 'assistant', content: reply });
                if (history.length > 20) history = history.slice(history.length - 20);
            }
        } catch (err) {
            removeTyping();
            appendMsg('assistant', '⚠️ Không thể kết nối đến máy chủ AI. Vui lòng thử lại.');
        } finally {
            sendBtn.disabled = false;
            input.focus();
        }
    }
</script>
</body>
</html>

```