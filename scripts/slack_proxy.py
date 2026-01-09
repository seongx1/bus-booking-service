#!/usr/bin/env python3
"""
로컬 개발 환경용 Slack Webhook 프록시 서버

CORS(Cross-Origin Resource Sharing) 문제를 해결하기 위해 브라우저 요청을 프록시하여 
Slack으로 전송합니다. 브라우저에서 직접 Slack API를 호출할 수 없기 때문에 
로컬 프록시 서버를 통해 요청을 중계합니다.

사용법:
    python3 scripts/slack_proxy.py [포트번호]
    기본 포트: 8888
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json
import urllib.request
import urllib.error
import os

# Slack Webhook URL 설정
# 실제 사용 시 환경 변수나 설정 파일에서 읽어오는 것을 권장합니다.
# 환경 변수에서 읽거나 설정 파일에서 읽도록 변경하세요.
SLACK_WEBHOOK_URL = os.getenv('SLACK_WEBHOOK_URL', 'YOUR_WEBHOOK_URL_HERE')

class SlackProxyHandler(BaseHTTPRequestHandler):
    """
    Slack Webhook 프록시 요청 핸들러
    브라우저의 POST 요청을 받아 Slack으로 전달합니다.
    """
    
    def do_OPTIONS(self):
        """
        CORS preflight 요청 처리
        브라우저가 실제 POST 요청 전에 보내는 OPTIONS 요청에 대해 CORS 헤더 반환
        """
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('Access-Control-Max-Age', '3600')
        self.end_headers()
    
    def do_POST(self):
        """
        POST 요청 처리: Slack Webhook으로 프록시
        
        /slack-webhook 경로로 들어온 요청만 처리하며,
        요청 본문을 JSON으로 파싱하여 Slack으로 전달합니다.
        """
        # 경로 확인: /slack-webhook이 아니면 404 반환
        if self.path != '/slack-webhook':
            self.send_response(404)
            self.end_headers()
            return
        
        try:
            # 요청 본문 읽기
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            
            # JSON 파싱
            slack_message = json.loads(post_data.decode('utf-8'))
            
            # Slack Webhook으로 전송
            req = urllib.request.Request(
                SLACK_WEBHOOK_URL,
                data=json.dumps(slack_message).encode('utf-8'),
                headers={'Content-Type': 'application/json'},
                method='POST'
            )
            
            try:
                # Slack API 호출 (타임아웃 10초)
                with urllib.request.urlopen(req, timeout=10) as response:
                    response_data = response.read().decode('utf-8')
                    status_code = response.getcode()
                    
                    # Slack의 응답 확인 ('ok'는 성공, 그 외는 에러)
                    if response_data == 'ok':
                        # 성공 응답: Slack이 'ok'를 반환한 경우
                        self.send_response(200)
                        self.send_header('Content-Type', 'application/json')
                        self.send_header('Access-Control-Allow-Origin', '*')
                        self.end_headers()
                        
                        response_json = {
                            'success': True,
                            'message': 'Message sent to Slack successfully',
                            'slack_response': response_data
                        }
                        self.wfile.write(json.dumps(response_json).encode('utf-8'))
                        
                        print(f'✅ Successfully sent message to Slack (Status: {status_code}, Response: {response_data})')
                    else:
                        # Slack이 "no_service" 등의 에러 메시지를 반환한 경우
                        print(f'⚠️ Slack returned unexpected response: {response_data} (Status: {status_code})')
                        
                        # HTTP 상태는 200이지만 success는 false로 설정
                        self.send_response(200)
                        self.send_header('Content-Type', 'application/json')
                        self.send_header('Access-Control-Allow-Origin', '*')
                        self.end_headers()
                        
                        response_json = {
                            'success': False,
                            'error': 'Slack Webhook returned error',
                            'details': response_data,
                            'message': 'Webhook URL may be invalid or deactivated. Please check the Slack Webhook configuration.'
                        }
                        self.wfile.write(json.dumps(response_json).encode('utf-8'))
                    
            except urllib.error.HTTPError as e:
                # HTTP 에러 처리 (4xx, 5xx 등)
                error_body = e.read().decode('utf-8')
                print(f'❌ Slack API Error: {e.code} - {error_body}')
                
                self.send_response(500)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                
                error_json = {
                    'success': False,
                    'error': f'Slack API Error: {e.code}',
                    'details': error_body
                }
                self.wfile.write(json.dumps(error_json).encode('utf-8'))
                
            except urllib.error.URLError as e:
                # 네트워크 에러 처리 (연결 실패 등)
                print(f'❌ Network Error: {e.reason}')
                
                self.send_response(500)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                
                error_json = {
                    'success': False,
                    'error': 'Network Error',
                    'details': str(e.reason)
                }
                self.wfile.write(json.dumps(error_json).encode('utf-8'))
                
        except json.JSONDecodeError as e:
            # JSON 파싱 오류 처리
            print(f'❌ JSON Parse Error: {e}')
            self.send_response(400)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            error_json = {
                'success': False,
                'error': 'Invalid JSON',
                'details': str(e)
            }
            self.wfile.write(json.dumps(error_json).encode('utf-8'))
            
        except Exception as e:
            # 기타 예외 처리
            print(f'❌ Unexpected Error: {e}')
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            error_json = {
                'success': False,
                'error': 'Internal Server Error',
                'details': str(e)
            }
            self.wfile.write(json.dumps(error_json).encode('utf-8'))
    
    def log_message(self, format, *args):
        """
        로깅 메시지 포맷팅
        기본 로깅 형식을 커스텀하여 클라이언트 주소와 함께 출력
        """
        print(f"[{self.address_string()}] {format % args}")

def run(port=8888):
    """
    프록시 서버 실행
    
    Args:
        port (int): 서버가 리스닝할 포트 번호 (기본값: 8888)
    """
    server_address = ('', port)
    httpd = HTTPServer(server_address, SlackProxyHandler)
    print(f'🚀 Slack Webhook Proxy Server running on http://localhost:{port}')
    print(f'📍 Proxy endpoint: http://localhost:{port}/slack-webhook')
    print(f'🔗 Target: {SLACK_WEBHOOK_URL}')
    print('Press Ctrl+C to stop the server\n')
    httpd.serve_forever()

if __name__ == '__main__':
    import sys
    # 명령줄 인자로 포트 번호를 받거나 기본값 8888 사용
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8888
    run(port)
