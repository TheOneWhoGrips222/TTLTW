<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>

<style>
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
  #aiChatToggle .badge {
    position: absolute; top: -4px; right: -4px;
    width: 18px; height: 18px; background: #ef4444;
    border-radius: 50%; font-size: .65rem; font-weight: 700;
    display: flex; align-items: center; justify-content: center;
    border: 2px solid #fff;
    animation: pulse 2s infinite;
  }
  @keyframes pulse {
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
    color: #fff;
    flex-shrink: 0;
  }
  .ai-win-header .bot-avatar {
    width: 38px; height: 38px;
    background: rgba(255,255,255,.25);
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.2rem;
  }
  .ai-win-header .bot-info h4 { margin: 0; font-size: .95rem; }
  .ai-win-header .bot-info p  { margin: 1px 0 0; font-size: .74rem; opacity: .85; }
  .ai-win-header .status-dot  { width: 8px; height: 8px; background: #86efac; border-radius: 50%; display: inline-block; margin-right: 4px; }
  .btn-close-chat {
    margin-left: auto;
    background: rgba(255,255,255,.2);
    border: none; color: #fff;
    width: 30px; height: 30px;
    border-radius: 8px;
    cursor: pointer; font-size: 1rem;
    display: flex; align-items: center; justify-content: center;
    transition: background .15s;
  }
  .btn-close-chat:hover { background: rgba(255,255,255,.35); }

  .ai-win-body {
    flex: 1;
    overflow-y: auto;
    padding: 14px;
    display: flex; flex-direction: column;
    gap: 12px;
    background: #fafafa;
  }
  .ai-win-body::-webkit-scrollbar { width: 4px; }
  .ai-win-body::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 4px; }

  .w-msg { display: flex; gap: 8px; align-items: flex-end; }
  .w-msg.user { flex-direction: row-reverse; }
  .w-msg .w-av {
    width: 28px; height: 28px;
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-size: .78rem; flex-shrink: 0;
  }
  .w-msg.bot .w-av  { background: linear-gradient(135deg, #f97316, #ea580c); color: #fff; }
  .w-msg.user .w-av { background: #dbeafe; color: #1d4ed8; }
  .w-msg .w-bubble {
    max-width: 82%;
    padding: 9px 13px;
    border-radius: 14px;
    font-size: .83rem;
    line-height: 1.55;
    white-space: pre-wrap;
    word-break: break-word;
  }
  .w-msg.bot  .w-bubble { background: #fff; border: 1px solid #e5e7eb; color: #111827; border-bottom-left-radius: 4px; }
  .w-msg.user .w-bubble { background: #f97316; color: #fff; border-bottom-right-radius: 4px; }

  .w-quick-wrap {
    display: flex; flex-wrap: wrap; gap: 6px;
    padding: 0 14px 10px;
    background: #fafafa;
    border-top: 1px solid #f0f0f0;
    flex-shrink: 0;
  }
  .w-quick-wrap.hidden { display: none; }
  .w-qbtn {
    padding: 5px 11px;
    border-radius: 16px;
    border: 1px solid #fed7aa;
    background: #fff7ed;
    font-size: .76rem;
    color: #c2410c;
    cursor: pointer;
    transition: background .15s;
  }
  .w-qbtn:hover { background: #ffedd5; }

  .w-typing { display: flex; gap: 4px; padding: 5px 2px; align-items: center; }
  .w-typing span {
    width: 7px; height: 7px;
    background: #d1d5db; border-radius: 50%;
    animation: wbounce 1.2s infinite;
  }
  .w-typing span:nth-child(2) { animation-delay: .2s; }
  .w-typing span:nth-child(3) { animation-delay: .4s; }
  @keyframes wbounce {
    0%,80%,100% { transform: scale(.7); opacity:.5; }
    40%          { transform: scale(1);  opacity:1; }
  }

  .product-suggestion {
    background: #fff;
    border: 1px solid #fed7aa;
    border-radius: 10px;
    padding: 10px 12px;
    margin-top: 6px;
    display: flex; gap: 10px; align-items: center;
    cursor: pointer;
    transition: border-color .15s, box-shadow .15s;
    text-decoration: none;
  }
  .product-suggestion:hover { border-color: #f97316; box-shadow: 0 2px 8px rgba(249,115,22,.15); }
  .product-suggestion img { width: 44px; height: 44px; object-fit: cover; border-radius: 8px; }
  .product-suggestion .ps-info { flex: 1; }
  .product-suggestion .ps-name { font-size: .8rem; font-weight: 600; color: #111827; }
  .product-suggestion .ps-price { font-size: .75rem; color: #f97316; margin-top: 2px; }

  .ai-win-footer {
    display: flex; gap: 8px;
    padding: 10px 12px;
    border-top: 1px solid #f0f0f0;
    background: #fff;
    flex-shrink: 0;
  }
  .ai-win-footer input {
    flex: 1;
    border: 1px solid #e5e7eb;
    border-radius: 20px;
    padding: 9px 14px;
    font-size: .84rem;
    outline: none;
    font-family: inherit;
    transition: border .15s;
  }
  .ai-win-footer input:focus { border-color: #f97316; }
  .w-send-btn {
    width: 38px; height: 38px;
    border-radius: 50%;
    background: #f97316;
    color: #fff; border: none;
    cursor: pointer; font-size: .95rem;
    display: flex; align-items: center; justify-content: center;
    transition: background .15s;
    flex-shrink: 0;
  }
  .w-send-btn:hover { background: #ea580c; }
  .w-send-btn:disabled { background: #fdba74; cursor: not-allowed; }

  @media (max-width: 480px) {
    #aiChatWindow { width: calc(100vw - 20px); right: 10px; bottom: 80px; }
    #aiChatToggle { bottom: 18px; right: 18px; }
  }
</style>

<button id="aiChatToggle" onclick="toggleAIChat()" title="Tư vấn sản phẩm AI">
  <i class="fa-solid fa-comments"></i>
  <span class="badge">AI</span>
</button>

<div id="aiChatWindow">
  <div class="ai-win-header">
    <div class="bot-avatar"><i class="fa-solid fa-robot"></i></div>
    <div class="bot-info">
      <h4>Tư vấn viên AI</h4>
      <p><span class="status-dot"></span>Trực tuyến 24/7</p>
    </div>
    <button class="btn-close-chat" onclick="toggleAIChat()">
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

<script>
  (function() {
    const W_CTX = '${pageContext.request.contextPath}';
    let wHistory = [];
    let wOpen = false;

    window.toggleAIChat = function() {
      wOpen = !wOpen;
      const win = document.getElementById('aiChatWindow');
      const btn = document.getElementById('aiChatToggle');
      if (wOpen) {
        win.classList.add('open');
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i>';
        document.getElementById('wChatInput').focus();
      } else {
        win.classList.remove('open');
        btn.innerHTML = '<i class="fa-solid fa-comments"></i><span class="badge">AI</span>';
      }
    };

    window.wUseQuick = function(btn) {
      document.getElementById('wChatInput').value = btn.textContent.replace(/^[^\w\u00C0-\u024F\u1E00-\u1EFF]+/, '').trim();
      document.getElementById('wQuick').classList.add('hidden');
      wSend();
    };

    function wAppend(role, text) {
      const body = document.getElementById('wChatBody');
      const div  = document.createElement('div');
      div.className = 'w-msg ' + role;
      const icon = role === 'bot' ? 'fa-robot' : 'fa-user';
      div.innerHTML = `<div class="w-av"><i class="fa-solid ${icon}"></i></div>
                         <div class="w-bubble">${wEsc(text)}</div>`;
      body.appendChild(div);
      body.scrollTop = body.scrollHeight;
      return div;
    }

    function wShowTyping() {
      const body = document.getElementById('wChatBody');
      const div  = document.createElement('div');
      div.className = 'w-msg bot'; div.id = 'wTyping';
      div.innerHTML = `<div class="w-av"><i class="fa-solid fa-robot"></i></div>
                         <div class="w-bubble"><div class="w-typing"><span></span><span></span><span></span></div></div>`;
      body.appendChild(div);
      body.scrollTop = body.scrollHeight;
    }

    function wRemoveTyping() {
      const t = document.getElementById('wTyping');
      if (t) t.remove();
    }

    function wEsc(str) {
      return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
              .replace(/\n/g,'<br>').replace(/\*\*(.*?)\*\*/g,'<strong>$1</strong>');
    }

    window.wSend = async function() {
      const input   = document.getElementById('wChatInput');
      const sendBtn = document.getElementById('wSendBtn');
      const msg = input.value.trim();
      if (!msg || sendBtn.disabled) return;

      sendBtn.disabled = true;
      input.value = '';
      document.getElementById('wQuick').classList.add('hidden');

      wAppend('user', msg);
      wShowTyping();

      const formData = new FormData();
      formData.append('mode', 'user');
      formData.append('message', msg);
      formData.append('history', JSON.stringify(wHistory));

      try {
        const res  = await fetch(W_CTX + '/ai-chat', { method: 'POST', body: formData });
        const data = await res.json();
        wRemoveTyping();

        if (data.error) {
          wAppend('bot', '⚠️ ' + data.error);
        } else {
          const reply = data.reply || 'Xin lỗi, tôi chưa có câu trả lời.';
          wAppend('bot', reply);
          wHistory.push({ role: 'user', content: msg });
          wHistory.push({ role: 'assistant', content: reply });
          if (wHistory.length > 16) wHistory = wHistory.slice(wHistory.length - 16);
        }
      } catch (err) {
        wRemoveTyping();
        wAppend('bot', '⚠️ Không thể kết nối. Vui lòng thử lại hoặc gọi hotline để được hỗ trợ.');
      } finally {
        sendBtn.disabled = false;
        input.focus();
      }
    };
  })();
</script>