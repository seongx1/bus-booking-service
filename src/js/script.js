// Force English locale for date inputs (to prevent Korean format display)
document.addEventListener('DOMContentLoaded', () => {
    const dateInputs = document.querySelectorAll('input[type="date"]');
    dateInputs.forEach(input => {
        input.setAttribute('lang', 'en');
        // Override browser's locale-based date format
        input.addEventListener('focus', function() {
            this.setAttribute('lang', 'en');
        });
    });
});

// Mobile Navigation Toggle
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');

if (hamburger && navMenu) {
    hamburger.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        hamburger.classList.toggle('active');
    });

    // Close menu when clicking on a link
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            hamburger.classList.remove('active');
        });
    });
}

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const offsetTop = target.offsetTop - 44; // Account for sticky nav
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

// Navbar background on scroll
const navbar = document.querySelector('.navbar');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 50) {
        navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
        navbar.style.boxShadow = 'none';
    }
    
    lastScroll = currentScroll;
});

// Form submission handler
const bookingForm = document.getElementById('bookingForm');
if (bookingForm) {
    bookingForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(bookingForm);
        const data = Object.fromEntries(formData);
        
        // Check if Slack Webhook URL is configured
        if (!SLACK_WEBHOOK_URL || SLACK_WEBHOOK_URL === 'YOUR_WEBHOOK_URL_HERE') {
            showNotification('⚠️ Slack Webhook이 설정되지 않았습니다. 관리자에게 문의하세요.', 'error');
            return;
        }
        
        // Disable submit button to prevent double submission
        const submitButton = bookingForm.querySelector('button[type="submit"]');
        const originalButtonText = submitButton.textContent;
        submitButton.disabled = true;
        submitButton.textContent = '전송 중...';
        
        try {
            // Format Slack message
            const slackMessage = {
                text: '🚌 새로운 문의가 도착했습니다',
                blocks: [
                    {
                        type: 'header',
                        text: {
                            type: 'plain_text',
                            text: '🚌 새로운 문의'
                        }
                    },
                    {
                        type: 'section',
                        fields: [
                            {
                                type: 'mrkdwn',
                                text: `*이름:*\n${data.name || 'N/A'}`
                            },
                            {
                                type: 'mrkdwn',
                                text: `*연락처:*\n${data.contact || 'N/A'}`
                            },
                            {
                                type: 'mrkdwn',
                                text: `*이메일:*\n${data.email || 'N/A'}`
                            },
                            {
                                type: 'mrkdwn',
                                text: `*제출 시간:*\n${new Date().toLocaleString('ko-KR', { timeZone: 'Asia/Seoul' })}`
                            }
                        ]
                    },
                    {
                        type: 'section',
                        text: {
                            type: 'mrkdwn',
                            text: `*문의 내용:*\n\`\`\`${data.message || 'N/A'}\`\`\``
                        }
                    },
                    {
                        type: 'divider'
                    },
                    {
                        type: 'context',
                        elements: [
                            {
                                type: 'mrkdwn',
                                text: `📧 이메일로 답변: <mailto:${data.email}|${data.email}>`
                            }
                        ]
                    }
                ]
            };
            
            // Send to Slack
            const response = await fetch(SLACK_WEBHOOK_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(slackMessage)
            });
            
            if (response.ok) {
                showNotification('✅ 문의가 성공적으로 전송되었습니다. 빠른 시일 내에 답변드리겠습니다!');
                bookingForm.reset();
            } else {
                throw new Error('Slack 전송 실패');
            }
        } catch (error) {
            console.error('Slack 전송 오류:', error);
            showNotification('❌ 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', 'error');
        } finally {
            // Re-enable submit button
            submitButton.disabled = false;
            submitButton.textContent = originalButtonText;
        }
    });
}

// Notification function
function showNotification(message, type = 'success') {
    // Remove existing notification if any
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    // Set background color based on type
    const backgroundColor = type === 'error' ? '#d32f2f' : '#1d1d1f';
    
    // Create notification element
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 60px;
        left: 50%;
        transform: translateX(-50%);
        background-color: ${backgroundColor};
        color: white;
        padding: 16px 24px;
        border-radius: 12px;
        font-size: 14px;
        z-index: 10000;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        animation: slideDown 0.3s ease-out;
        max-width: 90%;
        text-align: center;
    `;
    
    // Add animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateX(-50%) translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
        }
        @keyframes slideUp {
            from {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
            to {
                opacity: 0;
                transform: translateX(-50%) translateY(-20px);
            }
        }
    `;
    document.head.appendChild(style);
    
    document.body.appendChild(notification);
    
    // Remove notification after 5 seconds
    setTimeout(() => {
        notification.style.animation = 'slideUp 0.3s ease-out';
        setTimeout(() => {
            notification.remove();
            style.remove();
        }, 300);
    }, 5000);
}

// Intersection Observer for fade-in animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation
document.addEventListener('DOMContentLoaded', () => {
    const animatedElements = document.querySelectorAll('.service-card, .feature-item, .area-item, .contact-item');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
        observer.observe(el);
    });
});

// Add active state to current section in navigation
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-menu a[href^="#"]');

function highlightNavigation() {
    let current = '';
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (pageYOffset >= sectionTop - 100) {
            current = section.getAttribute('id');
        }
    });
    
    navLinks.forEach(link => {
        link.style.color = 'var(--color-text-secondary)';
        if (link.getAttribute('href') === `#${current}`) {
            link.style.color = 'var(--color-text-primary)';
        }
    });
}

window.addEventListener('scroll', highlightNavigation);
highlightNavigation(); // Initial call

// Lazy load images
document.addEventListener('DOMContentLoaded', () => {
    const lazyImages = document.querySelectorAll('img[loading="lazy"]');
    
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.complete && img.naturalHeight !== 0) {
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    } else {
                        img.addEventListener('load', () => {
                            img.classList.add('loaded');
                        });
                        observer.unobserve(img);
                    }
                }
            });
        });
        
        lazyImages.forEach(img => imageObserver.observe(img));
    } else {
        // Fallback for browsers without IntersectionObserver
        lazyImages.forEach(img => {
            img.classList.add('loaded');
        });
    }
    
    // Handle image loading errors
    document.querySelectorAll('img').forEach(img => {
        img.addEventListener('error', function() {
            this.style.display = 'none';
            const wrapper = this.closest('.hero-image-wrapper, .service-image-wrapper, .area-image-wrapper, .transport-image-wrapper');
            if (wrapper) {
                wrapper.style.backgroundColor = '#f5f5f7';
                wrapper.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #86868b; font-size: 14px;">Image loading...</div>';
            }
        });
    });
});
