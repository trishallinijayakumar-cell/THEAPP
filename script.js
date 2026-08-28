const screens = [...document.querySelectorAll('.screen')];

function showScreen(id) {
  screens.forEach(screen => screen.classList.toggle('active', screen.id === id));
  window.scrollTo({ top: 0, behavior: 'instant' });
}

document.querySelectorAll('[data-go]').forEach(button => {
  button.addEventListener('click', () => showScreen(button.dataset.go));
});

document.getElementById('business-form').addEventListener('submit', event => {
  event.preventDefault();
  showScreen('pending');
});

document.querySelectorAll('.filter').forEach(button => {
  button.addEventListener('click', () => {
    document.querySelectorAll('.filter').forEach(item => item.classList.remove('active'));
    button.classList.add('active');
  });
});
