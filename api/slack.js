// Vercel Serverless Function to proxy Slack webhook requests
// This bypasses CORS restrictions by making the request from the server

export default async function handler(req, res) {
  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Get webhook URL from environment variable or use default
  const webhookUrl = process.env.SLACK_WEBHOOK_URL || 'https://hooks.slack.com/services/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';

  try {
    // Forward the request to Slack
    const response = await fetch(webhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(req.body),
    });

    const responseText = await response.text();

    if (response.ok) {
      return res.status(200).json({ success: true, message: 'Message sent to Slack' });
    } else {
      console.error('Slack API error:', response.status, responseText);
      return res.status(response.status).json({ error: 'Slack API error', details: responseText });
    }
  } catch (error) {
    console.error('Error forwarding to Slack:', error);
    return res.status(500).json({ error: 'Failed to send message to Slack', details: error.message });
  }
}
