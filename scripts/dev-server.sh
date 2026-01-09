#!/bin/bash
# 로컬 개발용 웹서버 실행 스크립트
# src/html/ 폴더에서 웹서버를 실행하여 정상적인 경로로 접근 가능하게 함
# Python의 내장 HTTP 서버를 사용하여 간단하게 로컬 개발 환경을 구성합니다.

# 스크립트가 있는 디렉토리의 상위(프로젝트 루트)로 이동
cd "$(dirname "$0")/.." || exit 1

# 포트 번호 설정 (명령줄 인자가 없으면 기본값 8000 사용)
PORT=${1:-8000}

echo "🚀 개발 서버 시작..."
echo "📍 접속 URL: http://localhost:$PORT/index_v2.html"
echo ""
echo "🌐 언어별 접속:"
echo "  - 영어: http://localhost:$PORT/index_v2.html"
echo "  - 한국어: http://localhost:$PORT/index_v2_ko.html"
echo "  - 일본어: http://localhost:$PORT/index_v2_ja.html"
echo "  - 중국어: http://localhost:$PORT/index_v2_zh.html"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# src 폴더로 이동하여 서버 실행 (상대 경로 문제 해결)
# HTML 파일에서 ../css, ../js 등의 상대 경로가 정상 작동하도록 함
cd src
python3 -m http.server "$PORT"
