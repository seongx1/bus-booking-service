# 도메인 연결 후 Slack 알림 설정 (PHP 프록시)

도메인 연결된 사이트(Cloudways 등)에서 **홈페이지 신청(견적 요청)** 폼 제출 시 슬랙으로 알림이 가도록 하려면, 서버에 Slack Webhook URL을 설정해야 합니다.

## 왜 필요한가요?

- 브라우저에서 Slack Webhook으로 **직접** 요청을 보내면 **CORS** 때문에 차단되거나 응답을 확인할 수 없어, 실제로는 슬랙에 도달하지 않을 수 있습니다.
- **같은 오리진**의 PHP 프록시(`/slack-webhook-proxy.php`)를 통해 보내면 CORS 없이 슬랙까지 전달됩니다.

## 배포 후 서버에서 할 일 (한 번만)

### 방법 A: .env / GitHub Secrets로 자동 처리 (권장)

- **로컬 배포:** `.env`에 `SLACK_WEBHOOK_URL`과 SFTP 계정을 넣고 `./scripts/deploy-to-cloudways.sh` 실행  
  → 빌드 시 `dist/slack_webhook_config.php`가 생성되고, SFTP로 서버에 함께 업로드됩니다.
- **GitHub Actions 배포:** 저장소 Secrets에 `SLACK_WEBHOOK_URL`을 추가해 두면, 워크플로가 `slack_webhook_config.php`를 만들어 SFTP 업로드에 포함합니다.

위처럼 하면 **서버에서 별도로 PHP 파일을 만들 필요 없습니다.**

### 방법 B: 서버에서 수동 생성

1. **서버의 `public_html`(또는 배포 루트)에** 다음 파일이 있는지 확인합니다.
   - `slack-webhook-proxy.php` … 빌드 시 `dist/`에 포함되어 배포됨.
   - `slack_webhook_config.php.example` … 예시 파일.

2. **Webhook URL 설정**
   - `slack_webhook_config.php.example` 를 **`slack_webhook_config.php`** 로 복사한 뒤,  
     파일 내용을 아래처럼 **실제 Slack Webhook URL** 한 줄만 넣어 수정합니다.
     ```php
     <?php
     return 'https://hooks.slack.com/services/YOUR_WORKSPACE/YOUR_CHANNEL/YOUR_TOKEN';
     ```
   - Cloudways 등에서 **환경 변수** `SLACK_WEBHOOK_URL` 로 설정해도 됩니다. (PHP `getenv('SLACK_WEBHOOK_URL')` 로 읽음)

3. **보안**
   - `slack_webhook_config.php` 는 **절대 Git에 올리지 마세요.** (이미 `.gitignore`에 포함됨)
   - Webhook URL이 노출되지 않도록 서버에서만 생성·관리하세요.

## Webhook URL 확인

- [Slack API – Incoming Webhooks](https://api.slack.com/messaging/webhooks) 에서 앱/채널별 Webhook URL을 확인·재발급할 수 있습니다.
- `docs/WEBHOOK_CHECK.md` 에 이전에 “no_service” 등으로 실패했던 내용이 있으면, **새 Webhook URL**을 발급해 `slack_webhook_config.php`(또는 환경 변수)에 반영하세요.

## 동작 확인

1. 도메인 연결된 사이트에서 **견적 요청(홈페이지 신청)** 폼을 제출합니다.
2. 폼 제출 시 브라우저는 **같은 도메인**의 `/slack-webhook-proxy.php` 로 POST합니다.
3. 서버의 PHP가 Slack Webhook URL로 전달하고, 슬랙 채널에 메시지가 도착하는지 확인합니다.

문제가 있으면 브라우저 개발자 도구(F12) → Network 탭에서 `slack-webhook-proxy.php` 요청의 상태 코드와 응답 본문을 확인하세요.

---

## 도메인 연결 후 슬랙 메시지가 안 갈 때 (복구)

**증상:** 임시 도메인(예: `phpstack-1574100-6221145.cloudwaysapps.com`)에서는 슬랙 알림이 잘 갔는데, **커스텀 도메인(예: koreabuscharter.com) 연결 후** 견적 요청 시 슬랙으로 메시지가 안 가고, 콘솔에 "Slack Webhook URL이 정상적으로 설정되지 않았습니다" / "Slack Webhook URL이 되지 않습니다" 가 뜹니다.

**원인:** 해당 도메인이 바라보는 **앱의 public_html**에 `slack_webhook_config.php`가 없거나, 도메인을 **다른 앱**에 연결해 두었을 수 있습니다. (Primary/Alias는 같은 앱이면 같은 폴더를 쓰므로, 설정 파일만 있으면 됩니다.)

아래 중 하나로 복구하세요.

### 1) 한 번에 복구 (권장)

1. 프로젝트 루트에 `.env` 파일이 있다고 가정하고, 다음을 설정합니다.
   - **SLACK_WEBHOOK_URL**  
     Slack 앱 → [Incoming Webhooks](https://api.slack.com/messaging/webhooks) 에서 URL 복사  
     예: `https://hooks.slack.com/services/Txxxx/Bxxxx/xxxx`
   - **Cloudways SFTP** (Master Credentials 사용)
     - `CLOUDWAYS_SFTP_USER` = Cloudways **Master Credentials** 의 **Username** (예: `master_nfipsjngpg`)
     - `CLOUDWAYS_SFTP_PASSWORD` = Master Credentials 의 **Password**
     - `CLOUDWAYS_SFTP_HOST` = **Public IP** (예: `68.183.180.33`)  
       비워 두면 `CLOUDWAYS_EMAIL` + `CLOUDWAYS_API_KEY` + `CLOUDWAYS_SERVER_ID` 로 API 조회
     - `CLOUDWAYS_SFTP_REMOTE_PATH` = **슬랙이 안 되는 도메인이 연결된 앱**의 public_html  
     - koreabuscharter.com이 "Korea bus charter" 앱에 연결돼 있다면: `applications/tjjsevvqfe/public_html`  
     - Cloudways 대시보드 → 애플리케이션 → **도메인 관리**에서 해당 도메인이 붙어 있는 앱을 확인한 뒤, 그 앱의 시스템 경로를 사용하세요.

2. 복구 스크립트 실행:
   ```bash
   ./scripts/restore-slack-on-cloudways.sh
   ```
   - `slack-webhook-proxy.php`와 `slack_webhook_config.php`만 서버에 업로드됩니다.
   - 전체 사이트를 다시 배포하지 않아도 됩니다.

3. 사이트에서 견적 요청 폼을 한 번 제출해 보고, 슬랙 채널에 메시지가 오는지 확인합니다.

### 2) 전체 배포로 복구

`.env`에 `SLACK_WEBHOOK_URL`과 SFTP 설정이 이미 있다면, 전체 배포를 다시 실행해도 됩니다.

```bash
./scripts/deploy-to-cloudways.sh
```

이때 빌드 결과물과 함께 `slack_webhook_config.php`가 생성·업로드됩니다.

### 3) 서버에서 수동으로 설정 파일만 만들기

Cloudways **Launch SSH Terminal**로 접속한 뒤, `public_html`(또는 실제 웹 루트)로 이동해서:

```bash
cd applications/tjjsevvqfe/public_html   # 실제 앱 경로로 변경
echo '<?php return '"'"'https://hooks.slack.com/services/YOUR_WORKSPACE/YOUR_CHANNEL/YOUR_TOKEN'"'"';' > slack_webhook_config.php
```

`https://hooks.slack.com/...` 부분을 실제 Slack Incoming Webhook URL로 바꾼 뒤 저장합니다.  
`slack-webhook-proxy.php`는 이미 배포되어 있어야 합니다. 없으면 빌드 결과의 `dist/slack-webhook-proxy.php`를 업로드하세요.
