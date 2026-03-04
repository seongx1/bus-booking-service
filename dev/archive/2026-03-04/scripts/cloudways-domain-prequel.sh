#!/bin/bash
# Cloudways 도메인 연결 전단계 확인
# .env 에 CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY 가 있으면 서버 IP까지 조회

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SERVER_ID="${CLOUDWAYS_SERVER_ID:-1574100}"

# .env 로드 (있으면)
if [ -f "$PROJECT_ROOT/.env" ]; then
    set -a
    # shellcheck source=/dev/null
    . "$PROJECT_ROOT/.env" 2>/dev/null || true
    set +a
fi

echo "=============================================="
echo "  Cloudways 도메인 연결 전단계"
echo "=============================================="
echo ""
echo "현재 상태 (프로젝트 기준)"
echo "  서버 ID: $SERVER_ID"
echo "  앱: Korea bus charter"
echo "  임시 URL: https://phpstack-1574100-6221145.cloudwaysapps.com/"
echo ""
echo "체크리스트"
echo "  [ ] 도메인 보유 (가비아, 후이즈 등)"
echo "  [ ] Cloudways 로그인 가능"
echo "  [ ] 아래 서버 IP를 DNS A 레코드에 사용할 준비"
echo ""

# API 키 있으면 서버 IP 조회
if [ -n "$CLOUDWAYS_EMAIL" ] && [ -n "$CLOUDWAYS_API_KEY" ]; then
    echo "서버 공용 IP 조회 중..."
    IP=$("$SCRIPT_DIR/cloudways-api.sh" server-ip "$SERVER_ID" 2>/dev/null) || true
    if [ -n "$IP" ]; then
        echo ""
        echo ">>> DNS A 레코드에 넣을 값 (서버 공용 IP)"
        echo "    $IP"
        echo ""
        echo "도메인 등록 기관 DNS에서:"
        echo "  A  @    → $IP"
        echo "  A  www  → $IP"
        echo ""
    else
        echo "  (IP 조회 실패. .env 의 CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY 확인)"
        echo ""
    fi
else
    echo "서버 IP 조회: .env 에 CLOUDWAYS_EMAIL, CLOUDWAYS_API_KEY 를 넣은 뒤"
    echo "  ./scripts/cloudways-api.sh server-ip $SERVER_ID"
    echo "  또는 이 스크립트를 다시 실행하세요."
    echo ""
fi

echo "Cloudways 대시보드에서 할 일"
echo "  1. 애플리케이션 관리 → 도메인 관리 → 도메인 추가"
echo "  2. 사용할 도메인 입력 후 추가"
echo ""
echo "상세 가이드: docs/CLOUDWAYS_DOMAIN_SETUP.md"
echo "=============================================="
