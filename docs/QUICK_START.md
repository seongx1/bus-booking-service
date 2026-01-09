# Slack Webhook 빠른 설정 가이드

## 현재까지 완료된 작업 ✅

1. ✅ Slack App 생성 완료 (App ID: A0A7L1XG093)
2. ✅ "Get a Quote" 폼 Slack 전송 기능 구현 완료
3. ✅ 모든 언어 버전(영/한/중/일) 지원 완료

## 다음 단계 (5분 소요)

### 1. Incoming Webhooks 활성화

1. **Slack API 페이지에서:**
   - 왼쪽 사이드바 → **"Features"** 섹션
   - **"Incoming Webhooks"** 클릭
   - **"Activate Incoming Webhooks"** 토글을 **ON**으로 변경

### 2. Webhook URL 생성

1. **"Add New Webhook to Workspace"** 버튼 클릭
2. 메시지를 받을 채널 선택 (채널 ID: `C0A8295NMED` 또는 채널 이름 선택)
3. **"Allow"** 클릭
4. 생성된 **Webhook URL 복사**
   - 형식: `https://hooks.slack.com/services/T00000000/B00000000/TOKEN`

### 3. Webhook URL 설정

**방법 1: 스크립트 사용 (권장)**
```bash
cd "/Volumes/choimacssd/너구리여행사 버스예약 서비스"
./scripts/update_slack_webhook.sh "https://hooks.slack.com/services/YOUR_WEBHOOK_URL"
```

**방법 2: 수동 설정**
1. `deploy_files/config.js` 파일 열기
2. 다음 줄을 찾기:
   ```javascript
   const SLACK_WEBHOOK_URL = 'YOUR_WEBHOOK_URL_HERE';
   ```
3. `YOUR_WEBHOOK_URL_HERE`를 실제 Webhook URL로 교체:
   ```javascript
   const SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/T00000000/B00000000/TOKEN';
   ```

### 4. 테스트

1. 웹사이트 열기 (`deploy_files/index_v2.html` 또는 `index_v2_ko.html`)
2. "Get a Quote" 또는 "견적 요청" 섹션으로 이동
3. 폼 작성 후 제출
4. Slack 채널에서 메시지 확인 ✅

## 문제 해결

### Webhook URL을 찾을 수 없어요
- Incoming Webhooks 페이지에서 "Webhook URLs" 섹션 확인
- 여러 개가 있다면 가장 최근에 생성한 것 사용

### 메시지가 전송되지 않아요
- 브라우저 콘솔 열기 (F12 → Console)
- 에러 메시지 확인
- Webhook URL이 올바른지 확인 (config.js 파일 확인)

### 권한 오류
- Slack App이 올바른 워크스페이스에 설치되어 있는지 확인
- 채널에 앱이 추가되어 있는지 확인

## 상세 가이드

더 자세한 내용은 다음 파일을 참고하세요:
- `docs/SLACK_WEBHOOK_SETUP.md` - 단계별 상세 가이드
- `docs/SLACK_SETUP.md` - 일반적인 Slack 설정 가이드
