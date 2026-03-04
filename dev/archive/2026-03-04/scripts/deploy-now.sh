#!/bin/bash
# 배포 한 번에 실행 (처음 한 번만 .env 값 채우고 이 스크립트 다시 실행하면 배포됨)
set -e
cd "$(dirname "$0")/.." || exit 1

if [ ! -f .env ]; then
  cp .env.example .env
  echo "📌 .env 파일을 생성했습니다. 아래 변수만 채워 저장한 뒤, 이 스크립트를 다시 실행하세요:"
  echo "   CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY"
  echo "   CLOUDWAYS_SFTP_USER, CLOUDWAYS_SFTP_PASSWORD"
  echo "   SLACK_WEBHOOK_URL (Slack 알림용)"
  echo ""
  if [ -n "$EDITOR" ]; then
    $EDITOR .env
  else
    open -e .env 2>/dev/null || true
  fi
  exit 0
fi

# .env 로드
set -a
# shellcheck source=/dev/null
source .env
set +a

# 필수 값 확인
if [ -z "$CLOUDWAYS_SFTP_USER" ] || [ -z "$CLOUDWAYS_SFTP_PASSWORD" ]; then
  echo "⚠️  .env에 CLOUDWAYS_SFTP_USER, CLOUDWAYS_SFTP_PASSWORD 를 채운 뒤 다시 실행하세요."
  echo "   open -e .env"
  exit 1
fi

./scripts/deploy-to-cloudways.sh
