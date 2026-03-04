<?php
/**
 * Slack Webhook 프록시 (Cloudways 등 PHP 호스팅용)
 *
 * 브라우저 → 이 스크립트(same-origin) → Slack
 * CORS 없이 슬랙 알림이 도메인 연결 후에도 동작하도록 합니다.
 *
 * 설정:
 * 1) 환경 변수: Cloudways 등에서 SLACK_WEBHOOK_URL 설정
 * 2) 또는 이 디렉터리에 slack_webhook_config.php 생성 후 return 'https://hooks.slack.com/...';
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: ' . (isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*'));
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

// Webhook URL: 환경 변수 > 설정 파일
$webhookUrl = getenv('SLACK_WEBHOOK_URL');
if (!$webhookUrl || $webhookUrl === 'YOUR_WEBHOOK_URL_HERE') {
    $configFile = __DIR__ . '/slack_webhook_config.php';
    if (file_exists($configFile)) {
        $webhookUrl = include $configFile;
    }
}
if (!$webhookUrl || $webhookUrl === 'YOUR_WEBHOOK_URL_HERE') {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Slack Webhook URL not configured',
        'hint' => 'Set SLACK_WEBHOOK_URL env or create public/slack_webhook_config.php'
    ]);
    exit;
}

$raw = file_get_contents('php://input');
$payload = json_decode($raw, true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Invalid JSON']);
    exit;
}

$ch = curl_init($webhookUrl);
curl_setopt_array($ch, [
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $raw,
    CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 10,
]);
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlErr = curl_error($ch);
curl_close($ch);

if ($curlErr) {
    http_response_code(502);
    echo json_encode(['success' => false, 'error' => 'Proxy request failed', 'details' => $curlErr]);
    exit;
}

// Slack returns 200 and body "ok" on success
if ($httpCode === 200 && trim($response) === 'ok') {
    echo json_encode(['success' => true, 'message' => 'Message sent to Slack']);
    exit;
}

// Slack returned error (e.g. no_service, invalid_payload)
http_response_code(502);
echo json_encode([
    'success' => false,
    'error' => 'Slack returned error',
    'details' => trim($response),
    'hint' => 'Check Slack Incoming Webhook URL and app status'
]);
exit;
