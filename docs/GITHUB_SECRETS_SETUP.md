# 🔐 GitHub Secrets 설정 가이드

GitHub Pages 배포 시 Slack Webhook URL을 안전하게 설정하는 방법입니다.

## 📋 GitHub Secrets 설정 방법

### 1단계: GitHub 저장소 접속

1. 저장소 페이지 접속: `https://github.com/seongx1/bus-booking-service`
2. **Settings** 탭 클릭
3. 왼쪽 메뉴에서 **Secrets and variables** → **Actions** 클릭

### 2단계: New repository secret 추가

1. **"New repository secret"** 버튼 클릭
2. 다음 정보 입력:
   - **Name**: `SLACK_WEBHOOK_URL`
   - **Secret**: 실제 Slack Webhook URL 입력
     ```
     형식: https://hooks.slack.com/services/T[TEAM]/B[CHANNEL]/[TOKEN]
     (실제 Webhook URL을 Slack에서 복사하여 붙여넣으세요)
     ```
3. **"Add secret"** 버튼 클릭

### 3단계: 배포 확인

Secrets를 설정한 후:

1. **Actions** 탭으로 이동
2. **"Deploy to GitHub Pages"** 워크플로우를 수동 실행:
   - **"Run workflow"** 버튼 클릭
   - **"Run workflow"** 확인

또는 새로운 커밋을 푸시하면 자동으로 배포됩니다.

---

## 🎯 Slack Webhook URL 생성 방법

### 방법 1: Slack 워크스페이스에서 생성

1. [Slack API](https://api.slack.com/apps) 접속
2. **"Create New App"** 클릭
3. **"From scratch"** 선택
4. App 이름과 워크스페이스 선택
5. **Incoming Webhooks** 활성화
6. **"Add New Webhook to Workspace"** 클릭
7. 채널 선택 후 Webhook URL 복사

### 방법 2: 기존 Webhook URL 확인

이미 생성한 Webhook URL이 있다면:
- Slack 앱 설정 → Incoming Webhooks에서 확인
- 또는 기존 설정 파일에서 확인

---

## ✅ 설정 확인

### Secrets 설정 확인

1. GitHub 저장소 → Settings → Secrets and variables → Actions
2. `SLACK_WEBHOOK_URL`이 목록에 표시되는지 확인

### 배포 후 확인

1. 웹사이트 접속: `https://seongx1.github.io/bus-booking-service/`
2. 개발자 도구 콘솔 열기 (F12)
3. 에러 메시지가 사라졌는지 확인
4. 견적 요청 폼 테스트

---

## 🔄 Secrets 업데이트

Webhook URL을 변경하려면:

1. GitHub 저장소 → Settings → Secrets and variables → Actions
2. `SLACK_WEBHOOK_URL` 옆의 **연필 아이콘** 클릭
3. 새로운 URL 입력
4. **"Update secret"** 클릭
5. 재배포 (Actions → Deploy to GitHub Pages → Run workflow)

---

## ⚠️ 보안 주의사항

- ✅ **절대** Webhook URL을 코드에 직접 입력하지 마세요
- ✅ GitHub Secrets를 통해서만 관리
- ✅ Webhook URL이 노출되면 즉시 재생성하세요
- ✅ Private 저장소에서도 Secrets 사용 권장

---

## 🆘 문제 해결

### Secrets가 적용되지 않는 경우

1. **Secrets 이름 확인**: 정확히 `SLACK_WEBHOOK_URL`인지 확인
2. **워크플로우 재실행**: Actions → Deploy to GitHub Pages → Run workflow
3. **Webhook URL 형식 확인**: `https://hooks.slack.com/services/...` 형식인지 확인

### 여전히 에러가 표시되는 경우

1. 브라우저 캐시 삭제 (Ctrl+Shift+R)
2. 배포 완료 확인 (Actions 탭)
3. 개발자 도구 콘솔에서 실제 URL 값 확인:
   ```javascript
   console.log(window.SLACK_WEBHOOK_URL);
   ```

---

**✅ 설정 완료 후 재배포하면 정상 작동합니다!**