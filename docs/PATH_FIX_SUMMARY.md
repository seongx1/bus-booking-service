# 경로 수정 완료 내역

## 수정된 경로들

### 1. CSS 경로
- **src/html/**: `href="../css/styles_v2.css"`
- **dist/**: `href="styles_v2.css"` (빌드 시 자동 변환)

### 2. JavaScript 경로
- **src/html/**: `src="../js/script.js"`
- **dist/**: `src="script.js"` (빌드 시 자동 변환)

### 3. 이미지 경로
- **src/html/**: `src="../assets/images/logo-가로.png"`
- **dist/**: `src="logo-가로.png"` (빌드 시 자동 변환)

### 4. 언어 전환 경로 ⭐
- **모든 HTML 파일**: 현재 파일 위치를 기준으로 자동 계산
  ```javascript
  const currentPath = window.location.pathname;
  const basePath = currentPath.substring(0, currentPath.lastIndexOf('/') + 1);
  const langMap = {
      'en': basePath + 'index_v2.html',
      'ko': basePath + 'index_v2_ko.html',
      'zh': basePath + 'index_v2_zh.html',
      'ja': basePath + 'index_v2_ja.html'
  };
  ```

## 작동 방식

### 개발 환경 (src/html/)
- URL: `http://localhost:8000/src/html/index_v2.html`
- basePath: `/src/html/`
- 결과: `/src/html/index_v2_ko.html` ✅

### 배포 환경 (dist/)
- URL: `https://example.com/dist/index_v2.html` 또는 `https://example.com/index_v2.html`
- basePath: `/dist/` 또는 `/`
- 결과: `/dist/index_v2_ko.html` 또는 `/index_v2_ko.html` ✅

## 수정된 파일

1. `src/html/index_v2.html` ✅
2. `src/html/index_v2_ko.html` ✅
3. `src/html/index_v2_ja.html` ✅
4. `src/html/index_v2_zh.html` ✅

## 테스트 방법

### 로컬 테스트
```bash
# src/html 폴더에서 테스트
cd src/html
python3 -m http.server 8000
# → http://localhost:8000/index_v2.html
# → 언어 전환 버튼 클릭하여 확인
```

### 배포 테스트
```bash
# 빌드
./scripts/build.sh

# dist 폴더에서 테스트
cd dist
python3 -m http.server 8000
# → http://localhost:8000/index_v2.html
# → 언어 전환 버튼 클릭하여 확인
```

