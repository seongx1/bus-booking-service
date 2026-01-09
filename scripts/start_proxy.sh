#!/bin/bash
# Slack Webhook 프록시 서버 실행 스크립트 (로컬 개발용)
# CORS 문제를 해결하기 위한 로컬 프록시 서버를 실행합니다.
# 브라우저에서 직접 Slack API를 호출할 수 없기 때문에 이 프록시를 통해 요청을 중계합니다.

# 스크립트가 있는 디렉토리의 상위(프로젝트 루트)로 이동
cd "$(dirname "$0")/.." || exit 1

# 포트 번호 설정 (명령줄 인자가 없으면 기본값 8888 사용)
PORT=${1:-8888}

echo "🚀 Starting Slack Webhook Proxy Server on port $PORT..."
echo "📍 Proxy endpoint: http://localhost:$PORT/slack-webhook"
echo "🔗 Target: https://hooks.slack.com/services/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"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Python 프록시 서버 실행
python3 scripts/slack_proxy.py "$PORT"
