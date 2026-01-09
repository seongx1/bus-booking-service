/**
 * Vercel Serverless Function - Slack Webhook 프록시
 * CORS 제한을 우회하기 위해 서버에서 요청을 전달합니다.
 * 브라우저에서 직접 Slack API를 호출할 수 없기 때문에 서버를 통해 프록시합니다.
 * 
 * @param {Object} req - 요청 객체
 * @param {Object} res - 응답 객체
 */
export default async function handler(req, res) {
  // POST 요청만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // 환경 변수에서 Webhook URL 가져오기 (없으면 기본값 사용)
  const webhookUrl = process.env.SLACK_WEBHOOK_URL || 'https://hooks.slack.com/services/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';

  try {
    // Slack으로 요청 전달
    const response = await fetch(webhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(req.body),
    });

    const responseText = await response.text();

    // 성공 응답 처리
    if (response.ok) {
      return res.status(200).json({ success: true, message: 'Message sent to Slack' });
    } else {
      // Slack API 오류 처리
      console.error('Slack API error:', response.status, responseText);
      return res.status(response.status).json({ error: 'Slack API error', details: responseText });
    }
  } catch (error) {
    // 네트워크 오류 등 예외 처리
    console.error('Error forwarding to Slack:', error);
    return res.status(500).json({ error: 'Failed to send message to Slack', details: error.message });
  }
}
