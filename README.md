# 🚌 너구리여행사 버스예약 서비스

Korea Bus Charter - 국제 관광객을 위한 버스 렌탈 서비스 웹사이트

## 📁 프로젝트 구조 (실무 표준)

```
너구리여행사 버스예약 서비스/
│
├── 📂 src/                    # 소스 파일 (개발 작업 폴더)
│   ├── html/                  # HTML 파일들
│   │   ├── index_v2.html      # 영어 버전
│   │   ├── index_v2_ko.html   # 한국어 버전
│   │   ├── index_v2_ja.html   # 일본어 버전
│   │   ├── index_v2_zh.html   # 중국어 버전
│   │   └── index.html         # 리다이렉트 페이지
│   │
│   ├── css/                   # 스타일시트
│   │   ├── styles_v2.css      # 메인 스타일
│   │   └── styles.css         # 레거시 스타일
│   │
│   ├── js/                    # JavaScript 파일
│   │   ├── script.js          # 메인 스크립트
│   │   └── i18n.js            # 다국어 지원
│   │
│   └── assets/                # 정적 자산
│       └── images/            # 이미지 파일
│           ├── logo-가로.png
│           └── logo-원형.png
│
├── 📂 dist/                    # 빌드 결과물 (배포용) ⚠️ 빌드 스크립트 실행 시 생성
│   └── [배포용 파일들]
│
├── 📂 docs/                    # 문서
│   ├── DEPLOY.md              # 배포 가이드
│   ├── LOCAL_DEVELOPMENT.md   # 로컬 개발 가이드
│   └── PROJECT_STRUCTURE.md   # 프로젝트 구조 상세 설명
│
├── 📂 scripts/                 # 유틸리티 스크립트
│   ├── build.sh               # ⭐ 배포 빌드 스크립트
│   ├── deploy-cloudways.sh    # ⭐ Cloudways 배포 준비 스크립트
│   ├── slack_proxy.py         # 로컬 개발용 Slack 프록시
│   └── start_proxy.sh         # 프록시 서버 실행
│
├── 📂 config/                  # 설정 파일
│   ├── config.js              # (보안상 .gitignore에 포함)
│   └── vercel.json            # Vercel 설정 (선택사항)
│
├── 📄 .htaccess               # Apache 설정 (Cloudways 배포용)
│
├── 📂 .github/                 # GitHub 설정
│   └── workflows/             # GitHub Actions (자동 배포)
│
├── 📂 archive/                 # 보관용 (레거시 파일)
│
├── 📄 README.md               # 프로젝트 설명서 (현재 파일)
├── 📄 .gitignore              # Git 제외 파일 목록
└── 📄 package.json            # (선택사항) 프로젝트 메타데이터
```

## 🚀 빠른 시작

### 로컬 개발

1. **의존성 확인**
   ```bash
   # Python 3 필요 (프록시 서버용)
   python3 --version
   ```

2. **Slack 프록시 서버 실행** (로컬 개발용)
   ```bash
   ./scripts/start_proxy.sh
   ```

3. **웹서버 실행**
   ```bash
   # src/html 폴더에서 개발
   cd src/html
   python3 -m http.server 8000
   
   # 또는 전체 프로젝트에서
   python3 -m http.server 8000
   ```

4. **브라우저에서 접속**
   ```
   http://localhost:8000/src/html/index_v2.html
   ```

### 빌드 및 배포

**GitHub Pages 배포:**
```bash
# 1. 빌드 (src/ → dist/)
./scripts/build.sh

# 2. GitHub에 푸시
git add .
git commit -m "Build: Update dist files"
git push

# 3. GitHub Pages 자동 배포
# Settings → Pages → Source: 'dist' 폴더 선택
# 또는 GitHub Actions 자동 배포 사용
```

**Cloudways 배포:**
```bash
# 1. Cloudways 배포 준비 (빌드 + .htaccess 복사)
./scripts/deploy-cloudways.sh

# 2. SFTP로 dist/ 폴더의 모든 파일을 /public_html/ 에 업로드
# 자세한 가이드: docs/CLOUDWAYS_DEPLOY_SUMMARY.md
```

## 📝 작업 흐름

### 개발
```
1. src/ 폴더에서 파일 수정
   - HTML: src/html/
   - CSS: src/css/
   - JS: src/js/
   - 이미지: src/assets/images/

2. 로컬에서 테스트
   python3 -m http.server 8000
```

### 빌드
```bash
./scripts/build.sh
# → src/의 파일들을 dist/로 복사 및 경로 수정
```

### 배포
```bash
git add .
git commit -m "Update"
git push
# → GitHub Actions가 자동으로 배포
```

## 🔧 주요 기능

- ✅ 다국어 지원 (한국어, 영어, 일본어, 중국어)
- ✅ 반응형 디자인
- ✅ Slack Webhook 연동 (견적 요청 알림)
- ✅ 로컬 개발용 CORS 프록시 서버
- ✅ 자동 배포 (GitHub Actions)

## 🛠️ 기술 스택

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Slack Incoming Webhooks
- **Dev Tools**: Python (프록시 서버), Shell Script
- **Deployment**: GitHub Pages, GitHub Actions, Cloudways

## 📚 문서

자세한 내용은 `docs/` 폴더를 참고하세요:

- [로컬 개발 가이드](docs/LOCAL_DEVELOPMENT.md)
- [배포 가이드](docs/DEPLOY.md)
- [Cloudways 배포 가이드 (요약)](docs/CLOUDWAYS_DEPLOY_SUMMARY.md) ⭐
- [Cloudways 배포 가이드 (상세)](docs/CLOUDWAYS_DEPLOY_DETAILED.md) ⭐
- [프로젝트 구조 상세](docs/PROJECT_STRUCTURE.md)
- [Slack 설정 가이드](docs/SLACK_SETUP_GUIDE.md)

## ⚠️ 주의사항

1. **`src/` 폴더에서만 개발**
   - 모든 수정은 `src/` 폴더에서만 진행
   - `dist/` 폴더는 빌드 스크립트가 자동 생성

2. **빌드 후 배포**
   - `./scripts/build.sh` 실행 후 `dist/` 폴더 확인
   - `dist/` 폴더의 파일들을 GitHub에 푸시

3. **배포 플랫폼 선택**
   - **GitHub Pages**: Settings → Pages → Source: `dist` 폴더 선택
   - **Cloudways**: `./scripts/deploy-cloudways.sh` 실행 후 SFTP 업로드
   - 자세한 배포 가이드는 `docs/` 폴더 참고

## 📝 라이센스

Copyright © 2026 Noguri Travel Agency. All Rights Reserved.
