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
├── 📂 .github/                 # GitHub 설정 (Cloudways 배포만 사용)
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

### 빌드 및 배포 (Cloudways)

배포는 **Cloudways**로만 진행합니다. (GitHub Pages는 사용하지 않습니다.)

```bash
# 방법 A: .env에 CLOUDWAYS_SFTP_* 설정 후 한 번에 빌드+업로드
./scripts/deploy-to-cloudways.sh

# 방법 B: 빌드만 한 뒤 수동 SFTP 업로드
./scripts/deploy-cloudways.sh
# 그 다음 dist/ 내용을 SFTP로 서버 /public_html/ 에 업로드
```
자세한 가이드: docs/CLOUDWAYS_DEPLOY_SUMMARY.md

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
./scripts/deploy-cloudways.sh
# → dist/ 내용을 SFTP로 Cloudways 서버 /public_html/ 에 업로드
```

## 🔧 주요 기능

- ✅ 다국어 지원 (한국어, 영어, 일본어, 중국어)
- ✅ 반응형 디자인
- ✅ Slack Webhook 연동 (견적 요청 알림)
- ✅ 로컬 개발용 CORS 프록시 서버
- ✅ Cloudways 배포 (SFTP)

## 🛠️ 기술 스택

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Slack Incoming Webhooks
- **Dev Tools**: Python (프록시 서버), Shell Script
- **Deployment**: Cloudways (SFTP)

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

2. **배포**
   - `./scripts/deploy-cloudways.sh` 실행 후 `dist/` 폴더를 SFTP로 Cloudways 서버 `/public_html/`에 업로드
   - 자세한 배포 가이드: `docs/CLOUDWAYS_DEPLOY_SUMMARY.md`, `docs/CLOUDWAYS_DEPLOY_DETAILED.md`

3. **GitHub Pages 폐쇄**
   - 이 프로젝트는 GitHub Pages를 사용하지 않습니다. 이미 사용 중이었다면 저장소 **Settings → Pages**에서 Source를 "None"으로 설정해 주세요.

## 📝 라이센스

Copyright © 2026 Noguri Travel Agency. All Rights Reserved.
