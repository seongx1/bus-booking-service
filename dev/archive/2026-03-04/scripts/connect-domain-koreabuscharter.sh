#!/bin/bash
# koreabuscharter.com Cloudways 연결 - 할 일 한 번에 출력
# (Cloudways 도메인 추가는 API 미지원이라 대시보드에서 수동 1회 필요)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SERVER_ID="${CLOUDWAYS_SERVER_ID:-1574100}"

if [ -f "$PROJECT_ROOT/.env" ]; then
  set -a
  . "$PROJECT_ROOT/.env" 2>/dev/null || true
  set +a
fi

# 서버 IP 조회 (있으면)
CW_IP=""
if [ -n "$CLOUDWAYS_EMAIL" ] && [ -n "$CLOUDWAYS_API_KEY" ]; then
  CW_IP=$("$SCRIPT_DIR/cloudways-api.sh" server-ip "$SERVER_ID" 2>/dev/null) || true
fi
[ -z "$CW_IP" ] && CW_IP="68.183.180.33"   # 문서 기준 fallback

echo "=============================================="
echo "  koreabuscharter.com → Cloudways 연결"
echo "=============================================="
echo ""
echo "■ 1. Cloudways (한 번만 하면 됨)"
echo "   https://platform.cloudways.com 로그인"
echo "   → 서버 1574100 → 앱 'Korea bus charter' 선택"
echo "   → 도메인 관리(Domain Management) → 도메인 추가"
echo "   → 입력: koreabuscharter.com"
echo "   → (선택) www.koreabuscharter.com 도 추가"
echo ""
echo "■ 2. 가비아 DNS (도메인 연결 설정)"
echo "   https://domain.gabia.com → koreabuscharter.com → DNS 정보 → 도메인 연결 설정"
echo "   아래 A 레코드 추가:"
echo ""
echo "   타입   호스트   값(IP)"
echo "   A      @        $CW_IP"
echo "   A      www      $CW_IP"
echo ""
echo "■ 3. DNS 전파 후 (몇 분~몇 시간)"
echo "   Cloudways 대시보드 → SSL 인증서 → Let's Encrypt 설치"
echo "   도메인: koreabuscharter.com, www 포함 체크"
echo ""
echo "=============================================="
