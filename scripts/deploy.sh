#!/bin/bash
# 웹사이트 배포 스크립트
# Netlify Drop 또는 GitHub Pages를 통한 배포를 도와주는 스크립트

echo "=== 웹사이트 배포 스크립트 ==="
echo ""
echo "현재 디렉토리: $(pwd)"
echo ""
echo "배포 방법을 선택하세요:"
echo "1. Netlify Drop (가장 빠름)"
echo "2. GitHub Pages 설정 안내"
echo ""
read -p "선택 (1 또는 2): " choice

if [ "$choice" = "1" ]; then
    # Netlify Drop을 통한 배포 (가장 빠른 방법)
    echo ""
    echo "Netlify Drop 사용 방법:"
    echo "1. https://app.netlify.com/drop 접속"
    echo "2. 다음 파일들을 드래그 앤 드롭:"
    echo "   - public/index_v2.html"
    echo "   - public/index_v2_ko.html"
    echo "   - public/index_v2_zh.html"
    echo "   - public/index_v2_ja.html"
    echo "   - src/css/styles_v2.css"
    echo "   - src/js/script.js"
    echo "   - config/config.js"
    echo ""
    echo "3. 즉시 배포 URL이 제공됩니다!"
    # macOS에서 브라우저 자동 열기 시도, 실패 시 수동 안내
    open https://app.netlify.com/drop 2>/dev/null || echo "브라우저에서 수동으로 열어주세요: https://app.netlify.com/drop"
elif [ "$choice" = "2" ]; then
    # GitHub Pages를 통한 배포 설정 안내
    echo ""
    echo "GitHub Pages 설정:"
    echo "1. GitHub에서 새 저장소를 만드세요"
    echo "2. 저장소 URL을 입력하세요:"
    read -p "GitHub 저장소 URL: " repo_url
    if [ ! -z "$repo_url" ]; then
        # Git 원격 저장소 설정 (이미 있으면 업데이트)
        git remote add origin "$repo_url" 2>/dev/null || git remote set-url origin "$repo_url"
        git branch -M main
        echo ""
        echo "다음 명령어를 실행하세요:"
        echo "git push -u origin main"
        echo ""
        echo "그 후 GitHub 저장소 Settings > Pages에서 Source를 'main' 브랜치로 설정하세요"
    fi
else
    echo "잘못된 선택입니다."
fi
