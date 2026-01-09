// Vercel Serverless Function for Slack Webhook Proxy
// This file should be deployed to Vercel or similar serverless platform
// Path: /api/slack-proxy.js (for Vercel)

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { name, phone, email, message } = req.body;

  // Webhook URL은 환경 변수에서 가져오기 (Vercel 환경 변수 설정 필요)
  const webhookUrl = process.env.SLACK_WEBHOOK_URL || 'YOUR_WEBHOOK_URL_HERE';

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

  try {
    const response = await fetch(webhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(slackMessage)
    });

    if (response.ok) {
      return res.status(200).json({ success: true, message: 'Message sent to Slack successfully' });
    } else {
      const errorText = await response.text();
      console.error('Slack API error:', response.status, errorText);
      return res.status(response.status).json({ 
        success: false, 
        error: `Slack API returned status ${response.status}`,
        details: errorText
      });
    }
  } catch (error) {
    console.error('Error sending to Slack:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Failed to send message to Slack',
      details: error.message 
    });
  }
}
