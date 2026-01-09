#!/bin/bash
# Slack Webhook URL 업데이트 스크립트
# config.js 파일의 Slack Webhook URL을 쉽게 업데이트할 수 있도록 도와주는 스크립트
# 
# 사용법: ./update_slack_webhook.sh "https://hooks.slack.com/services/YOUR_WEBHOOK_URL"

# 명령줄 인자로 받은 Webhook URL
WEBHOOK_URL="$1"

# Webhook URL이 제공되지 않은 경우 오류 메시지 출력 및 종료
if [ -z "$WEBHOOK_URL" ]; then
    echo "❌ 오류: Webhook URL을 제공해주세요."
    echo "사용법: ./update_slack_webhook.sh \"https://hooks.slack.com/services/YOUR_WEBHOOK_URL\""
    exit 1
fi

# Webhook URL 형식 검증
# Slack Webhook URL은 https://hooks.slack.com/services/로 시작해야 함
if [[ ! "$WEBHOOK_URL" =~ ^https://hooks\.slack\.com/services/ ]]; then
    echo "⚠️  경고: Webhook URL 형식이 올바르지 않을 수 있습니다."
    echo "예상 형식: https://hooks.slack.com/services/T00000000/B00000000/TOKEN"
    read -p "계속하시겠습니까? (y/n): " -n 1 -r
    echo
    # 사용자가 'y' 또는 'Y'가 아닌 경우 스크립트 종료
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# config.js 파일 경로
CONFIG_FILE="deploy_files/config.js"

# 설정 파일 존재 여부 확인
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 오류: $CONFIG_FILE 파일을 찾을 수 없습니다."
    exit 1
fi

# Webhook URL 업데이트 (ES6 문자열 내 작은따옴표 이스케이프 처리)
ESCAPED_URL=$(echo "$WEBHOOK_URL" | sed "s/'/'\\\\''/g")

# 운영체제별 sed 명령어로 Webhook URL 업데이트
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS용 sed (빈 문자열을 백업 확장자로 사용)
    sed -i '' "s|const SLACK_WEBHOOK_URL = '.*';|const SLACK_WEBHOOK_URL = '$ESCAPED_URL';|g" "$CONFIG_FILE"
else
    # Linux용 sed
    sed -i "s|const SLACK_WEBHOOK_URL = '.*';|const SLACK_WEBHOOK_URL = '$ESCAPED_URL';|g" "$CONFIG_FILE"
fi

# 업데이트 확인: grep으로 변경된 URL이 파일에 있는지 확인
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
