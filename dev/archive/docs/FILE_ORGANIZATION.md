# 파일 정리 완료

## 📁 폴더별 파일 위치

### 배포 폴더 (public, deploy_files, dist)
각 폴더 내에 모든 리소스가 함께 위치:
- HTML 파일: `index_v2*.html`
- CSS: `styles_v2.css`
- JavaScript: `script.js`
- 로고: `logo-가로.png`
- 파비콘: `favicon-*.png`, `apple-touch-icon.png`, `android-chrome-*.png`, `favicon.ico`

### 소스 폴더 (src)
- HTML: `src/html/index_v2*.html`
- CSS: `src/css/styles_v2.css`
- JavaScript: `src/js/script.js`
- 이미지/파비콘: `src/assets/images/`

### 문서 폴더 (docs)
- 모든 문서 파일: `docs/*.md`

### 백업 폴더 (archive)
- 원본 파일들: `archive/favicon-sources/`

## 🔗 경로 규칙

### 배포 폴더 (public, deploy_files, dist)
모든 파일이 같은 폴더에 있으므로 상대 경로:
- `styles_v2.css`
- `script.js`
- `logo-가로.png`
- `favicon-32x32.png`

### 소스 폴더 (src/html)
상대 경로로 상위 폴더 참조:
- `../css/styles_v2.css`
- `../js/script.js`
- `../assets/images/logo-가로.png`
- `../assets/images/favicon-32x32.png`

## ✅ 정리 완료
- 루트 폴더의 이미지 파일들 → public 폴더로 이동
- 문서 파일들 → docs 폴더로 이동
- 각 폴더별 경로 검증 완료
