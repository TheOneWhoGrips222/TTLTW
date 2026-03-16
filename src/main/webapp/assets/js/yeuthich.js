document.addEventListener('click', function(e) {
    const removeBtn = e.target.closest('.wishlist-remove-btn');
    if (removeBtn) {
        e.preventDefault();
        const item = removeBtn.closest('.wishlist-item');
        if (item) {
            item.style.transition = 'all 0.3s ease';
            item.style.opacity = '0';
            item.style.transform = 'scale(0.9)';

            setTimeout(() => {
                item.remove();
            }, 300);
        }
    }
});