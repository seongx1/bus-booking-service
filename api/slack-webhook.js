// GitHub Pages용 서버리스 함수 (실제로는 GitHub Actions를 통한 별도 엔드포인트 필요)
// 또는 Vercel/Netlify Functions 사용 권장

// 현재는 브라우저에서 직접 호출하는 방식이지만, CORS 문제로 작동하지 않을 수 있음
// 실제 작동을 위해서는 서버 사이드 프록시가 필요합니다

export default async function handler(req, res) {
  // 서버 사이드에서 Slack으로 전송
  const { name, phone, email, message } = req.body;
  
  const slackMessage = {
    text: `📋 새로운 버스 예약 문의`,
    blocks: [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: '📋 새로운 버스 예약 문의'
        }
      },
      {
        type: 'section',
        fields: [
          {
            type: 'mrkdwn',
            text: `*이름:*\n${name || 'N/A'}`
          },
          {
            type: 'mrkdwn',
            text: `*연락처:*\n${phone || 'N/A'}`
          },
          {
            type: 'mrkdwn',
            text: `*이메일:*\n${email || 'N/A'}`
          },
          {
            type: 'mrkdwn',
            text: `*제출 시간:*\n${new Date().toLocaleString('ko-KR', { timeZone: 'Asia/Seoul' })}`
          }
        ]
      },
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: `*문의 내용:*\n\`\`\`${message || 'N/A'}\`\`\``
        }
      },
      {
        type: 'divider'
      },
      {
        type: 'context',
        elements: [
          {
            type: 'mrkdwn',
            text: `📧 Reply to: <mailto:${email}|${email}>`
          }
        ]
      }
    ]
  };

  const webhookUrl = process.env.SLACK_WEBHOOK_URL || 'YOUR_WEBHOOK_URL_HERE';

  try {
    const response = await fetch(webhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(slackMessage)
    });

    if (response.ok) {
      return res.status(200).json({ success: true, message: 'Message sent to Slack' });
    } else {
      return res.status(response.status).json({ success: false, error: 'Failed to send to Slack' });
    }
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
}
