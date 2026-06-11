<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>


<style>
  .notif-wrapper {
    position: relative;
    display: inline-flex;
    align-items: center;
  }

  .notif-bell-btn {
    background: rgba(255,255,255,.1);
    border: none;
    cursor: pointer;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 1.1rem;
    position: relative;
    transition: background .2s;
  }
  .notif-bell-btn:hover { background: rgba(255,255,255,.22); }

  .notif-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    background: #ef4444;
    color: #fff;
    font-size: .65rem;
    font-weight: 700;
    min-width: 18px;
    height: 18px;
    border-radius: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4px;
    pointer-events: none;
    animation: notif-pop .3s ease;
  }
  @keyframes notif-pop {
    0%   { transform: scale(0); }
    60%  { transform: scale(1.3); }
    100% { transform: scale(1); }
  }
  .notif-badge.hidden { display: none; }

  .notif-dropdown {
    display: none;
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    width: 360px;
    max-width: 96vw;
    background: #fff;
    border-radius: 14px;
    box-shadow: 0 8px 32px rgba(0,0,0,.18);
    z-index: 9999;
    overflow: hidden;
    border: 1px solid #e5e7eb;
  }
  .notif-dropdown.open { display: block; animation: notif-slide .2s ease; }
  @keyframes notif-slide {
    from { opacity: 0; transform: translateY(-8px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .notif-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 16px 10px;
    border-bottom: 1px solid #f3f4f6;
  }
  .notif-header h4 {
    margin: 0;
    font-size: .95rem;
    color: #111827;
    font-weight: 700;
  }
  .notif-refresh-btn {
    background: none;
    border: none;
    cursor: pointer;
    color: #6b7280;
    font-size: .82rem;
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 4px 8px;
    border-radius: 6px;
    transition: background .15s;
  }
  .notif-refresh-btn:hover { background: #f3f4f6; color: #374151; }

  .notif-list {
    max-height: 400px;
    overflow-y: auto;
  }
  .notif-list::-webkit-scrollbar { width: 4px; }
  .notif-list::-webkit-scrollbar-track { background: #f9fafb; }
  .notif-list::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 2px; }

  .notif-item {
    display: flex;
    align-items: flex-start;
    gap: 11px;
    padding: 12px 16px;
    border-bottom: 1px solid #f9fafb;
    text-decoration: none;
    color: inherit;
    transition: background .15s;
    cursor: pointer;
  }
  .notif-item:hover { background: #f9fafb; }
  .notif-item:last-child { border-bottom: none; }

  .notif-icon {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: .9rem;
    flex-shrink: 0;
    margin-top: 1px;
  }
  .notif-green  { background: #dcfce7; color: #16a34a; }
  .notif-red    { background: #fee2e2; color: #dc2626; }
  .notif-orange { background: #ffedd5; color: #ea580c; }
  .notif-blue   { background: #dbeafe; color: #2563eb; }
  .notif-purple { background: #ede9fe; color: #7c3aed; }

  .notif-body { flex: 1; min-width: 0; }
  .notif-title {
    font-size: .82rem;
    font-weight: 700;
    color: #374151;
    margin-bottom: 2px;
  }
  .notif-msg {
    font-size: .8rem;
    color: #6b7280;
    line-height: 1.4;
    white-space: normal;
    overflow-wrap: break-word;
  }
  .notif-time {
    font-size: .73rem;
    color: #9ca3af;
    margin-top: 3px;
  }

  .notif-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 36px 20px;
    color: #9ca3af;
    gap: 8px;
  }
  .notif-empty i { font-size: 2rem; }
  .notif-empty span { font-size: .85rem; }

  .notif-loading {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 30px;
    color: #9ca3af;
    gap: 8px;
    font-size: .85rem;
  }
  .notif-spinner {
    width: 18px;
    height: 18px;
    border: 2px solid #e5e7eb;
    border-top-color: #6366f1;
    border-radius: 50%;
    animation: spin .7s linear infinite;
  }
  @keyframes spin { to { transform: rotate(360deg); } }

  .notif-footer {
    padding: 10px 16px;
    border-top: 1px solid #f3f4f6;
    text-align: center;
  }
  .notif-footer a {
    font-size: .82rem;
    color: #6366f1;
    text-decoration: none;
    font-weight: 600;
  }
  .notif-footer a:hover { text-decoration: underline; }
</style>

<div class="notif-wrapper" id="notifWrapper">
  <button class="notif-bell-btn" id="notifBellBtn"
          onclick="toggleNotifDropdown(event)"
          title="Thông báo">
    <i class="fa-solid fa-bell"></i>
    <span class="notif-badge hidden" id="notifBadge">0</span>
  </button>

  <div class="notif-dropdown" id="notifDropdown">
    <div class="notif-header">
      <h4><i class="fa-solid fa-bell" style="color:#6366f1;margin-right:6px"></i>Thông báo</h4>
      <button class="notif-refresh-btn" onclick="loadNotifications(true)">
        <i class="fa-solid fa-rotate-right" id="notifRefreshIcon"></i> Làm mới
      </button>
    </div>
    <div class="notif-list" id="notifList">
      <div class="notif-loading">
        <div class="notif-spinner"></div> Đang tải...
      </div>
    </div>
    <div class="notif-footer">
      <a href="<%=request.getContextPath()%>/admin/dashboard">Xem tổng quan →</a>
    </div>
  </div>
</div>

<script>
  (function() {
    var BASE = '<%=request.getContextPath()%>';
    var _open = false;
    var _readIds = JSON.parse(localStorage.getItem('notif_read') || '[]');
    var _loaded = false;

    function markRead(id) {
      if (!_readIds.includes(id)) {
        _readIds.push(id);
        localStorage.setItem('notif_read', JSON.stringify(_readIds));
      }
    }

    window.toggleNotifDropdown = function(e) {
      e.stopPropagation();
      _open = !_open;
      document.getElementById('notifDropdown').classList.toggle('open', _open);
      if (_open && !_loaded) { loadNotifications(false); }
    };

    document.addEventListener('click', function(e) {
      var wrapper = document.getElementById('notifWrapper');
      if (wrapper && !wrapper.contains(e.target) && _open) {
        _open = false;
        document.getElementById('notifDropdown').classList.remove('open');
      }
    });

    function updateBadge(count) {
      var badge = document.getElementById('notifBadge');
      if (!badge) return;
      if (count <= 0) {
        badge.classList.add('hidden');
      } else {
        badge.classList.remove('hidden');
        badge.textContent = count > 99 ? '99+' : count;
      }
    }

    window.loadNotifications = function(force) {
      if (force) _loaded = false;

      var list = document.getElementById('notifList');
      var icon = document.getElementById('notifRefreshIcon');
      if (!list) return;

      list.innerHTML = '<div class="notif-loading"><div class="notif-spinner"></div> Đang tải...</div>';
      if (icon) icon.style.animation = 'spin .7s linear infinite';

      fetch(BASE + '/admin/notifications', { credentials: 'same-origin' })
              .then(function(r) { return r.json(); })
              .then(function(data) {
                _loaded = true;
                if (icon) icon.style.animation = '';
                renderNotifications(data);
              })
              .catch(function() {
                if (icon) icon.style.animation = '';
                list.innerHTML = '<div class="notif-empty"><i class="fa-solid fa-wifi"></i><span>Không thể tải thông báo</span></div>';
              });
    };

    function renderNotifications(data) {
      var list = document.getElementById('notifList');
      if (!list) return;

      if (!data || data.length === 0) {
        list.innerHTML = '<div class="notif-empty"><i class="fa-regular fa-bell-slash"></i><span>Không có thông báo mới</span></div>';
        updateBadge(0);
        return;
      }

      var unread = data.filter(function(n) { return !_readIds.includes(n.id); }).length;
      updateBadge(unread);

      var html = '';
      data.forEach(function(n) {
        var isRead = _readIds.includes(n.id);
        html += '<a class="notif-item" href="' + escHtml(n.link) + '" ' +
                'onclick="markNotifRead(\'' + escHtml(n.id) + '\')"' +
                (isRead ? ' style="opacity:.65"' : '') + '>' +
                '<div class="notif-icon ' + escHtml(n.colorClass) + '">' +
                '<i class="' + escHtml(n.icon) + '"></i>' +
                '</div>' +
                '<div class="notif-body">' +
                '<div class="notif-title">' + escHtml(n.title) +
                (!isRead ? ' <span style="display:inline-block;width:7px;height:7px;background:#6366f1;border-radius:50%;vertical-align:middle;margin-left:3px"></span>' : '') +
                '</div>' +
                '<div class="notif-msg">' + escHtml(n.message) + '</div>' +
                '<div class="notif-time"><i class="fa-regular fa-clock" style="font-size:.7rem"></i> ' + escHtml(n.time) + '</div>' +
                '</div>' +
                '</a>';
      });
      list.innerHTML = html;
    }

    window.markNotifRead = function(id) {
      markRead(id);
      // Re-render badge
      var badge = document.getElementById('notifBadge');
      if (badge && !badge.classList.contains('hidden')) {
        var count = parseInt(badge.textContent) || 0;
        updateBadge(Math.max(0, count - 1));
      }
    };

    function escHtml(s) {
      if (!s) return '';
      return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;')
              .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function pollBadge() {
      fetch(BASE + '/admin/notifications?count=1', { credentials: 'same-origin' })
              .then(function(r) { return r.json(); })
              .then(function(d) {
                updateBadge(d.count);
              })
              .catch(function() {});
    }

    pollBadge();
    setInterval(pollBadge, 60000);
  })();
</script>
