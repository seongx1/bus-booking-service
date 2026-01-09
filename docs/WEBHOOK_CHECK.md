# ⚠️ 중요: Slack Webhook URL 문제 발견

## 문제
curl 테스트 결과 "no_service" 응답이 반환되었습니다. 이는 Webhook URL이 유효하지 않거나 비활성화되었을 수 있습니다.

## 해결 방법

### 1. Slack에서 Webhook URL 다시 확인

1. https://api.slack.com/apps 접속
2. 앱 선택 (App ID: A0A7L1XG093)
3. 왼쪽 메뉴에서 **"Incoming Webhooks"** 클릭
4. Webhook URL 목록 확인
5. 활성화된 Webhook URL 복사

### 2. Webhook URL 테스트

터미널에서 다음 명령어로 테스트:

```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"테스트 메시지"}' \
  YOUR_WEBHOOK_URL_HERE
```

**성공 응답**: `ok` 또는 빈 응답
**실패 응답**: `no_service`, `invalid_payload` 등

### 3. Webhook URL 업데이트

새로운 Webhook URL을 받으시면:

```bash
cd "/Volumes/choimacssd/너구리여행사 버스예약 서비스"
./scripts/update_slack_webhook.sh "새로운_WEBHOOK_URL"
```

또는 HTML 파일에서 직접 수정:
- `deploy_files/index_v2.html` (317번째 줄 근처)
- `index_v2.html`
- `public/index_v2.html`

### 4. 현재 Webhook URL
```
https://hooks.slack.com/services/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
```

이 URL이 "no_service"를 반환하므로, Slack에서 새로운 Webhook URL을 생성해야 합니다.

## 참고

- Webhook이 비활성화되었을 수 있습니다
- Webhook이 삭제되었을 수 있습니다
- Webhook URL이 만료되었을 수 있습니다
- 채널 권한이 변경되었을 수 있습니다

**새로운 Webhook URL을 받으시면 알려주세요. 바로 업데이트하겠습니다.**
