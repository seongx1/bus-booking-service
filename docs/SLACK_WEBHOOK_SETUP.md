# Slack Incoming Webhook 설정 가이드 (단계별)

## 현재 상태
✅ Slack App 생성 완료 (App ID: A0A7L1XG093)

## 다음 단계: Incoming Webhooks 활성화 및 Webhook URL 생성

### 1단계: Incoming Webhooks 활성화

1. **왼쪽 사이드바에서 "Features" 섹션 찾기**
   - 현재 "Basic Information" 페이지에 있습니다
   - 왼쪽 사이드바 스크롤하여 "Features" 섹션 찾기

2. **"Incoming Webhooks" 클릭**
   - "Features" 섹션 아래에 "Incoming Webhooks" 항목이 있습니다
   - 클릭하여 설정 페이지로 이동

3. **Incoming Webhooks 활성화**
   - "Activate Incoming Webhooks" 토글 버튼을 **ON**으로 변경
   - 페이지가 새로고침되면서 설정이 저장됩니다

### 2단계: Webhook을 채널에 연결

1. **"Add New Webhook to Workspace" 버튼 클릭**
   - Incoming Webhooks 페이지 아래쪽에 있는 버튼입니다

2. **채널 선택**
   - 팝업 창이 나타나면 메시지를 받을 채널을 선택합니다
   - 제공하신 채널: `C0A8295NMED` (채널 이름으로 선택 가능)
   - 또는 원하는 채널 이름을 선택하세요

3. **"Allow" 버튼 클릭**
   - 권한 승인을 위해 "Allow" 버튼을 클릭합니다

### 3단계: Webhook URL 복사

1. **생성된 Webhook URL 확인**
   - Webhooks 목록이 표시됩니다
   - 방금 생성한 Webhook을 클릭하거나
   - Webhook URL을 복사합니다
   - 형식: `https://hooks.slack.com/services/T00000000/B00000000/TOKEN`

2. **Webhook URL 예시**
   ```
   https://hooks.slack.com/services/T00000000/B00000000/TOKEN
   ```

### 4단계: config.js 파일에 Webhook URL 설정

1. **deploy_files/config.js 파일 열기**
   ```bash
   /Volumes/choimacssd/너구리여행사 버스예약 서비스/deploy_files/config.js
   ```

2. **Webhook URL 설정**
   ```javascript
   const SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/YOUR_ACTUAL_WEBHOOK_URL';
   ```
   - `YOUR_ACTUAL_WEBHOOK_URL` 부분을 3단계에서 복사한 실제 Webhook URL로 교체

3. **저장**

### 5단계: 테스트

1. **웹사이트 접속**
   - `index_v2.html` 또는 `index_v2_ko.html` 파일을 브라우저에서 열기

2. **"Get a Quote" / "견적 요청" 폼 작성**
   - 이름: 테스트
   - 연락처: 010-1234-5678
   - 이메일: test@example.com
   - 문의 내용: 테스트 메시지입니다

3. **제출**
   - "Get Quote" 또는 "견적 요청" 버튼 클릭

4. **Slack 채널 확인**
   - 설정한 Slack 채널에서 메시지가 도착했는지 확인
   - 다음 정보가 포함되어야 합니다:
     - 🚌 새로운 견적 요청
     - 이름, 연락처, 이메일, 제출 시간
     - 문의 내용

## 문제 해결

### Webhook URL을 찾을 수 없어요
- Incoming Webhooks 페이지에서 Webhooks 목록 확인
- 여러 개가 있다면 가장 최근에 생성한 것을 사용
- 각 Webhook 옆에 "Copy link" 버튼이 있을 수 있습니다

### 메시지가 전송되지 않아요
- Webhook URL이 올바른지 확인 (https://hooks.slack.com/services/로 시작)
- config.js 파일이 올바른 위치에 있는지 확인 (deploy_files/config.js)
- 브라우저 콘솔에서 에러 메시지 확인 (F12 → Console 탭)

### 권한 오류가 발생해요
- Slack App이 올바른 워크스페이스에 설치되어 있는지 확인
- 채널에 앱이 추가되어 있는지 확인 (채널에서 /invite @앱이름)

## 보안 주의사항

⚠️ **중요**: Webhook URL은 민감한 정보입니다.
- GitHub 등 공개 저장소에 커밋하지 마세요 (이미 .gitignore에 포함됨)
- Webhook URL을 공유하지 마세요
- 프로덕션 환경에서는 환경 변수나 서버 사이드에서 처리하는 것을 권장합니다
