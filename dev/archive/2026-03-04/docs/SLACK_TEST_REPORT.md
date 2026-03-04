# Slack 연동 테스트 보고 (최종)

**테스트 일시:** 2025-03-04  
**대상:** https://koreabuscharter.com/slack-webhook-proxy.php

---

## 1. 테스트 방법

프로덕션 프록시에 POST로 테스트 메시지 전송 후 응답 확인:

```bash
curl -s -X POST "https://koreabuscharter.com/slack-webhook-proxy.php" \
  -H "Content-Type: application/json" \
  -d '{"text":"[배포 테스트] 슬랙 연동 확인","blocks":[{"type":"section","text":{"type":"mrkdwn","text":"*배포 검증 테스트*"}}]}'
```

---

## 2. 결과 요약

| 구간 | 상태 | 비고 |
|------|------|------|
| 사이트 → 프록시 | ✅ 정상 | 프록시가 요청 수신·처리함 |
| 프록시 → Slack API | ⚠️ Slack 측 오류 | Slack이 `no_service` 반환 |

- **HTTP 502** + 본문: `{"success":false,"error":"Slack returned error","details":"no_service",...}`
- 즉, **우리 쪽 코드/배포는 정상**이고, **Slack이 현재 웹훅 URL을 더 이상 인정하지 않는 상태**입니다.

---

## 3. `no_service` 의미 및 조치

- **의미:** 해당 Incoming Webhook URL이 **만료되었거나 폐지**된 상태입니다.  
  (앱 삭제, 채널/앱 연동 해제, URL 유출로 Slack이 폐지 등)
- **조치:** **새 Incoming Webhook URL**을 발급해 교체해야 합니다.

### 할 일 (한 번만)

1. [Slack API – Incoming Webhooks](https://api.slack.com/messaging/webhooks) 또는  
   워크스페이스 **앱 관리** → 사용 중인 앱 → **Incoming Webhooks** 이동
2. **새 Webhook URL 추가** (또는 기존 채널용 새 URL 생성)
3. 발급된 URL을 복사한 뒤:
   - **로컬:** `.env`의 `SLACK_WEBHOOK_URL=` 에 새 URL 넣고 저장
   - **서버 반영:**  
     `./scripts/restore-slack-on-cloudways.sh` 실행  
     (또는 `./scripts/deploy-to-cloudways.sh` 로 전체 배포)
4. 같은 `curl` 명령으로 다시 테스트 → `{"success":true,"message":"Message sent to Slack"}` 및 **HTTP 200** 확인
5. 해당 Slack 채널에 테스트 메시지가 도착하는지 확인

---

## 4. 결론

- **koreabuscharter.com → slack-webhook-proxy.php → Slack** 경로는 **정상 동작**합니다.
- 현재 사용 중인 **Slack 웹훅 URL만 만료/폐지**된 상태이므로, **위 3번대로 새 URL로 교체**하면 슬랙으로 메시지가 정상 수신됩니다.
