#!/bin/bash
# Cloudways 배포 스크립트
# 빌드 후 Cloudways 업로드를 위한 파일 준비

set -e  # 오류 발생 시 스크립트 중단

echo "🚀 Cloudways 배포 준비 시작..."

# 스크립트가 있는 디렉토리의 상위(프로젝트 루트)로 이동
cd "$(dirname "$0")/.." || exit 1

# 1. 빌드 실행
echo "📦 빌드 실행 중..."
./scripts/build.sh

# 2. .htaccess 파일 복사
echo "📄 .htaccess 파일 복사..."
if [ -f ".htaccess" ]; then
    cp .htaccess dist/
    echo "  ✅ .htaccess 파일 복사 완료"
else
    echo "  ⚠️  .htaccess 파일을 찾을 수 없습니다."
fi

# 3. 배포 파일 통계 출력
echo ""
echo "✅ Cloudways 배포 준비 완료!"
echo ""
echo "📋 배포 파일 정보:"
echo "  위치: ./dist/"
echo "  HTML: $(ls -1 dist/*.html 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  CSS: $(ls -1 dist/*.css 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  JS: $(ls -1 dist/*.js 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  이미지: $(ls -1 dist/*.png dist/*.jpg dist/*.svg 2>/dev/null | wc -l | tr -d ' ') 개"
echo "  .htaccess: $([ -f dist/.htaccess ] && echo '✅ 있음' || echo '❌ 없음')"
echo ""

# 4. 업로드 안내
echo "📤 다음 단계:"
echo ""
echo "방법 1: SFTP 클라이언트 사용"
echo "  1. FileZilla, WinSCP 등 SFTP 클라이언트 실행"
echo "  2. Cloudways SFTP 정보로 연결"
echo "  3. dist/ 폴더의 모든 파일을 /public_html/ 에 업로드"
echo ""
echo "방법 2: Cloudways 파일 관리자 사용"
echo "  1. Cloudways 대시보드 → 애플리케이션 관리 → 파일 관리자"
echo "  2. /public_html/ 폴더로 이동"
echo "  3. dist/ 폴더의 파일들을 업로드"
echo ""
echo "방법 3: rsync 사용 (SSH 접속 가능한 경우)"
echo "  rsync -avz --exclude '.git' ./dist/ 사용자명@서버IP:/home/master/applications/앱이름/public_html/"
echo ""

# 5. 필수 파일 체크리스트
echo "📝 필수 파일 확인:"
MISSING_FILES=0

check_file() {
    if [ -f "dist/$1" ]; then
        echo "  ✅ $1"
    else
        echo "  ❌ $1 (누락!)"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
}

check_file "index_v2.html"
check_file "index_v2_ko.html"
check_file "index_v2_ja.html"
check_file "index_v2_zh.html"
check_file "script.js"
check_file "i18n.js"
check_file "styles_v2.css"
check_file "favicon.ico"
check_file "favicon-32x32.png"
check_file "favicon-16x16.png"
check_file ".htaccess"

echo ""

if [ $MISSING_FILES -eq 0 ]; then
    echo "✅ 모든 필수 파일이 준비되었습니다!"
    echo ""
    echo "📚 배포 가이드 참고:"
    echo "  요약: docs/CLOUDWAYS_DEPLOY_SUMMARY.md"
    echo "  상세: docs/CLOUDWAYS_DEPLOY_DETAILED.md"
else
    echo "⚠️  일부 파일이 누락되었습니다. 빌드를 다시 확인해주세요."
    exit 1
fi