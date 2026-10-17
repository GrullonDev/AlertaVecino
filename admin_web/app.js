(function () {
  'use strict';

  const API = 'http://localhost:8080/api/v1';

  // ── State ──
  let token = null;
  let user = null;
  let currentFilter = '';
  let currentPassData = null;

  // ── DOM refs ──
  const $ = (s) => document.querySelector(s);
  const $$ = (s) => document.querySelectorAll(s);

  const loginScreen = $('#login-screen');
  const appScreen = $('#app-screen');
  const loginForm = $('#login-form');
  const loginError = $('#login-error');
  const loginBtn = $('#login-btn');
  const navTabs = $('#nav-tabs');
  const logoutBtn = $('#logout-btn');
  const toast = $('#toast');

  // ── Helpers ──
  function headers(extra) {
    const h = { 'Content-Type': 'application/json' };
    if (token) h['Authorization'] = 'Bearer ' + token;
    return Object.assign(h, extra);
  }

  async function api(path, opts) {
    const res = await fetch(API + path, Object.assign({ headers: headers() }, opts));
    const data = await res.json();
    if (!res.ok) throw { status: res.status, data };
    return data;
  }

  function showToast(msg, type) {
    toast.textContent = msg;
    toast.className = 'toast show ' + (type || '');
    clearTimeout(toast._tid);
    toast._tid = setTimeout(() => { toast.className = 'toast hidden'; }, 3000);
  }

  function formatDate(iso) {
    if (!iso) return '—';
    const d = new Date(iso);
    return d.toLocaleString('es-GT', { dateStyle: 'medium', timeStyle: 'short' });
  }

  function confirm(title, message) {
    return new Promise((resolve) => {
      const overlay = $('#confirm-dialog');
      $('#confirm-title').textContent = title;
      $('#confirm-message').textContent = message;
      overlay.classList.remove('hidden');
      const cancel = () => { overlay.classList.add('hidden'); resolve(false); };
      const ok = () => { overlay.classList.add('hidden'); resolve(true); };
      $('#confirm-cancel').onclick = cancel;
      $('#confirm-ok').onclick = ok;
    });
  }

  // ── Auth ──
  function saveSession() {
    try {
      sessionStorage.setItem('av_token', token);
      sessionStorage.setItem('av_user', JSON.stringify(user));
    } catch (_) { /* private mode */ }
  }

  function loadSession() {
    try {
      token = sessionStorage.getItem('av_token');
      const raw = sessionStorage.getItem('av_user');
      if (raw) user = JSON.parse(raw);
    } catch (_) { /* ignore */ }
  }

  function clearSession() {
    token = null;
    user = null;
    try { sessionStorage.removeItem('av_token'); sessionStorage.removeItem('av_user'); } catch (_) {}
  }

  function showLogin() {
    loginScreen.classList.add('active');
    appScreen.classList.remove('active');
  }

  function showApp() {
    loginScreen.classList.remove('active');
    appScreen.classList.add('active');
    appScreen.classList.add('active');
    $('#nav-user-email').textContent = user.email;
    const badge = $('#nav-user-role');
    badge.textContent = user.role;
    badge.className = 'role-badge ' + user.role;
    buildNav();
  }

  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    loginError.classList.add('hidden');
    loginBtn.querySelector('.btn-text').textContent = 'Ingresando…';
    loginBtn.querySelector('.btn-loader').classList.remove('hidden');
    loginBtn.disabled = true;

    try {
      const email = $('#login-email').value.trim();
      const password = $('#login-password').value;
      const data = await api('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      });
      token = data.token;
      user = data.user;
      user.role = data.role || user.role || 'resident';
      saveSession();
      showApp();
    } catch (err) {
      const msg = err.data?.error || 'Error al iniciar sesión';
      loginError.textContent = msg;
      loginError.classList.remove('hidden');
    } finally {
      loginBtn.querySelector('.btn-text').textContent = 'Iniciar Sesión';
      loginBtn.querySelector('.btn-loader').classList.add('hidden');
      loginBtn.disabled = false;
    }
  });

  logoutBtn.addEventListener('click', () => {
    clearSession();
    showLogin();
  });

  // ── Navigation ──
  const tabs = {
    admin: [
      { id: 'users', label: 'Residentes' },
      { id: 'scanner', label: 'Pases' },
    ],
    guard: [
      { id: 'scanner', label: 'Pases' },
    ],
    resident: [],
  };

  function buildNav() {
    const role = user.role || 'resident';
    const list = tabs[role] || tabs.resident;
    navTabs.innerHTML = '';
    list.forEach((t, i) => {
      const btn = document.createElement('button');
      btn.className = 'nav-tab' + (i === 0 ? ' active' : '');
      btn.textContent = t.label;
      btn.dataset.panel = t.id;
      btn.addEventListener('click', () => switchPanel(t.id));
      navTabs.appendChild(btn);
    });
    if (list.length > 0) switchPanel(list[0].id);
  }

  function switchPanel(id) {
    $$('.panel').forEach((p) => p.classList.add('hidden'));
    const panel = $('#panel-' + id);
    if (panel) panel.classList.remove('hidden');
    $$('.nav-tab').forEach((t) => t.classList.toggle('active', t.dataset.panel === id));

    if (id === 'users') loadUsers();
  }

  // ── Admin: Users ──
  $$('.filter-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      $$('.filter-btn').forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      currentFilter = btn.dataset.status;
      loadUsers();
    });
  });

  async function loadUsers() {
    const loading = $('#users-loading');
    const empty = $('#users-empty');
    const wrap = $('#users-table-wrap');
    loading.classList.remove('hidden');
    empty.classList.add('hidden');
    wrap.classList.add('hidden');

    try {
      const qs = currentFilter ? '?status=' + currentFilter : '';
      const data = await api('/admin/users' + qs);
      loading.classList.add('hidden');

      if (!data.users || data.users.length === 0) {
        empty.classList.remove('hidden');
        return;
      }

      const tbody = $('#users-tbody');
      tbody.innerHTML = '';
      data.users.forEach((u) => {
        const tr = document.createElement('tr');
        const fullName = [u.firstName, u.lastName].filter(Boolean).join(' ') || '—';
        tr.innerHTML =
          '<td>' + esc(fullName) + '</td>' +
          '<td>' + esc(u.email || '—') + '</td>' +
          '<td>' + esc(u.phone || '—') + '</td>' +
          '<td>' + esc(u.residency || '—') + '</td>' +
          '<td>' + esc(u.house || '—') + '</td>' +
          '<td><span class="status-chip ' + (u.status || '') + '">' + esc(statusLabel(u.status)) + '</span></td>' +
          '<td>' + formatDate(u.createdAt) + '</td>' +
          '<td class="action-group">' + userActions(u) + '</td>';
        tbody.appendChild(tr);
      });

      wrap.classList.remove('hidden');
      bindUserActions();
    } catch (err) {
      loading.classList.add('hidden');
      if (err.status === 401) { clearSession(); showLogin(); return; }
      showToast('Error al cargar usuarios', 'error');
    }
  }

  function statusLabel(s) {
    return { pending: 'Pendiente', approved: 'Aprobado', rejected: 'Rechazado' }[s] || s || '—';
  }

  function userActions(u) {
    if (u.status === 'pending') {
      return '<button class="btn btn-sm btn-success" data-action="approve" data-id="' + u.id + '">Aprobar</button>' +
             '<button class="btn btn-sm btn-danger" data-action="reject" data-id="' + u.id + '">Rechazar</button>';
    }
    if (u.status === 'approved') {
      return '<button class="btn btn-sm btn-danger" data-action="reject" data-id="' + u.id + '">Rechazar</button>';
    }
    if (u.status === 'rejected') {
      return '<button class="btn btn-sm btn-success" data-action="approve" data-id="' + u.id + '">Aprobar</button>';
    }
    return '';
  }

  function bindUserActions() {
    $$('[data-action="approve"]').forEach((btn) => {
      btn.addEventListener('click', async () => {
        const id = btn.dataset.id;
        const ok = await confirm('Aprobar residente', '¿Desea aprobar a este residente? Podrá iniciar sesión en la app.');
        if (!ok) return;
        btn.disabled = true;
        try {
          await api('/admin/users/approve', { method: 'POST', body: JSON.stringify({ id }) });
          showToast('Residente aprobado', 'success');
          loadUsers();
        } catch (err) {
          showToast(err.data?.error || 'Error', 'error');
          btn.disabled = false;
        }
      });
    });

    $$('[data-action="reject"]').forEach((btn) => {
      btn.addEventListener('click', async () => {
        const id = btn.dataset.id;
        const ok = await confirm('Rechazar residente', '¿Desea rechazar a este residente? No podrá iniciar sesión.');
        if (!ok) return;
        btn.disabled = true;
        try {
          await api('/admin/users/reject', { method: 'POST', body: JSON.stringify({ id }) });
          showToast('Residente rechazado', 'success');
          loadUsers();
        } catch (err) {
          showToast(err.data?.error || 'Error', 'error');
          btn.disabled = false;
        }
      });
    });
  }

  // ── Guard: Pass Scanner ──
  const passInput = $('#pass-id-input');
  const searchBtn = $('#search-pass-btn');

  searchBtn.addEventListener('click', () => searchPass());
  passInput.addEventListener('keydown', (e) => { if (e.key === 'Enter') searchPass(); });

  async function searchPass() {
    let passId = passInput.value.trim();
    if (!passId) return;

    // Support full QR URL: alertavecino://pass/<id>
    const match = passId.match(/alertavecino:\/\/pass\/(.+)/);
    if (match) passId = match[1];

    const loading = $('#pass-loading');
    const error = $('#pass-error');
    const result = $('#pass-result');

    error.classList.add('hidden');
    result.classList.add('hidden');
    loading.classList.remove('hidden');

    try {
      const data = await api('/visitors/passes/' + encodeURIComponent(passId));
      loading.classList.add('hidden');
      currentPassData = data.pass;
      renderPass(data.pass);
      result.classList.remove('hidden');
    } catch (err) {
      loading.classList.add('hidden');
      if (err.status === 401) { clearSession(); showLogin(); return; }
      const msg = err.status === 404 ? 'Pase no encontrado. Verifica el ID.' : (err.data?.error || 'Error al buscar el pase');
      error.textContent = msg;
      error.classList.remove('hidden');
    }
  }

  function renderPass(p) {
    const badge = $('#pass-status-badge');
    badge.textContent = statusPassLabel(p.status);
    badge.className = 'pass-status-badge ' + (p.status || '');

    $('#pass-type').textContent = visitTypeLabel(p.visitType);
    $('#pass-visitor-name').textContent = p.visitorName || '—';
    $('#pass-dpi').textContent = p.dpi || '—';
    $('#pass-plate').textContent = p.plate || '—';
    $('#pass-valid-from').textContent = formatDate(p.validFrom);
    $('#pass-valid-until').textContent = formatDate(p.validUntil);
    $('#pass-entry-time').textContent = p.entryTime ? formatDate(p.entryTime) : 'No ha ingresado';

    const r = p.resident || {};
    $('#pass-resident-name').textContent = r.name || '—';
    $('#pass-resident-email').textContent = r.email || '—';
    $('#pass-resident-residency').textContent = r.residency || '—';
    $('#pass-resident-house').textContent = r.house || '—';

    renderPassActions(p);
  }

  function renderPassActions(p) {
    const container = $('#pass-actions');
    container.innerHTML = '';
    const role = user.role;

    if (p.status === 'expected' && (role === 'admin' || role === 'guard')) {
      addBtn(container, 'En Portería', 'btn-warning', () => updatePassStatus(p.id, 'at_gate'));
      addBtn(container, 'Registrar Entrada', 'btn-success', () => updatePassStatus(p.id, 'entered'));
    } else if (p.status === 'at_gate' && (role === 'admin' || role === 'guard')) {
      addBtn(container, 'Registrar Entrada', 'btn-success', () => updatePassStatus(p.id, 'entered'));
    }

    if (p.status !== 'expired' && p.status !== 'entered') {
      addBtn(container, 'Marcar Expirado', 'btn-outline', () => updatePassStatus(p.id, 'expired'));
    }

    if (container.children.length === 0) {
      const span = document.createElement('span');
      span.style.color = 'var(--text-secondary)';
      span.style.fontSize = '13px';
      span.textContent = 'No hay acciones disponibles para este estado.';
      container.appendChild(span);
    }
  }

  function addBtn(parent, label, cls, handler) {
    const btn = document.createElement('button');
    btn.className = 'btn ' + cls;
    btn.textContent = label;
    btn.addEventListener('click', handler);
    parent.appendChild(btn);
  }

  async function updatePassStatus(passId, newStatus) {
    const labels = { at_gate: 'en portería', entered: 'ingresado', expired: 'expirado' };
    const ok = await confirm(
      'Cambiar estado',
      'El pase se marcará como "' + (labels[newStatus] || newStatus) + '". ¿Continuar?'
    );
    if (!ok) return;

    try {
      const data = await api('/visitors/passes/' + passId + '/status', {
        method: 'PATCH',
        body: JSON.stringify({ status: newStatus }),
      });
      showToast('Estado actualizado: ' + (labels[newStatus] || newStatus), 'success');
      // Update in place
      currentPassData.status = data.pass.status;
      if (data.pass.entryTime) currentPassData.entryTime = data.pass.entryTime;
      renderPass(currentPassData);
    } catch (err) {
      showToast(err.data?.error || 'Error al actualizar estado', 'error');
    }
  }

  function statusPassLabel(s) {
    return { expected: 'Esperado', at_gate: 'En Portería', entered: 'Ingresó', expired: 'Expirado' }[s] || s || '—';
  }

  function visitTypeLabel(t) {
    return { family: 'Familiar', delivery: 'Delivery', service: 'Servicio', other: 'Otro' }[t] || t || '—';
  }

  function esc(str) {
    const d = document.createElement('div');
    d.textContent = str;
    return d.innerHTML;
  }

  // ── Boot ──
  loadSession();
  if (token && user) {
    showApp();
  } else {
    showLogin();
  }
})();
