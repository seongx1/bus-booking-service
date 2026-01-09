#!/bin/bash

# Slack Webhook URL 업데이트 스크립트
# 사용법: ./update_slack_webhook.sh "https://hooks.slack.com/services/YOUR_WEBHOOK_URL"

WEBHOOK_URL="$1"

if [ -z "$WEBHOOK_URL" ]; then
    echo "❌ 오류: Webhook URL을 제공해주세요."
    echo "사용법: ./update_slack_webhook.sh \"https://hooks.slack.com/services/YOUR_WEBHOOK_URL\""
    exit 1
fi

# Webhook URL 형식 검증
if [[ ! "$WEBHOOK_URL" =~ ^https://hooks\.slack\.com/services/ ]]; then
    echo "⚠️  경고: Webhook URL 형식이 올바르지 않을 수 있습니다."
    echo "예상 형식: https://hooks.slack.com/services/T00000000/B00000000/TOKEN"
    read -p "계속하시겠습니까? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# config.js 파일 경로
CONFIG_FILE="deploy_files/config.js"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 오류: $CONFIG_FILE 파일을 찾을 수 없습니다."
    exit 1
fi

# Webhook URL 업데이트 (ES6 이스케이프 처리)
ESCAPED_URL=$(echo "$WEBHOOK_URL" | sed "s/'/'\\\\''/g")

# sed를 사용하여 Webhook URL 업데이트
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|const SLACK_WEBHOOK_URL = '.*';|const SLACK_WEBHOOK_URL = '$ESCAPED_URL';|g" "$CONFIG_FILE"
else
    # Linux
    sed -i "s|const SLACK_WEBHOOK_URL = '.*';|const SLACK_WEBHOOK_URL = '$ESCAPED_URL';|g" "$CONFIG_FILE"
fi

# 업데이트 확인
if grep -q "$WEBHOOK_URL" "$CONFIG_FILE"; then
    echo "✅ 성공: $CONFIG_FILE 파일에 Webhook URL이 업데이트되었습니다."
    echo ""
    echo "업데이트된 내용:"
    grep "const SLACK_WEBHOOK_URL" "$CONFIG_FILE"
    echo ""
    echo "다음 단계: 웹사이트를 열고 'Get a Quote' 폼을 테스트해보세요!"
else
    echo "❌ 오류: Webhook URL 업데이트에 실패했습니다."
    exit 1
fi
