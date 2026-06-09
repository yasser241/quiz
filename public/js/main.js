document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    loadCompanyInfo();
    initializeCart();
    setupFormValidation();
}

function loadCompanyInfo() {
    const phone = document.getElementById('company-phone');
    const email = document.getElementById('company-email');
    const address = document.getElementById('company-address');
    
    if (phone) phone.textContent = '02612345678';
    if (email) email.textContent = 'info@quiz-shop.com';
    if (address) address.textContent = 'تهران، خیابان کاوه، شماره 123';
}

function initializeCart() {
    const cartData = localStorage.getItem('cart');
    if (cartData) {
        const cart = JSON.parse(cartData);
        updateCartCount(cart.length);
    }
}

function updateCartCount(count) {
    const cartCountEl = document.getElementById('cart-count');
    if (cartCountEl) {
        cartCountEl.textContent = count > 0 ? count : '0';
    }
}

function setupFormValidation() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!this.checkValidity() === false) {
                e.preventDefault();
                e.stopPropagation();
            }
            this.classList.add('was-validated');
        });
    });
}

function addToCart(productId, quantity = 1) {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    const existingItem = cart.find(item => item.id === productId);
    
    if (existingItem) {
        existingItem.quantity += quantity;
    } else {
        cart.push({
            id: productId,
            quantity: quantity,
            addedAt: new Date().toISOString()
        });
    }
    
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount(cart.length);
    showNotification('محصول به سبد خرید افزوده شد', 'success');
}

function removeFromCart(productId) {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    cart = cart.filter(item => item.id !== productId);
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount(cart.length);
    showNotification('محصول از سبد خرید حذف شد', 'info');
}

function showNotification(message, type = 'info') {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    setTimeout(() => { alertDiv.remove(); }, 4000);
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('fa-IR', {
        style: 'currency',
        currency: 'IRR',
        minimumFractionDigits: 0
    }).format(amount);
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

async function fetchAPI(endpoint, options = {}) {
    try {
        const response = await fetch(endpoint, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('Fetch error:', error);
        throw error;
    }
}

function isAuthenticated() {
    return !!document.querySelector('.dropdown-menu');
}

window.QuizShop = {
    addToCart,
    removeFromCart,
    showNotification,
    formatCurrency,
    debounce,
    fetchAPI,
    isAuthenticated
};
