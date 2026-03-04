/**
 * 날짜 입력 필드의 로케일을 영어로 강제 설정
 * 한국어 날짜 형식 표시를 방지하기 위함
 */
document.addEventListener('DOMContentLoaded', () => {
    const dateInputs = document.querySelectorAll('input[type="date"]');
    dateInputs.forEach(input => {
        input.setAttribute('lang', 'en');
        // 브라우저의 로케일 기반 날짜 형식을 덮어쓰기
        input.addEventListener('focus', function() {
            this.setAttribute('lang', 'en');
        });
    });
});

/**
 * 모바일 네비게이션 토글 기능
 * 햄버거 메뉴 클릭 시 메뉴 열기/닫기
 */
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');

if (hamburger && navMenu) {
    hamburger.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        hamburger.classList.toggle('active');
    });

    // 링크 클릭 시 메뉴 자동 닫기
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            hamburger.classList.remove('active');
        });
    });
}

/**
 * 앵커 링크 부드러운 스크롤 기능
 * 네비게이션 메뉴의 앵커 링크 클릭 시 해당 섹션으로 부드럽게 스크롤
 */
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            // 스티키 네비게이션 바 높이(44px) 고려한 오프셋
            const offsetTop = target.offsetTop - 44;
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

/**
 * 스크롤 시 네비게이션 바 배경색 변경
 * 스크롤 위치에 따라 네비게이션 바의 투명도와 그림자 효과 조정
 */
const navbar = document.querySelector('.navbar');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    // 50px 이상 스크롤 시 배경색과 그림자 효과 적용
    if (currentScroll > 50) {
        navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
        navbar.style.boxShadow = 'none';
    }
    
    lastScroll = currentScroll;
});

/**
 * 폼 제출 핸들러
 * 예약 문의 폼 제출 시 Slack으로 메시지 전송
 */
const bookingForm = document.getElementById('bookingForm');
if (bookingForm) {
    bookingForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // 폼 데이터 추출
        const formData = new FormData(bookingForm);
        const data = Object.fromEntries(formData);
        
        // 프로덕션: 같은 오리진 프록시 사용. 로컬: SLACK_WEBHOOK_URL 또는 로컬 프록시
        const isLocal = typeof window !== 'undefined' && (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1');
        const webhookUrl = isLocal
            ? (typeof SLACK_WEBHOOK_URL !== 'undefined' && SLACK_WEBHOOK_URL && SLACK_WEBHOOK_URL !== 'YOUR_WEBHOOK_URL_HERE'
                ? SLACK_WEBHOOK_URL
                : 'http://localhost:8888/slack-webhook')
            : (window.location.origin + '/slack-webhook-proxy.php');
        if (isLocal && (!webhookUrl || webhookUrl === 'http://localhost:8888/slack-webhook')) {
            if (typeof console !== 'undefined') console.warn('로컬: SLACK_WEBHOOK_URL 또는 slack_proxy.py(8888) 설정 필요');
            return;
        }
        
        // 중복 제출 방지를 위해 제출 버튼 비활성화
        const submitButton = bookingForm.querySelector('button[type="submit"]');
        const originalButtonText = submitButton.textContent;
        submitButton.disabled = true;
        submitButton.textContent = '전송 중...';
        
        try {
            // Slack 메시지 포맷팅
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
            
            // Slack으로 메시지 전송 (프로덕션: 프록시, 로컬: Webhook URL 또는 로컬 프록시)
            const response = await fetch(webhookUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(slackMessage)
            });
            const result = response.ok ? await response.json().catch(() => ({})) : null;
            if (response.ok && (result === null || result.success !== false)) {
                showNotification('✅ 문의가 성공적으로 전송되었습니다. 빠른 시일 내에 답변드리겠습니다!');
                bookingForm.reset();
            } else {
                throw new Error(result && result.error ? result.error : 'Slack 전송 실패');
            }
        } catch (error) {
            console.error('Slack 전송 오류:', error);
            showNotification('❌ 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', 'error');
        } finally {
            // 제출 버튼 다시 활성화
            submitButton.disabled = false;
            submitButton.textContent = originalButtonText;
        }
    });
}

/**
 * 알림 메시지 표시 함수
 * @param {string} message - 표시할 메시지
 * @param {string} type - 알림 타입 ('success' 또는 'error')
 */
function showNotification(message, type = 'success') {
    // 기존 알림이 있으면 제거
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    // 타입에 따라 배경색 설정 (에러: 빨강, 성공: 검정)
    const backgroundColor = type === 'error' ? '#d32f2f' : '#1d1d1f';
    
    // 알림 요소 생성
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
    
    // 애니메이션 스타일 추가
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
    
    // 5초 후 알림 자동 제거
    setTimeout(() => {
        notification.style.animation = 'slideUp 0.3s ease-out';
        setTimeout(() => {
            notification.remove();
            style.remove();
        }, 300);
    }, 5000);
}

/**
 * Intersection Observer를 사용한 페이드인 애니메이션
 * 요소가 화면에 나타날 때 부드럽게 나타나는 효과
 */
const observerOptions = {
    threshold: 0.1, // 요소가 10% 보일 때 트리거
    rootMargin: '0px 0px -50px 0px' // 하단에서 50px 전에 트리거
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

/**
 * 애니메이션 대상 요소 관찰 시작
 * 서비스 카드, 기능 아이템, 지역 아이템, 연락처 아이템에 페이드인 효과 적용
 */
document.addEventListener('DOMContentLoaded', () => {
    const animatedElements = document.querySelectorAll('.service-card, .feature-item, .area-item, .contact-item');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
        observer.observe(el);
    });
});

/**
 * 현재 섹션에 해당하는 네비게이션 링크에 활성 상태 추가
 * 스크롤 위치에 따라 해당하는 네비게이션 메뉴 항목을 하이라이트
 */
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-menu a[href^="#"]');

function highlightNavigation() {
    let current = '';
    
    // 현재 스크롤 위치에 해당하는 섹션 찾기
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        // 섹션 상단에서 100px 전에 진입하면 해당 섹션으로 인식
        if (pageYOffset >= sectionTop - 100) {
            current = section.getAttribute('id');
        }
    });
    
    // 네비게이션 링크 스타일 업데이트
    navLinks.forEach(link => {
        link.style.color = 'var(--color-text-secondary)';
        // 현재 섹션에 해당하는 링크만 강조
        if (link.getAttribute('href') === `#${current}`) {
            link.style.color = 'var(--color-text-primary)';
        }
    });
}

window.addEventListener('scroll', highlightNavigation);
highlightNavigation(); // 초기 호출로 현재 위치 반영

/**
 * 이미지 지연 로딩 (Lazy Loading)
 * 화면에 나타날 때만 이미지를 로드하여 성능 최적화
 */
document.addEventListener('DOMContentLoaded', () => {
    const lazyImages = document.querySelectorAll('img[loading="lazy"]');
    
    // IntersectionObserver 지원 여부 확인
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    // 이미지가 이미 로드된 경우
                    if (img.complete && img.naturalHeight !== 0) {
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    } else {
                        // 이미지 로드 완료 대기
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
        // IntersectionObserver를 지원하지 않는 브라우저용 폴백
        lazyImages.forEach(img => {
            img.classList.add('loaded');
        });
    }
    
    // 이미지 로딩 오류 처리
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
