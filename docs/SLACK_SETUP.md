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
3. App Name: "버스예약 알림" (또는 원하는 이름) 입력
4. Workspace 선택 (w1767923673-ijw668832.slack.com)
5. "Create App" 클릭
6. 왼쪽 메뉴에서 "Incoming Webhooks" 클릭
7. "Activate Incoming Webhooks" 토글을 ON으로 변경
8. "Add New Webhook to Workspace" 클릭
9. 메시지를 받을 채널을 선택합니다 (채널 ID: C0A8295NMED 또는 해당 채널 이름)
10. "Allow" 클릭
11. 생성된 Webhook URL을 복사합니다 (형식: `https://hooks.slack.com/services/T00000000/B00000000/TOKEN`)

## 3. Webhook URL 설정

생성된 Webhook URL을 `config.js` 파일 또는 `deploy_files/config.js` 파일에 설정합니다:

```javascript
const SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/YOUR_WEBHOOK_URL_HERE';
```

**중요**: `YOUR_WEBHOOK_URL_HERE` 부분을 실제 생성한 Webhook URL로 교체해야 합니다.

## 4. 테스트

1. 웹사이트의 "Get a Quote" 또는 "견적 요청" 섹션으로 이동합니다
2. 폼을 작성합니다:
   - 이름 (Name)
   - 연락처 (Contact Number)
   - 이메일 (Email)
   - 문의 내용 (Inquiry Details)
3. "Get Quote" 또는 "견적 요청" 버튼을 클릭합니다
4. 선택한 Slack 채널로 다음 정보가 포함된 메시지가 전송됩니다:
   - 이름
   - 연락처
   - 이메일
   - 제출 시간
   - 문의 내용

## 5. 전송되는 메시지 형식

Slack 채널에는 다음과 같은 형식으로 메시지가 전송됩니다:

- 🚌 새로운 견적 요청 (또는 언어에 맞는 제목)
- 이름, 연락처, 이메일, 제출 시간 (필드 형태)
- 문의 내용 (코드 블록 형태)
- 이메일로 답변 가능한 링크

## 보안 참고사항

⚠️ **중요**: Webhook URL은 민감한 정보입니다. 
- GitHub 등 공개 저장소에 커밋하지 마세요
- `.gitignore`에 `config.js`를 추가하세요
- 프로덕션 환경에서는 환경 변수나 서버 사이드에서 처리하는 것을 권장합니다

