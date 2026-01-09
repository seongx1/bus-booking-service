# 웹사이트 배포 가이드

## 빠른 배포 방법 (임시)

### 방법 1: Netlify Drop (가장 빠름 - 2분)
1. https://app.netlify.com/drop 접속
2. 이 폴더의 파일들을 드래그 앤 드롭
3. 즉시 배포 URL 제공됨

### 방법 2: Vercel (빠름 - 3분)
1. https://vercel.com 접속
2. "Add New Project" 클릭
3. 이 폴더를 드래그 앤 드롭
4. 즉시 배포 URL 제공됨

### 방법 3: GitHub Pages (영구적)
1. GitHub에 새 저장소 생성
2. 다음 명령어 실행:
```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```
3. GitHub 저장소 Settings > Pages에서 Source를 "main" 브랜치로 설정
4. 몇 분 후 `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/index_v2.html` 접속 가능

## 현재 파일 구조
- index_v2.html (영어)
- index_v2_ko.html (한국어)
- index_v2_zh.html (중국어)
- index_v2_ja.html (일본어)
- styles_v2.css
- script.js

## 참고사항
- config.js는 보안상 GitHub에 포함되지 않았습니다
- Slack Webhook URL은 배포 후 별도로 설정해야 합니다
