// Slack Webhook 설정
// SLACK_SETUP.md 파일의 가이드를 따라 Webhook URL을 생성한 후 아래에 입력하세요
const SLACK_WEBHOOK_URL = 'YOUR_WEBHOOK_URL_HERE';

// Webhook URL이 설정되지 않은 경우 경고
if (SLACK_WEBHOOK_URL === 'YOUR_WEBHOOK_URL_HERE' || !SLACK_WEBHOOK_URL) {
    console.warn('⚠️ Slack Webhook URL이 설정되지 않았습니다. SLACK_SETUP.md 파일을 참고하여 설정해주세요.');
}

