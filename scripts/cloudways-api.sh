#!/bin/bash
# Cloudways API 헬퍼 스크립트
# 환경 변수: CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY (필수)
# 사용법: ./scripts/cloudways-api.sh [servers|apps <server_id>]

set -e
BASE_URL="https://api.cloudways.com/api/v1"

usage() {
    echo "사용법: $0 servers                        # 서버 목록 조회"
    echo "       $0 apps <server_id>               # 해당 서버의 앱 목록 조회 (예: 1574100)"
    echo "       $0 server-ip <server_id>          # 서버 공용 IP만 출력 (배포용)"
    echo "       $0 create-app <server_id> <이름>   # 기존 서버에 앱 추가 (PHP 스택, 예: 1574100 \"Korea bus charter\")"
    echo ""
    echo "필수 환경 변수: CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY"
    echo "  export CLOUDWAYS_EMAIL=\"your@email.com\""
    echo "  export CLOUDWAYS_API_KEY=\"your_api_key\""
    exit 1
}

get_access_token() {
    if [ -z "$CLOUDWAYS_EMAIL" ] || [ -z "$CLOUDWAYS_API_KEY" ]; then
        echo "오류: CLOUDWAYS_EMAIL 과 CLOUDWAYS_API_KEY 환경 변수를 설정해 주세요."
        echo "  대시보드: 메뉴 → API Integration → Generate Key"
        exit 1
    fi
    local res
    res=$(curl -s -X POST "$BASE_URL/oauth/access_token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "email=$CLOUDWAYS_EMAIL&api_key=$CLOUDWAYS_API_KEY")
    local token
    token=$(echo "$res" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)
    if [ -z "$token" ]; then
        echo "오류: 액세스 토큰 발급 실패. 응답: $res"
        exit 1
    fi
    echo "$token"
}

cmd_servers() {
    local token
    token=$(get_access_token)
    echo "서버 목록 조회 중..."
    curl -s -X GET "$BASE_URL/server" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" | python3 -m json.tool 2>/dev/null || cat
}

cmd_apps() {
    local server_id="$1"
    if [ -z "$server_id" ]; then
        echo "오류: server_id 가 필요합니다. 예: $0 apps 1574100"
        exit 1
    fi
    local token
    token=$(get_access_token)
    echo "서버 $server_id 앱/상세 조회 중..."
    curl -s -X GET "$BASE_URL/server/$server_id" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" | python3 -m json.tool 2>/dev/null || cat
}

# 서버 공용 IP만 출력 (배포 스크립트에서 호스트로 사용)
cmd_server_ip() {
    local server_id="$1"
    if [ -z "$server_id" ]; then
        echo "오류: server_id 가 필요합니다. 예: $0 server-ip 1574100"
        exit 1
    fi
    local token
    token=$(get_access_token)
    local res
    res=$(curl -s -X GET "$BASE_URL/server/$server_id" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json")
    local ip
    ip=$(echo "$res" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    s = d.get('server') or d
    print(s.get('public_ip') or s.get('public_ip_address') or '')
except Exception:
    print('')
" 2>/dev/null)
    if [ -z "$ip" ]; then
        echo "오류: 서버 IP를 가져오지 못했습니다. 응답: $res" >&2
        exit 1
    fi
    echo "$ip"
}

cmd_create_app() {
    local server_id="$1"
    local app_label="$2"
    if [ -z "$server_id" ] || [ -z "$app_label" ]; then
        echo "오류: server_id 와 앱 이름이 필요합니다. 예: $0 create-app 1574100 \"Korea bus charter\""
        exit 1
    fi
    local token
    token=$(get_access_token)
    echo "서버 $server_id 에 앱 생성 중: $app_label (phpstack 8.1)..."
    local res
    res=$(curl -s -X POST "$BASE_URL/app" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"server_id\":$server_id,\"application\":\"phpstack\",\"app_version\":\"8.1\",\"app_label\":$(python3 -c "import sys,json; print(json.dumps(sys.argv[1]))" "$app_label")}")
    echo "$res" | python3 -m json.tool 2>/dev/null || echo "$res"
    if echo "$res" | grep -q '"status":\s*true'; then
        echo "✅ 앱 생성 요청이 접수되었습니다. 1~2분 후 대시보드 또는 ' $0 apps $server_id ' 로 확인하세요."
    fi
}

case "${1:-}" in
    servers)     cmd_servers ;;
    apps)        cmd_apps "${2:-}" ;;
    server-ip)   cmd_server_ip "${2:-}" ;;
    create-app)  cmd_create_app "${2:-}" "${3:-}" ;;
    *)           usage ;;
esac
