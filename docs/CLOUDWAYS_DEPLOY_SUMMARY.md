# 🚀 Cloudways 배포 가이드 (요약)

너구리여행사 버스예약 서비스를 Cloudways에 배포하는 빠른 가이드입니다.

## 📋 사전 준비사항

- ✅ Cloudways 계정
- ✅ 도메인 (선택사항)
- ✅ 빌드된 `dist/` 폴더 파일들

---

## 🎯 5단계 배포 프로세스

### 1️⃣ 서버 생성 (2-3분)

1. Cloudways 대시보드에서 **"서버 추가(Add Server)"** 클릭
2. 클라우드 제공업체 선택 (추천: **Vultr** - 서울 리전)
3. 서버 사양 선택 (최소: 1GB RAM)
4. 애플리케이션: **"Generic PHP"** 또는 **"Custom PHP"** 선택
5. **"서버 시작(Launch Now)"** 클릭

---

### 2️⃣ 파일 업로드 (5분)

**방법 A: SFTP 사용 (추천)**
```bash
# 빌드 실행
./scripts/build.sh

# SFTP 클라이언트로 연결
호스트: 서버 공용 IP
포트: 22
사용자명: Cloudways 제공 계정
비밀번호: Cloudways 제공 비밀번호
경로: /public_html/

# dist/ 폴더의 모든 파일을 /public_html/ 에 업로드
```

**방법 B: SSH + Git**
```bash
# SSH 접속
ssh 사용자명@서버IP

# Git 클론 또는 파일 전송
cd /home/master/applications/앱이름/public_html/
# 파일 업로드
```

---

### 3️⃣ 도메인 연결 (5분)

1. 도메인 DNS 설정에서 **A 레코드** 추가
   ```
   @ 또는 www → Cloudways 서버 공용 IP
   ```

2. Cloudways 대시보드에서 **"도메인 관리"** → 도메인 추가

3. DNS 전파 대기 (보통 5-30분)

---

### 4️⃣ SSL 인증서 설치 (2분)

1. Cloudways 대시보드 → **"SSL 인증서"** 메뉴
2. **"Let's Encrypt"** 선택
3. 도메인과 이메일 입력
4. **"인증서 설치"** 클릭

---

### 5️⃣ 확인 및 테스트

✅ https://yourdomain.com 접속 확인
✅ 다국어 버전 테스트:
   - /index_v2.html (영어)
   - /index_v2_ko.html (한국어)
   - /index_v2_ja.html (일본어)
   - /index_v2_zh.html (중국어)

---

## ⚙️ 필수 설정 파일

프로젝트 루트의 `.htaccess` 파일을 `/public_html/` 에 업로드해야 합니다.

---

## 🔧 빠른 명령어

```bash
# 1. 빌드
./scripts/build.sh

# 2. 배포 파일 확인
ls -la dist/

# 3. SFTP 업로드 또는
# Cloudways 파일 관리자 사용
```

---

## ❗ 주의사항

- ⚠️ **`dist/` 폴더의 파일만 업로드** (src/ 폴더 아님)
- ⚠️ **`.htaccess` 파일 필수** (루트에 배치)
- ⚠️ **모든 파일을 `/public_html/` 루트에** 업로드

---

## 🆘 문제 해결

| 문제 | 해결책 |
|------|--------|
| 404 에러 | `.htaccess` 파일 확인 |
| CSS/JS 로드 안됨 | 파일 경로 확인, 파일 권한 확인 |
| 한글 깨짐 | UTF-8 인코딩 확인, `.htaccess` 확인 |

---

**📚 상세 가이드는 `CLOUDWAYS_DEPLOY_DETAILED.md` 참고**