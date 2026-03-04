#!/bin/bash
# 배포용 빌드 스크립트
# src/ 폴더의 파일들을 dist/ 폴더로 빌드하여 GitHub Pages 배포 준비
# HTML 파일 내의 상대 경로를 배포 환경에 맞게 수정합니다.

set -e  # 오류 발생 시 스크립트 중단

echo "🚀 배포 파일 빌드 시작..."

# 스크립트가 있는 디렉토리의 상위(프로젝트 루트)로 이동
cd "$(dirname "$0")/.." || exit 1

# dist 폴더 생성 및 정리 (기존 파일 삭제 후 새로 생성)
echo "📁 dist 폴더 준비..."
rm -rf dist
mkdir -p dist

# 캐시 방지용 버전 (배포할 때마다 새로 받도록)
CACHE_VER="${BUILD_CACHE_VER:-$(date +%s)}"
echo "📄 HTML 파일 복사 및 경로 수정... (script/i18n 캐시버전: $CACHE_VER)"
for html_file in src/html/*.html; do
    if [ -f "$html_file" ]; then
        filename=$(basename "$html_file")
        cp "$html_file" "dist/$filename"
        
        # 경로 수정: 상대 경로를 같은 폴더 기준으로 변경
        # ../css/styles_v2.css → styles_v2.css
        # ../js/script.js → script.js (캐시버전 쿼리 추가)
        # ../assets/images/ → 이미지 파일명 (같은 폴더에 복사되므로)
        
        # 운영체제별 sed 명령어 처리 (macOS와 Linux의 차이)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS용 sed (빈 문자열을 백업 확장자로 사용)
            # CSS 경로 수정
            sed -i '' 's|href="../css/styles_v2.css"|href="styles_v2.css"|g' "dist/$filename"
            # JavaScript 경로 수정 + 캐시 버스팅
            sed -i '' "s|src=\"../js/script.js\"|src=\"script.js?v=$CACHE_VER\"|g" "dist/$filename"
            sed -i '' "s|src=\"../js/i18n.js\"|src=\"i18n.js?v=$CACHE_VER\"|g" "dist/$filename"
            # 이미지 경로 수정
            sed -i '' 's|src="../assets/images/logo-가로.png"|src="logo-가로.png"|g' "dist/$filename"
            sed -i '' 's|src="../assets/images/logo-원형.png"|src="logo-원형.png"|g' "dist/$filename"
            # Favicon 경로 수정
            sed -i '' 's|href="../assets/images/favicon-32x32.png"|href="favicon-32x32.png"|g' "dist/$filename"
            sed -i '' 's|href="../assets/images/favicon-16x16.png"|href="favicon-16x16.png"|g' "dist/$filename"
            sed -i '' 's|href="../assets/images/apple-touch-icon.png"|href="apple-touch-icon.png"|g' "dist/$filename"
            sed -i '' 's|href="../assets/images/android-chrome-192x192.png"|href="android-chrome-192x192.png"|g' "dist/$filename"
            sed -i '' 's|href="../assets/images/android-chrome-512x512.png"|href="android-chrome-512x512.png"|g' "dist/$filename"
            sed -i '' 's|href="../assets/images/favicon.ico"|href="favicon.ico"|g' "dist/$filename"
        else
            # Linux용 sed
            # CSS 경로 수정
            sed -i 's|href="../css/styles_v2.css"|href="styles_v2.css"|g' "dist/$filename"
            # JavaScript 경로 수정 + 캐시 버스팅
            sed -i "s|src=\"../js/script.js\"|src=\"script.js?v=$CACHE_VER\"|g" "dist/$filename"
            sed -i "s|src=\"../js/i18n.js\"|src=\"i18n.js?v=$CACHE_VER\"|g" "dist/$filename"
            # 이미지 경로 수정
            sed -i 's|src="../assets/images/logo-가로.png"|src="logo-가로.png"|g' "dist/$filename"
            sed -i 's|src="../assets/images/logo-원형.png"|src="logo-원형.png"|g' "dist/$filename"
            # Favicon 경로 수정
            sed -i 's|href="../assets/images/favicon-32x32.png"|href="favicon-32x32.png"|g' "dist/$filename"
            sed -i 's|href="../assets/images/favicon-16x16.png"|href="favicon-16x16.png"|g' "dist/$filename"
            sed -i 's|href="../assets/images/apple-touch-icon.png"|href="apple-touch-icon.png"|g' "dist/$filename"
            sed -i 's|href="../assets/images/android-chrome-192x192.png"|href="android-chrome-192x192.png"|g' "dist/$filename"
            sed -i 's|href="../assets/images/android-chrome-512x512.png"|href="android-chrome-512x512.png"|g' "dist/$filename"
            sed -i 's|href="../assets/images/favicon.ico"|href="favicon.ico"|g' "dist/$filename"
        fi
        
        echo "  ✓ $filename"
    fi
done

# CSS 파일 복사
echo "🎨 CSS 파일 복사..."
cp src/css/*.css dist/ 2>/dev/null || true

# JavaScript 파일 복사
echo "📜 JavaScript 파일 복사..."
cp src/js/*.js dist/ 2>/dev/null || true

# 이미지 및 아이콘 파일 복사
echo "🖼️  이미지 및 아이콘 파일 복사..."
if [ -d "src/assets/images" ]; then
    cp src/assets/images/*.png dist/ 2>/dev/null || true
    cp src/assets/images/*.jpg dist/ 2>/dev/null || true
    cp src/assets/images/*.svg dist/ 2>/dev/null || true
    cp src/assets/images/*.ico dist/ 2>/dev/null || true
fi

# Slack Webhook PHP 프록시 복사 (도메인 연결 후 슬랙 알림용)
echo "📤 Slack Webhook 프록시 복사..."
if [ -f "public/slack-webhook-proxy.php" ]; then
    cp public/slack-webhook-proxy.php dist/
    echo "  ✓ slack-webhook-proxy.php"
fi
if [ -f "public/slack_webhook_config.php.example" ]; then
    cp public/slack_webhook_config.php.example dist/
    echo "  ✓ slack_webhook_config.php.example"
fi

# 빌드 완료 메시지 및 통계 출력
echo ""
echo "✅ 빌드 완료!"
echo ""
echo "📋 dist/ 폴더에 배포 준비된 파일:"
echo "  - HTML: $(ls -1 dist/*.html 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  - CSS: $(ls -1 dist/*.css 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  - JS: $(ls -1 dist/*.js 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  - Images: $(ls -1 dist/*.png dist/*.jpg dist/*.svg 2>/dev/null 2>/dev/null | wc -l | tr -d ' ') 개"
echo ""
echo "📍 배포 위치: ./dist/"
echo ""
echo "💡 GitHub Pages 설정:"
echo "   Settings → Pages → Source: 'dist' 폴더 선택"
