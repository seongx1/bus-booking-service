#!/bin/bash
# 도메인 연결 후 슬랙 메시지가 안 갈 때 복구 스크립트
# .env에 SLACK_WEBHOOK_URL + Cloudways SFTP(또는 API) 설정 후 실행하면
# slack-webhook-proxy.php 와 slack_webhook_config.php 만 서버에 올려 슬랙 알림을 복구합니다.

set -e
cd "$(dirname "$0")/.." || exit 1

if [ -f .env ]; then
  set -a
  # shellcheck source=/dev/null
  source .env
  set +a
fi

if [ -z "$SLACK_WEBHOOK_URL" ] || [ "$SLACK_WEBHOOK_URL" = "YOUR_WEBHOOK_URL_HERE" ]; then
  echo "❌ .env에 SLACK_WEBHOOK_URL을 설정해주세요."
  echo "   예: SLACK_WEBHOOK_URL=https://hooks.slack.com/services/Txxxx/Bxxxx/xxxx"
  echo "   Slack 앱 → Incoming Webhooks 에서 URL 복사"
  exit 1
fi

# 슬랙 설정 파일 내용 생성 (따옴표 이스케이프)
SAFE_URL=$(echo "$SLACK_WEBHOOK_URL" | sed "s/'/\\\\'/g")

RESTORE_DIR=$(mktemp -d)
trap 'rm -rf "$RESTORE_DIR"' EXIT

cp public/slack-webhook-proxy.php "$RESTORE_DIR/"
echo "<?php return '${SAFE_URL}';" > "$RESTORE_DIR/slack_webhook_config.php"
echo "🔧 슬랙 복구용 파일 준비됨 (proxy + config)"

# SFTP 호스트 없으면 API로 조회
SFTP_HOST="$CLOUDWAYS_SFTP_HOST"
if [ -z "$SFTP_HOST" ] && [ -n "$CLOUDWAYS_EMAIL" ] && [ -n "$CLOUDWAYS_API_KEY" ]; then
  SERVER_ID="${CLOUDWAYS_SERVER_ID:-1574100}"
  echo "🔑 API로 서버 $SERVER_ID 공용 IP 조회 중..."
  SFTP_HOST=$("./scripts/cloudways-api.sh" server-ip "$SERVER_ID" 2>/dev/null) || true
fi

if [ -z "$SFTP_HOST" ] || [ -z "$CLOUDWAYS_SFTP_USER" ] || [ -z "$CLOUDWAYS_SFTP_PASSWORD" ]; then
  echo ""
  echo "⚠️  SFTP 자동 업로드를 위해 .env에 다음을 설정한 뒤 다시 실행하세요:"
  echo "   CLOUDWAYS_SFTP_USER=마스터사용자명   # Cloudways Master Credentials 의 Username"
  echo "   CLOUDWAYS_SFTP_PASSWORD=마스터비밀번호"
  echo "   CLOUDWAYS_SFTP_HOST=68.183.180.33   # 또는 비우면 CLOUDWAYS_API_KEY로 조회"
  echo "   CLOUDWAYS_SFTP_REMOTE_PATH=applications/tjjsevvqfe/public_html"
  echo ""
  echo "수동 복구: 아래 두 파일을 서버 public_html 에 업로드하세요."
  echo "  - $RESTORE_DIR/slack-webhook-proxy.php"
  echo "  - $RESTORE_DIR/slack_webhook_config.php"
  exit 1
fi

REMOTE="${CLOUDWAYS_SFTP_REMOTE_PATH:-applications/tjjsevvqfe/public_html}"
echo "📤 서버에 슬랙 설정 업로드 중... ($SFTP_HOST → $REMOTE)"

PYTHON="python3"
if [ -d ".venv_deploy" ]; then
  PYTHON=".venv_deploy/bin/python3"
fi
if ! $PYTHON -c "import paramiko" 2>/dev/null; then
  echo "⚠️  paramiko 미설치. pip install paramiko 또는 .venv_deploy 사용"
  exit 1
fi

$PYTHON scripts/upload_sftp.py "$SFTP_HOST" "$CLOUDWAYS_SFTP_USER" "$CLOUDWAYS_SFTP_PASSWORD" "$RESTORE_DIR" "$REMOTE"
echo ""
echo "✅ 슬랙 복구 완료. 견적 요청 폼 제출 후 슬랙 알림이 오는지 확인해보세요."
