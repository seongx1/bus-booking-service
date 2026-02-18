#!/bin/bash
# Cloudways 빌드 + SFTP 업로드 (한 번에 배포)
# .env에 CLOUDWAYS_SFTP_* 설정 시 자동 업로드, 없으면 빌드만 하고 업로드 방법 안내

set -e
cd "$(dirname "$0")/.." || exit 1

# .env 로드 (있으면)
if [ -f .env ]; then
  set -a
  # shellcheck source=/dev/null
  source .env
  set +a
fi

echo "🚀 Cloudways 배포 시작..."
./scripts/deploy-cloudways.sh

# SFTP 호스트 없으면 API로 서버 IP 조회 (CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY, CLOUDWAYS_SERVER_ID 사용)
SFTP_HOST="$CLOUDWAYS_SFTP_HOST"
if [ -z "$SFTP_HOST" ] && [ -n "$CLOUDWAYS_EMAIL" ] && [ -n "$CLOUDWAYS_API_KEY" ]; then
  SERVER_ID="${CLOUDWAYS_SERVER_ID:-1574100}"
  echo ""
  echo "🔑 API로 서버 $SERVER_ID 공용 IP 조회 중..."
  SFTP_HOST=$("./scripts/cloudways-api.sh" server-ip "$SERVER_ID" 2>/dev/null) || true
fi

# SFTP 자동 업로드 (호스트·사용자·비밀번호가 있으면)
if [ -n "$SFTP_HOST" ] && [ -n "$CLOUDWAYS_SFTP_USER" ] && [ -n "$CLOUDWAYS_SFTP_PASSWORD" ]; then
  REMOTE="${CLOUDWAYS_SFTP_REMOTE_PATH:-applications/tjjsevvqfe/public_html}"
  echo ""
  echo "📤 SFTP 업로드 중... ($SFTP_HOST, 경로: $REMOTE)"
  PYTHON="python3"
  if [ -d ".venv_deploy" ]; then
    PYTHON=".venv_deploy/bin/python3"
  fi
  if ! $PYTHON -c "import paramiko" 2>/dev/null; then
    echo "⚠️  paramiko 미설치. .venv_deploy/bin/pip install paramiko 후 다시 실행하세요."
    exit 1
  fi
  $PYTHON scripts/upload_sftp.py "$SFTP_HOST" "$CLOUDWAYS_SFTP_USER" "$CLOUDWAYS_SFTP_PASSWORD" dist "$REMOTE"
  echo ""
  echo "✅ Cloudways 배포 완료."
else
  echo ""
  echo "📤 SFTP 자동 업로드를 하려면 프로젝트 루트에 .env 파일을 만들고 다음 변수를 설정하세요:"
  echo "   # API 키만 있어도 서버 IP는 자동 조회 (서버 ID 1574100 기준)"
  echo "   CLOUDWAYS_EMAIL=your@email.com"
  echo "   CLOUDWAYS_API_KEY=발급한_API_키"
  echo "   CLOUDWAYS_SFTP_USER=마스터계정사용자명"
  echo "   CLOUDWAYS_SFTP_PASSWORD=마스터계정비밀번호"
  echo "   # 선택: CLOUDWAYS_SFTP_HOST=서버IP (비우면 API로 조회), CLOUDWAYS_SERVER_ID=1574100"
  echo ""
  echo "   예: cp .env.example .env  후 .env 편집"
  echo ""
  echo "또는 수동 업로드: dist/ 폴더 내용을 SFTP로 서버 /public_html/ 에 업로드하세요."
fi
