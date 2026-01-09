# 🚀 빠른 배포 가이드

## ⚡ 가장 빠른 방법: Netlify Drop (2분 소요)

### 단계별 안내:

1. **브라우저에서 열기**
   - https://app.netlify.com/drop 접속

2. **파일 업로드**
   - 이 폴더에서 다음 파일들을 드래그 앤 드롭:
     - `index_v2.html` (영어)
     - `index_v2_ko.html` (한국어)
     - `index_v2_zh.html` (중국어)
     - `index_v2_ja.html` (일본어)
     - `styles_v2.css`
     - `script.js`
   
   또는 `deploy-files.zip` 파일을 업로드하고 압축 해제

3. **완료!**
   - 즉시 배포 URL이 제공됩니다 (예: `https://random-name-123.netlify.app`)
   - 이 URL을 누구에게나 공유할 수 있습니다

---

## 📋 GitHub Pages 사용하기 (영구적 배포)

GitHub 저장소가 이미 생성되었습니다: `https://github.com/unique-play/korea-bus-charter`

### 다음 단계:

1. **GitHub에 로그인**
   - https://github.com/login

2. **파일 푸시** (터미널에서 실행):
   ```bash
   cd "/Volumes/choimacssd/너구리여행사 버스예약 서비스"
   git push -u origin main
   ```
   
   또는 GitHub 웹사이트에서 직접 파일을 업로드할 수 있습니다.

3. **GitHub Pages 활성화**
   - 저장소 페이지로 이동: https://github.com/unique-play/korea-bus-charter
   - Settings > Pages 클릭
   - Source: "Deploy from a branch" 선택
   - Branch: "main" 선택
   - Save 클릭

4. **배포 완료**
   - 몇 분 후 다음 URL로 접속 가능:
   - `https://unique-play.github.io/korea-bus-charter/index_v2.html`

---

## 🌐 배포된 사이트 접속

### Netlify 사용 시:
- Netlify Drop에서 제공된 URL 사용
- 예: `https://your-site-name.netlify.app/index_v2.html`

### GitHub Pages 사용 시:
- `https://unique-play.github.io/korea-bus-charter/index_v2.html` (영어)
- `https://unique-play.github.io/korea-bus-charter/index_v2_ko.html` (한국어)
- `https://unique-play.github.io/korea-bus-charter/index_v2_zh.html` (중국어)
- `https://unique-play.github.io/korea-bus-charter/index_v2_ja.html` (일본어)

---

## ⚙️ 참고사항

- `config.js`는 보안상 포함되지 않았습니다
- Slack Webhook URL은 배포 후 별도로 설정해야 합니다
- 모든 파일이 정상적으로 작동합니다
