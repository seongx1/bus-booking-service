# 🚀 빠른 시작

## ✅ 서버가 실행 중입니다!

### 🌐 올바른 접속 URL

⚠️ **중요**: 서버가 `src/` 폴더에서 실행되므로 경로가 변경되었습니다!

#### 언어별 접속 URL

- 🇺🇸 **영어**: http://localhost:8000/html/index_v2.html
- 🇰🇷 **한국어**: http://localhost:8000/html/index_v2_ko.html  
- 🇯🇵 **일본어**: http://localhost:8000/html/index_v2_ja.html
- 🇨🇳 **중국어**: http://localhost:8000/html/index_v2_zh.html

### 언어 전환

페이지 상단 우측의 🌐 언어 선택 버튼을 클릭하면 다른 언어로 전환됩니다.

---

## 🔧 서버 재시작

서버가 안 돌아가면:

```bash
# 기존 서버 종료
lsof -ti:8000 | xargs kill -9 2>/dev/null
pkill -9 -f "http.server" 2>/dev/null

# 서버 재시작
cd src
python3 -m http.server 8000
```

또는 스크립트 사용:

```bash
./scripts/dev-server.sh
```

---

## 📍 파일 위치

- HTML: `src/html/index_v2*.html`
- CSS: `src/css/styles_v2.css`
- JS: `src/js/script.js`
- 이미지: `src/assets/images/*.png`

서버는 `src/` 폴더에서 실행되어 모든 파일에 접근 가능합니다.
