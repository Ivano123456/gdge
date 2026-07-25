let dataEl = document.getElementById('data');

addEventListener('message', (event) => {
  const item = event.data;
  if (item.type === 'txt') {
    if (!dataEl) dataEl = document.getElementById('data');
    if (!dataEl) return;
    dataEl.innerHTML = item.html;
  }
});
