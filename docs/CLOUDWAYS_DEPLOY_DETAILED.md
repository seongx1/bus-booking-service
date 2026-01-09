# 📖 Cloudways 배포 가이드 (상세)

너구리여행사 버스예약 서비스를 Cloudways에 배포하는 완전한 가이드입니다.

---

## 📋 목차

1. [사전 준비사항](#사전-준비사항)
2. [Cloudways 계정 설정](#cloudways-계정-설정)
3. [서버 생성](#서버-생성)
4. [애플리케이션 설정](#애플리케이션-설정)
5. [파일 업로드](#파일-업로드)
6. [도메인 연결](#도메인-연결)
7. [SSL 인증서 설치](#ssl-인증서-설치)
8. [최적화 및 보안](#최적화-및-보안)
9. [문제 해결](#문제-해결)
10. [유지보수](#유지보수)

---

## 사전 준비사항

### 필수 요구사항

- ✅ **Cloudways 계정** ([www.cloudways.com](https://www.cloudways.com) 가입)
- ✅ **도메인** (선택사항이지만 권장)
- ✅ **로컬 빌드 환경** (빌드 스크립트 실행 가능)
- ✅ **SFTP 클라이언트** (FileZilla, WinSCP, Cyberduck 등)

### 권장 사양

- **서버**: 최소 1GB RAM (2GB 권장)
- **클라우드**: Vultr 서울 리전 (한국 접속 속도 향상)
- **애플리케이션**: Generic PHP 또는 Custom PHP

---

## Cloudways 계정 설정

### 1. 회원가입

1. [Cloudways 공식 웹사이트](https://www.cloudways.com) 접속
2. **"START FREE"** 또는 **"무료 체험 시작"** 클릭
3. 이메일, 비밀번호로 계정 생성
4. 프로모션 코드 입력 (선택사항)
   - 예: `BENE10` (3개월간 매월 10% 할인)

### 2. 결제 정보 등록

- 신용카드 또는 PayPal 등록
- 무료 체험 기간 동안 실제 결제는 발생하지 않음
- 일정 사용량 초과 시 자동 결제

---

## 서버 생성

### 1. 서버 추가

1. Cloudways 대시보드 로그인
2. 상단 메뉴에서 **"서버(Server)"** 클릭
3. **"+ 서버 추가(Add Server)"** 버튼 클릭

### 2. 클라우드 제공업체 선택

**권장 순서:**

1. **Vultr** (추천)
   - ✅ 서울 리전 지원
   - ✅ 한국 접속 속도 우수
   - ✅ 가격 경쟁력

2. **DigitalOcean**
   - ✅ 안정성 높음
   - ✅ 문서화 잘됨

3. **Linode**
   - ✅ 성능 우수

4. **AWS / Google Cloud**
   - ⚠️ 설정 복잡, 비용 높음

### 3. 서버 사양 선택

**최소 권장 사양:**
- **RAM**: 1GB (정적 웹사이트는 충분)
- **Storage**: 25GB
- **Bandwidth**: 1TB

**권장 사양:**
- **RAM**: 2GB
- **Storage**: 50GB
- **Bandwidth**: 2TB

### 4. 서버 위치 선택

- **한국 사용자**: Vultr Seoul (서울)
- **글로벌**: Singapore, Tokyo, Los Angeles

### 5. 애플리케이션 선택

정적 웹사이트 배포를 위해 다음 중 선택:

**옵션 1: Generic PHP** (추천)
- 간단한 PHP 환경
- 정적 파일 호스팅에 최적

**옵션 2: Custom PHP**
- 더 많은 제어 가능
- 고급 설정 필요 시

### 6. 서버 정보 입력

- **서버 이름**: `noguri-bus-reservation` (예시)
- **애플리케이션 이름**: `noguri-bus-web`
- **프로젝트 이름**: `Bus Reservation Service`

### 7. 서버 시작

1. 모든 정보 확인
2. **"서버 시작(Launch Now)"** 클릭
3. 서버 생성 대기 (약 5-7분)

---

## 애플리케이션 설정

### 1. 애플리케이션 정보 확인

서버 생성 완료 후:

1. 서버 목록에서 생성한 서버 클릭
2. **"애플리케이션 관리"** 탭 클릭
3. 애플리케이션 이름과 URL 확인

### 2. SFTP 접속 정보 확인

1. **"액세스 세부 정보(Access Details)"** 메뉴
2. **SFTP** 탭에서 다음 정보 확인:
   - **SFTP 호스트**: `서버IP`
   - **SFTP 포트**: `22`
   - **SFTP 사용자명**: 제공된 사용자명
   - **SFTP 비밀번호**: 제공된 비밀번호
   - **경로**: `/home/master/applications/앱이름/public_html/`

### 3. SSH 접속 정보 확인 (선택사항)

- SSH 접속 정보도 동일한 메뉴에서 확인 가능
- 고급 작업 시 필요

---

## 파일 업로드

### 방법 1: SFTP 클라이언트 사용 (추천)

#### 1단계: 로컬 빌드

```bash
# 프로젝트 루트 디렉토리에서
./scripts/build.sh
```

빌드 완료 후 `dist/` 폴더 확인:
```bash
ls -la dist/
```

#### 2단계: SFTP 연결

**FileZilla 사용 예시:**

1. FileZilla 실행
2. **파일 → 사이트 관리자** 클릭
3. 새 사이트 추가:
   - **호스트**: Cloudways 제공 SFTP 호스트
   - **포트**: `22`
   - **프로토콜**: SFTP
   - **로그인 유형**: 일반
   - **사용자명**: SFTP 사용자명
   - **비밀번호**: SFTP 비밀번호
4. **연결** 클릭

#### 3단계: 파일 업로드

1. 왼쪽(로컬): `dist/` 폴더로 이동
2. 오른쪽(원격): `/public_html/` 폴더로 이동
3. **모든 파일 선택** (Ctrl+A / Cmd+A)
4. **드래그 앤 드롭** 또는 **우클릭 → 업로드**

**업로드할 파일 목록:**
```
✅ index_v2.html
✅ index_v2_ko.html
✅ index_v2_ja.html
✅ index_v2_zh.html
✅ index.html
✅ script.js
✅ i18n.js
✅ styles_v2.css
✅ 모든 이미지 파일 (.png, .ico)
✅ .htaccess 파일 (프로젝트 루트에 있음)
```

#### 4단계: 파일 권한 확인

SSH 또는 Cloudways 파일 관리자에서:

```bash
# 모든 파일 권한 확인
chmod 644 /public_html/*
chmod 755 /public_html/
```

### 방법 2: Cloudways 파일 관리자 사용

1. Cloudways 대시보드 → **"애플리케이션 관리"**
2. **"파일 관리자"** 클릭
3. `/public_html/` 폴더로 이동
4. **"업로드"** 버튼 클릭
5. 로컬 파일 선택하여 업로드

⚠️ **주의**: 대용량 파일이나 많은 파일은 SFTP가 더 빠릅니다.

### 방법 3: SSH + Git (고급)

```bash
# SSH 접속
ssh 사용자명@서버IP

# 애플리케이션 디렉토리로 이동
cd /home/master/applications/앱이름/public_html/

# Git 저장소 클론 (GitHub에 업로드한 경우)
git clone https://github.com/yourusername/noguri-bus-reservation.git .

# 또는 rsync 사용 (로컬에서)
rsync -avz --exclude '.git' ./dist/ 사용자명@서버IP:/home/master/applications/앱이름/public_html/
```

---

## 도메인 연결

### 1. 도메인 준비

도메인이 없는 경우:
- [가비아](https://www.gabia.com)
- [후이즈](https://whois.co.kr)
- [Namecheap](https://www.namecheap.com)
- [Cloudflare](https://www.cloudflare.com)

### 2. Cloudways에서 도메인 추가

1. Cloudways 대시보드 → **"애플리케이션 관리"**
2. **"도메인 관리(Domain Management)"** 메뉴
3. **"도메인 추가(Add Domain)"** 클릭
4. 도메인 입력 (예: `noguribus.com`)
5. **"추가"** 클릭

### 3. DNS 설정

도메인 등록 기관의 DNS 관리 페이지에서:

**A 레코드 추가:**
```
타입: A
호스트: @ (또는 비워둠)
값(Points to): Cloudways 서버 공용 IP
TTL: 3600 (또는 기본값)
```

**www 서브도메인 추가 (선택사항):**
```
타입: A
호스트: www
값(Points to): Cloudways 서버 공용 IP
TTL: 3600
```

**또는 CNAME 사용:**
```
타입: CNAME
호스트: www
값(Points to): yourdomain.com
TTL: 3600
```

### 4. DNS 전파 확인

DNS 변경사항이 전 세계에 전파되는 데 시간이 걸립니다 (보통 5분~24시간).

**확인 방법:**

```bash
# 터미널에서
nslookup yourdomain.com
dig yourdomain.com

# 또는 온라인 도구 사용
# https://www.whatsmydns.net
```

DNS 전파 완료 후 도메인으로 접속 가능합니다.

---

## SSL 인증서 설치

### 1. Let's Encrypt SSL 설치 (무료)

1. Cloudways 대시보드 → **"애플리케이션 관리"**
2. **"SSL 인증서(SSL Certificate)"** 메뉴
3. **"Let's Encrypt SSL 설치(Install Let's Encrypt SSL)"** 클릭

### 2. 인증서 정보 입력

- **도메인**: `yourdomain.com`
- **이메일**: 유효한 이메일 주소 (인증서 만료 알림용)
- **www 포함**: ✅ 체크 (www 포함 버전도 설치)

### 3. 인증서 설치

1. **"인증서 설치(Install Certificate)"** 클릭
2. 설치 완료 대기 (약 1-2분)

### 4. HTTPS 강제 설정

`.htaccess` 파일에 다음 추가 (이미 포함되어 있음):

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</IfModule>
```

### 5. SSL 인증서 갱신

Let's Encrypt 인증서는 90일마다 갱신 필요:
- Cloudways가 자동으로 갱신 (기본 설정)
- 수동 갱신: SSL 인증서 메뉴에서 **"갱신"** 클릭

---

## 최적화 및 보안

### 1. .htaccess 최적화

프로젝트에 포함된 `.htaccess` 파일이 다음을 포함:

✅ **GZIP 압축**: 파일 크기 감소로 로딩 속도 향상
✅ **브라우저 캐싱**: 재방문 시 빠른 로딩
✅ **보안 헤더**: XSS, 클릭재킹 방지
✅ **URL 리다이렉트**: 깔끔한 URL 구조

### 2. Cloudways CDN 설정 (선택사항)

1. Cloudways 대시보드 → **"확장 기능(Add-ons)"**
2. **"CloudwaysCDN"** 선택
3. 설정 완료 후 글로벌 CDN 활성화

### 3. 자동 백업 설정

1. **"백업 및 복원(Backup and Restore)"** 메뉴
2. **"백업 설정"** 클릭
3. 백업 주기 설정:
   - 매일 / 매주 / 매월
   - 보관 기간 설정

### 4. 모니터링 설정

Cloudways 대시보드에서:
- 서버 리소스 사용량 모니터링
- 응답 시간 확인
- 트래픽 분석

---

## 문제 해결

### 일반적인 문제

#### 1. 404 에러 - 페이지를 찾을 수 없음

**원인:**
- `.htaccess` 파일이 없거나 잘못됨
- 파일 경로 오류

**해결:**
```bash
# SSH 접속 후
cd /home/master/applications/앱이름/public_html/
ls -la .htaccess  # 파일 존재 확인
cat .htaccess     # 내용 확인
```

#### 2. CSS/JS 파일이 로드되지 않음

**원인:**
- 파일 경로 오류
- 파일이 업로드되지 않음
- 파일 권한 문제

**해결:**
```bash
# 파일 존재 확인
ls -la /public_html/*.css
ls -la /public_html/*.js

# 파일 권한 수정
chmod 644 /public_html/*.css
chmod 644 /public_html/*.js

# HTML 파일에서 경로 확인
grep -r "styles_v2.css" /public_html/*.html
```

#### 3. 한글 깨짐 문제

**원인:**
- 파일 인코딩 문제
- 서버 문자셋 설정

**해결:**
- `.htaccess` 파일에 `AddDefaultCharset UTF-8` 확인
- HTML 파일 `<meta charset="UTF-8">` 확인
- 파일 업로드 시 UTF-8 인코딩 확인

#### 4. 이미지가 표시되지 않음

**원인:**
- 이미지 파일 미업로드
- 파일 이름 인코딩 문제 (한글 파일명)

**해결:**
```bash
# 이미지 파일 확인
ls -la /public_html/*.png

# 한글 파일명 확인
ls -la /public_html/ | grep logo

# 필요 시 파일명 영문으로 변경
```

#### 5. SSL 인증서 설치 실패

**원인:**
- DNS 설정 미완료
- 도메인이 서버 IP를 가리키지 않음

**해결:**
```bash
# DNS 확인
nslookup yourdomain.com

# DNS가 올바르게 설정되었는지 확인
# A 레코드가 Cloudways 서버 IP를 가리켜야 함
```

#### 6. 느린 로딩 속도

**해결:**
- GZIP 압축 활성화 확인
- 이미지 최적화 (WebP 형식 사용 고려)
- CloudwaysCDN 활성화
- 불필요한 파일 제거

### 디버깅 도구

#### 브라우저 개발자 도구

1. **F12** 키로 개발자 도구 열기
2. **Network** 탭에서 로딩 문제 확인
3. **Console** 탭에서 JavaScript 오류 확인

#### SSH 접속하여 로그 확인

```bash
# Apache 에러 로그
tail -f /var/log/apache2/error.log

# 애플리케이션 로그
tail -f /home/master/applications/앱이름/logs/*.log
```

---

## 유지보수

### 정기 업데이트

#### 1. 파일 업데이트

```bash
# 로컬에서
./scripts/build.sh

# SFTP로 새 파일 업로드
# 또는 Git pull (SSH 사용 시)
```

#### 2. 백업 확인

- 정기적으로 백업이 생성되는지 확인
- 필요 시 수동 백업 생성

#### 3. 성능 모니터링

- Cloudways 대시보드에서 주기적으로 확인
- 트래픽 증가 시 서버 업그레이드 고려

### 업데이트 체크리스트

- [ ] 로컬에서 빌드 성공
- [ ] 모든 언어 버전 테스트
- [ ] 모바일 반응형 확인
- [ ] 이미지 및 리소스 로딩 확인
- [ ] 폼 제출 기능 확인 (Slack Webhook)
- [ ] SSL 인증서 유효성 확인

### 예비 계획

1. **다운타임 최소화**
   - 유지보수 시간대 선택 (트래픽 낮은 시간)
   - 업데이트 전 백업 생성

2. **롤백 계획**
   - 이전 버전 백업 보관
   - 빠른 롤백 방법 숙지

---

## 추가 리소스

### 공식 문서

- [Cloudways 공식 문서](https://support.cloudways.com/)
- [Cloudways API 문서](https://developers.cloudways.com/)

### 유용한 도구

- **DNS 확인**: [whatsmydns.net](https://www.whatsmydns.net)
- **SSL 확인**: [SSL Labs](https://www.ssllabs.com/ssltest/)
- **속도 테스트**: [GTmetrix](https://gtmetrix.com/)

---

## 체크리스트 요약

배포 완료 후 확인:

- [ ] 서버 생성 및 실행 중
- [ ] 모든 파일 업로드 완료
- [ ] `.htaccess` 파일 배치 완료
- [ ] 도메인 연결 및 DNS 전파 완료
- [ ] SSL 인증서 설치 완료
- [ ] HTTPS 접속 정상 작동
- [ ] 모든 언어 버전 접속 가능
- [ ] 모바일 반응형 정상 작동
- [ ] 폼 제출 기능 정상 작동
- [ ] 이미지 및 리소스 로딩 정상
- [ ] 백업 설정 완료
- [ ] 모니터링 설정 완료

---

**✅ 배포 완료!**

추가 질문이나 문제가 있으면 `CLOUDWAYS_DEPLOY_SUMMARY.md`의 요약 가이드를 참고하세요.