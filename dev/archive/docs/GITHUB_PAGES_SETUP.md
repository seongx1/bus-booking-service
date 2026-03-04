# 🌐 GitHub Pages 배포 가이드

너구리여행사 버스예약 서비스를 GitHub Pages에 자동 배포하는 방법입니다.

## 📋 사전 준비사항

- ✅ GitHub 저장소에 코드가 푸시되어 있어야 함
- ✅ GitHub Actions 권한 활성화 필요
- ✅ 저장소가 Public이거나 GitHub Pro/Team 계정 (Private 저장소의 경우)

---

## 🚀 빠른 설정 (3단계)

### 1단계: GitHub 저장소 설정

1. GitHub 저장소 페이지 접속: `https://github.com/seongx1/bus-booking-service`
2. **Settings** 탭 클릭
3. 왼쪽 메뉴에서 **Pages** 클릭
4. **Source** 섹션에서:
   - **"GitHub Actions"** 선택
   - 저장

### 2단계: GitHub Actions 확인

워크플로우 파일이 이미 설정되어 있습니다:
- 위치: `.github/workflows/deploy.yml`
- 트리거: `main` 브랜치에 푸시할 때마다 자동 실행

### 3단계: 배포 트리거

```bash
# 빌드 실행 (로컬에서 테스트)
./scripts/build.sh

# 변경사항 커밋 및 푸시
git add .
git commit -m "chore: GitHub Pages 배포 트리거"
git push origin main
```

---

## 📍 배포 확인

### GitHub Actions 확인

1. GitHub 저장소 페이지 접속
2. **Actions** 탭 클릭
3. 최근 워크플로우 실행 확인:
   - ✅ 녹색 체크: 배포 성공
   - ❌ 빨간 X: 배포 실패 (로그 확인)

### 웹사이트 접속

배포가 완료되면 다음 URL로 접속 가능:
```
https://seongx1.github.io/bus-booking-service/
```

또는 GitHub Pages 설정에서 확인된 커스텀 도메인 사용 가능

---

## 🔧 워크플로우 상세 설명

### 자동 배포 트리거

- **`push`**: `main` 브랜치에 푸시할 때마다 자동 배포
- **`workflow_dispatch`**: 수동으로 배포 실행 가능 (Actions 탭에서)

### 배포 프로세스

1. **빌드 단계**:
   ```bash
   ./scripts/build.sh
   ```
   - `src/` 폴더의 파일들을 `dist/` 폴더로 빌드
   - 경로 수정 및 파일 복사

2. **업로드 단계**:
   - `dist/` 폴더를 GitHub Pages 아티팩트로 업로드

3. **배포 단계**:
   - GitHub Pages에 자동 배포

---

## 📂 배포되는 파일

`dist/` 폴더의 모든 파일이 배포됩니다:

```
dist/
├── index.html          # 루트 리다이렉트 페이지
├── index_v2.html       # 영어 버전
├── index_v2_ko.html    # 한국어 버전
├── index_v2_ja.html    # 일본어 버전
├── index_v2_zh.html    # 중국어 버전
├── script.js           # 메인 스크립트
├── i18n.js            # 다국어 지원
├── styles_v2.css      # 스타일시트
├── favicon.ico        # 파비콘
└── [이미지 파일들]    # 로고 및 아이콘
```

---

## 🌍 다국어 버전 접속 URL

배포 후 다음 URL로 접속 가능:

- **영어**: `https://seongx1.github.io/bus-booking-service/index_v2.html`
- **한국어**: `https://seongx1.github.io/bus-booking-service/index_v2_ko.html`
- **일본어**: `https://seongx1.github.io/bus-booking-service/index_v2_ja.html`
- **중국어**: `https://seongx1.github.io/bus-booking-service/index_v2_zh.html`
- **루트**: `https://seongx1.github.io/bus-booking-service/` (자동으로 `index_v2.html`로 리다이렉트)

---

## 🔄 업데이트 배포

코드를 수정하고 배포하려면:

```bash
# 1. 소스 파일 수정 (src/ 폴더에서)
# 예: src/html/index_v2.html 수정

# 2. 빌드 (선택사항 - 로컬 테스트용)
./scripts/build.sh

# 3. 커밋 및 푸시
git add .
git commit -m "feat: 새로운 기능 추가"
git push origin main

# 4. 자동 배포 시작
# GitHub Actions가 자동으로 빌드 및 배포 실행
```

---

## ❗ 문제 해결

### 배포가 실패하는 경우

1. **Actions 탭에서 로그 확인**:
   - 빨간 X가 표시된 워크플로우 클릭
   - 실패한 단계의 로그 확인

2. **일반적인 오류**:

   **오류**: "Permission denied"
   - 해결: GitHub 저장소 Settings → Actions → General → Workflow permissions 확인
   - "Read and write permissions" 선택

   **오류**: "No such file or directory"
   - 해결: 빌드 스크립트 경로 확인
   - `scripts/build.sh` 파일이 존재하는지 확인

   **오류**: "dist folder not found"
   - 해결: 빌드 단계가 성공했는지 확인
   - 로컬에서 `./scripts/build.sh` 실행하여 테스트

3. **빌드 스크립트 권한 확인**:
   ```bash
   chmod +x scripts/build.sh
   git add scripts/build.sh
   git commit -m "chore: 빌드 스크립트 실행 권한 추가"
   git push origin main
   ```

### 웹사이트가 업데이트되지 않는 경우

1. **캐시 문제**:
   - 브라우저 캐시 삭제 (Ctrl+Shift+R 또는 Cmd+Shift+R)
   - 시크릿 모드로 접속 테스트

2. **배포 확인**:
   - GitHub Actions에서 최근 배포 완료 확인
   - 배포 완료 후 몇 분 기다림 (CDN 캐시 전파 시간)

3. **URL 확인**:
   - 올바른 GitHub Pages URL 사용 확인
   - 저장소 이름과 사용자명 확인

---

## 🎯 커스텀 도메인 설정 (선택사항)

### 1. 도메인 구매 및 DNS 설정

1. 도메인 등록 기관에서 도메인 구매
2. DNS 설정에서 CNAME 레코드 추가:
   ```
   이름: @ 또는 www
   값: seongx1.github.io
   ```

### 2. GitHub 저장소 설정

1. GitHub 저장소 → Settings → Pages
2. **Custom domain** 섹션에 도메인 입력
3. **"Enforce HTTPS"** 체크박스 선택 (선택사항)
4. 저장

### 3. 도메인 검증

- DNS 전파 대기 (보통 5-30분)
- HTTPS 인증서 자동 발급 (몇 분 소요)

---

## 📊 배포 상태 확인

### GitHub Actions 대시보드

- **성공**: ✅ 녹색 체크 표시
- **실행 중**: 🟡 노란색 원 표시
- **실패**: ❌ 빨간 X 표시

### 배포 URL 확인

배포가 완료되면 Actions 로그에서 다음 메시지 확인:
```
Deployment completed successfully
Page URL: https://seongx1.github.io/bus-booking-service/
```

---

## 🔐 보안 고려사항

- ✅ Slack Webhook URL은 환경 변수나 별도 설정 파일에서 관리 (GitHub Secrets 사용 가능)
- ✅ 민감한 정보는 저장소에 커밋하지 않음
- ✅ GitHub Pages는 Public 저장소의 경우 공개적으로 접근 가능

---

## 💡 팁

1. **로컬 테스트 먼저**:
   ```bash
   ./scripts/build.sh
   cd dist
   python3 -m http.server 8000
   # http://localhost:8000 접속하여 테스트
   ```

2. **배포 전 체크리스트**:
   - [ ] 로컬에서 빌드 성공
   - [ ] 모든 파일 경로 올바름
   - [ ] 이미지 및 리소스 로드 확인
   - [ ] 다국어 버전 테스트

3. **빠른 재배포**:
   - 코드 수정 없이 재배포하려면 빈 커밋:
   ```bash
   git commit --allow-empty -m "chore: 재배포 트리거"
   git push origin main
   ```

---

**✅ 배포 완료!**

배포가 완료되면 `https://seongx1.github.io/bus-booking-service/` 에서 사이트를 확인할 수 있습니다.