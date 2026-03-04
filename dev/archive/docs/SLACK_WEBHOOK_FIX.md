# Slack Webhook URL 문제 해결

## 현재 문제
Slack Webhook URL이 `no_service` 응답을 반환하고 있습니다. 이는 다음 중 하나를 의미합니다:

1. Webhook이 삭제되었거나 비활성화됨
2. Webhook URL이 잘못됨
3. Slack 앱 설정에 문제가 있음

## 해결 방법

### 1. Slack에서 Webhook URL 확인 및 재생성

1. **Slack 워크스페이스 접속**
   - https://w1767923673-ijw668832.slack.com 접속

2. **Incoming Webhooks 앱 확인**
   - 왼쪽 사이드바에서 "앱" 클릭
   - "Incoming Webhooks" 검색 및 클릭

3. **기존 Webhook 확인**
   - "Webhook URL" 섹션에서 기존 URL 확인
   - 채널: `#홈페이지-문의-내역` (C0A8295NMED)

4. **새로운 Webhook URL 생성 (필요한 경우)**
   - "새로운 Webhook 추가" 클릭
   - 채널 선택: `#홈페이지-문의-내역`
   - "Webhook URL 생성" 클릭

5. **Webhook URL 복사**
   - 형식: `https://hooks.slack.com/services/T.../B.../...`
   - 전체 URL을 복사

### 2. Webhook URL 업데이트

#### 방법 1: HTML 파일 직접 수정
```bash
# index_v2.html 파일 열기
# SLACK_WEBHOOK_URL 값 찾아서 새 URL로 교체
```

#### 방법 2: 프록시 서버 설정 수정
```bash
# scripts/slack_proxy.py 파일 열기
# 14번째 줄의 SLACK_WEBHOOK_URL 값을 새 URL로 교체
```

### 3. Webhook URL 테스트

터미널에서 테스트:

```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"테스트 메시지"}' \
  https://hooks.slack.com/services/YOUR/NEW/WEBHOOK_URL
```

**성공 응답**: `ok`  
**실패 응답**: `no_service` 또는 에러 메시지

### 4. 프록시 서버 재시작

Webhook URL을 업데이트한 후 프록시 서버를 재시작:

```bash
# 기존 프로세스 종료
pkill -f slack_proxy.py

# 새로 시작
./scripts/start_proxy.sh
```

### 5. 웹사이트 테스트

1. 프록시 서버 실행 확인
2. 웹사이트 실행 (`python3 -m http.server 8000`)
3. 브라우저에서 `http://localhost:8000/index_v2.html` 접속
4. "Get a Quote" 폼 작성 및 제출
5. Slack 채널에서 메시지 확인

## 참고사항

- Webhook URL은 **절대 공개 저장소에 커밋하지 마세요**
- GitHub Push Protection이 감지할 수 있으므로 주의
- `.gitignore`에 Webhook URL이 포함된 파일이 있는지 확인

## 문제가 계속되는 경우

1. Slack 앱 권한 확인
2. 채널 존재 여부 확인
3. 워크스페이스 관리자에게 문의
