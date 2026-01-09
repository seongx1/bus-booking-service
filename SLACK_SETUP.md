# Slack 연동 설정 가이드

## 1. Slack 워크스페이스 준비
- Slack 워크스페이스에 관리자 권한으로 로그인합니다.

## 2. Incoming Webhook 앱 추가

### 방법 1: Slack App Directory에서 추가
1. https://api.slack.com/apps 접속
2. "Create New App" 클릭
3. "From scratch" 선택
4. App Name: "버스예약 알림" (또는 원하는 이름)
5. Workspace 선택 후 "Create App" 클릭

### 방법 2: 직접 Webhook URL 생성
1. https://api.slack.com/apps 접속
2. "Create New App" → "From scratch"
3. App Name 입력 후 Workspace 선택
4. 왼쪽 메뉴에서 "Incoming Webhooks" 클릭
5. "Activate Incoming Webhooks" 토글을 ON으로 변경
6. "Add New Webhook to Workspace" 클릭
7. 메시지를 받을 채널 선택 (예: #버스예약, #inquiries 등)
8. "Allow" 클릭
9. 생성된 Webhook URL을 복사합니다 (형식: `https://hooks.slack.com/services/TEAM_ID/BOT_ID/TOKEN`)

## 3. Webhook URL 설정

생성된 Webhook URL을 `config.js` 파일에 설정합니다:

```javascript
const SLACK_WEBHOOK_URL = 'YOUR_WEBHOOK_URL_HERE';
```

## 4. 테스트

폼을 제출하면 선택한 Slack 채널로 메시지가 전송됩니다.

## 보안 참고사항

⚠️ **중요**: Webhook URL은 민감한 정보입니다. 
- GitHub 등 공개 저장소에 커밋하지 마세요
- `.gitignore`에 `config.js`를 추가하세요
- 프로덕션 환경에서는 환경 변수나 서버 사이드에서 처리하는 것을 권장합니다

