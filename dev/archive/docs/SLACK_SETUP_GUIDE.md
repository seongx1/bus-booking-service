# 🔧 Slack Webhook 빠른 설정 가이드

## ⚡ 3분 안에 완료하기

### 1단계: Slack 워크스페이스 접속
- 브라우저에서 https://w1767923673-ijw668832.slack.com 접속
- 로그인 (필요한 경우)

### 2단계: Incoming Webhooks 앱 추가

#### 방법 A: 직접 링크 사용 (가장 빠름)
1. 브라우저에서 아래 링크 열기:
   ```
   https://w1767923673-ijw668832.slack.com/apps/A0F7XDUAZ-incoming-webhooks
   ```

#### 방법 B: 수동으로 찾기
1. Slack 왼쪽 사이드바에서 "앱" 클릭
2. 검색창에 "Incoming Webhooks" 입력
3. "Incoming Webhooks" 앱 클릭
4. "설정" 또는 "Add to Slack" 클릭

### 3단계: Webhook 생성
1. "Incoming Webhooks" 페이지에서:
   - **"새로운 Webhook 추가"** 또는 **"Add New Webhook to Workspace"** 클릭
   - 또는 기존 Webhook이 있다면 "Webhook URL" 복사

2. **채널 선택**:
   - 채널: `#홈페이지-문의-내역` (또는 원하는 채널)
   - 채널이 없다면 먼저 채널 생성

3. **"Webhook URL 생성"** 또는 **"Allow"** 클릭

### 4단계: Webhook URL 복사
- 생성된 Webhook URL 복사
- 형식: `https://hooks.slack.com/services/T[TEAM_ID]/B[CHANNEL_ID]/[WEBHOOK_TOKEN]` (예시 형식)
- **⚠️ 이 URL을 복사해서 메시지로 보내주세요!**

### 5단계: 완료
- Webhook URL을 받으면 자동으로 코드에 반영하겠습니다.
- 프록시 서버도 자동으로 업데이트됩니다.

---

## 🔍 문제 해결

### "Incoming Webhooks" 앱이 안 보일 때
1. Slack 관리자에게 문의하여 앱 설치 권한 요청
2. 또는 관리자에게 직접 Webhook 생성 요청

### 채널이 없을 때
1. 왼쪽 사이드바에서 "+" 클릭 → "채널 생성"
2. 채널 이름: `홈페이지-문의-내역`
3. 생성 후 Webhook 설정 계속

### 권한 문제일 때
- Slack 워크스페이스 관리자 권한이 필요할 수 있습니다
- 관리자에게 "Incoming Webhooks" 앱 설치 및 Webhook 생성 권한 요청
