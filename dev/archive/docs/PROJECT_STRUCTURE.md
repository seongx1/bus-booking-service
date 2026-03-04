# 📁 프로젝트 구조 (실무 표준)

## 전체 구조

```
너구리여행사 버스예약 서비스/
│
├── 📂 src/                    # ⭐ 개발 소스 파일 (메인 작업 폴더)
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
│           ├── logo-원형.png
│           └── ...
│
├── 📂 dist/                    # ⚠️ 빌드 결과물 (자동 생성)
│   └── [배포용 파일들]        # build.sh 실행 시 생성
│
├── 📂 docs/                    # 📚 문서
│   ├── DEPLOY.md              # 배포 가이드
│   ├── LOCAL_DEVELOPMENT.md   # 로컬 개발 가이드
│   ├── PROJECT_STRUCTURE.md   # 이 파일
│   ├── SLACK_SETUP_GUIDE.md   # Slack 설정 가이드
│   └── ...
│
├── 📂 scripts/                 # 🔧 유틸리티 스크립트
│   ├── build.sh               # ⭐ 배포 빌드 스크립트
│   ├── slack_proxy.py         # 로컬 개발용 Slack 프록시
│   ├── start_proxy.sh         # 프록시 서버 실행
│   └── ...
│
├── 📂 config/                  # ⚙️ 설정 파일
│   ├── config.js              # (보안상 .gitignore에 포함)
│   └── vercel.json            # Vercel 설정 (선택사항)
│
├── 📂 .github/                 # 🔄 GitHub 설정
│   └── workflows/             # GitHub Actions
│       └── deploy.yml         # 자동 배포 워크플로우
│
├── 📂 archive/                 # 📦 보관용 (레거시 파일)
│
├── 📄 README.md                # 프로젝트 설명서
├── 📄 .gitignore               # Git 제외 파일 목록
└── 📄 package.json             # (선택사항) 프로젝트 메타데이터
```

## 📋 폴더별 역할

| 폴더 | 용도 | 설명 | 수정 여부 |
|------|------|------|----------|
| `src/` | **개발** | 모든 개발 작업은 여기서 진행 | ✅ 직접 수정 |
| `dist/` | **배포** | 빌드 결과물 (배포용) | ❌ 자동 생성 |
| `docs/` | **문서** | 프로젝트 문서 및 가이드 | ✅ 직접 수정 |
| `scripts/` | **유틸리티** | 빌드, 배포, 개발 도구 | ✅ 직접 수정 |
| `config/` | **설정** | 프로젝트 설정 파일 | ⚠️ 보안 주의 |
| `.github/` | **CI/CD** | GitHub Actions 워크플로우 | ✅ 직접 수정 |
| `archive/` | **보관** | 레거시 파일 보관 | ❌ 참고용 |

## 🔄 작업 흐름

### 1. 개발
```bash
# src/ 폴더에서 작업
cd src/html
vim index_v2.html

# 또는 전체 프로젝트에서
python3 -m http.server 8000
# → http://localhost:8000/src/html/index_v2.html
```

### 2. 빌드
```bash
# 루트에서 실행
./scripts/build.sh

# 결과:
# ✅ dist/ 폴더에 배포용 파일 생성
# ✅ 경로 자동 수정 (../css/ → styles_v2.css)
```

### 3. 테스트
```bash
# dist/ 폴더에서 테스트
cd dist
python3 -m http.server 8000
# → http://localhost:8000/index_v2.html
```

### 4. 배포
```bash
# Git 커밋 및 푸시
git add .
git commit -m "Update: 메시지"
git push

# GitHub Actions가 자동으로 배포
# 또는 GitHub Pages에서 dist/ 폴더 선택
```

## 📂 상세 구조

### src/ (개발 소스)
```
src/
├── html/              # HTML 파일들 (직접 수정)
├── css/               # 스타일시트 (직접 수정)
├── js/                # JavaScript (직접 수정)
└── assets/            # 정적 자산
    └── images/        # 이미지 파일 (직접 수정)
```

**경로 규칙:**
- HTML → `../css/styles_v2.css`
- HTML → `../js/script.js`
- HTML → `../assets/images/logo-가로.png`

### dist/ (빌드 결과물)
```
dist/
├── *.html             # 배포용 HTML (자동 생성)
├── *.css              # 배포용 CSS (자동 생성)
├── *.js               # 배포용 JS (자동 생성)
└── *.png              # 이미지 파일 (자동 생성)
```

**경로 규칙:**
- HTML → `styles_v2.css` (상대 경로 제거)
- HTML → `script.js`
- HTML → `logo-가로.png`

## 🚫 주의사항

### ❌ 하지 말아야 할 것

1. **`dist/` 폴더 직접 수정 금지**
   - `build.sh` 실행 시 덮어씌워짐
   - 모든 수정은 `src/` 폴더에서만

2. **루트에 빌드 파일 생성 금지**
   - 배포 파일은 반드시 `dist/` 폴더에만
   - 루트는 설정 파일들만

3. **`config/config.js` 커밋 금지**
   - `.gitignore`에 포함됨
   - 보안상 Webhook URL 포함

### ✅ 해야 할 것

1. **`src/` 폴더에서만 개발**
   - 모든 수정은 `src/` 폴더에서
   - 빌드 후 `dist/` 확인

2. **빌드 후 테스트**
   - `./scripts/build.sh` 실행
   - `dist/` 폴더에서 로컬 테스트

3. **Git 커밋 규칙**
   ```bash
   # src/ 폴더 변경만 커밋
   git add src/
   git add scripts/
   git add docs/
   git commit -m "Update: 설명"
   
   # dist/ 폴더는 빌드 후 커밋
   ./scripts/build.sh
   git add dist/
   git commit -m "Build: 배포 파일 업데이트"
   ```

## 🔍 파일 찾기 가이드

| 찾고 싶은 파일 | 위치 |
|---------------|------|
| HTML 수정 | `src/html/` |
| CSS 수정 | `src/css/` |
| JavaScript 수정 | `src/js/` |
| 이미지 추가 | `src/assets/images/` |
| 문서 보기 | `docs/` |
| 빌드 스크립트 | `scripts/build.sh` |
| 배포 파일 확인 | `dist/` |

## 📝 실무 베스트 프랙티스

### 1. 명확한 구조
- ✅ `src/`: 개발 소스
- ✅ `dist/`: 빌드 결과물
- ✅ 루트: 설정 파일만

### 2. 자동화
- ✅ 빌드 스크립트 (`build.sh`)
- ✅ GitHub Actions (자동 배포)
- ✅ 프록시 서버 (로컬 개발)

### 3. 문서화
- ✅ README.md (프로젝트 개요)
- ✅ docs/ (상세 가이드)
- ✅ 주석 및 구조 설명

### 4. 버전 관리
- ✅ .gitignore (불필요한 파일 제외)
- ✅ 명확한 커밋 메시지
- ✅ 구조 변경 시 문서 업데이트
