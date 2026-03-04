# Cloudways API 간단 가이드

## 인증키 발급

1. [Cloudways](https://platform.cloudways.com) 로그인 → 왼쪽 아래 **메뉴** → **API Integration**
2. **Generate Key** 클릭 → **API 키** 복사
3. 사용하는 **이메일** + **API 키** 두 개만 있으면 됨

---

## API로 되는 것 / 안 되는 것

- **됨:** 서버·앱 조회, Git 배포 트리거
- **안 됨:** 파일 업로드 → **SFTP**나 **Git 연동**으로 올려야 함

---

## 사용법

```bash
# 환경 변수 설정 (한 번만)
export CLOUDWAYS_EMAIL="your@email.com"
export CLOUDWAYS_API_KEY="발급한_API_키"

# 서버 목록
./scripts/cloudways-api.sh servers

# 서버 1574100 앱 조회
./scripts/cloudways-api.sh apps 1574100

# 기존 서버에 새 앱 추가 (이름에 공백 가능)
./scripts/cloudways-api.sh create-app 1574100 "Korea bus charter"
```

---

## 배포 흐름 (요약)

1. 대시보드에서 **앱 1회 생성** (Generic PHP 등)
2. **한 번에 빌드 + SFTP 업로드:** `.env`에 아래 변수 설정 후
   ```bash
   ./scripts/deploy-to-cloudways.sh
   ```
   - `CLOUDWAYS_EMAIL`, `CLOUDWAYS_API_KEY` → 서버 IP 자동 조회(선택)
   - `CLOUDWAYS_SFTP_USER`, `CLOUDWAYS_SFTP_PASSWORD` → 자동 업로드 **필수**
   - `CLOUDWAYS_SFTP_HOST` 비우면 API로 서버 IP 조회
3. `.env` 없거나 SFTP 미설정 시: `./scripts/build.sh` 실행 후 **수동**으로 `dist/` 내용을 SFTP로 `public_html/`에 업로드

**GitHub Actions로 반영:** 저장소 Secrets에 `CLOUDWAYS_SFTP_HOST`, `CLOUDWAYS_SFTP_USER`, `CLOUDWAYS_SFTP_PASSWORD` 등록 후 푸시하면 자동 배포. → [DEPLOY_GITHUB_ACTIONS.md](DEPLOY_GITHUB_ACTIONS.md)

끝.

---

## 도메인 연결

- **도메인 연결 전단계**부터 정리한 가이드: [CLOUDWAYS_DOMAIN_SETUP.md](CLOUDWAYS_DOMAIN_SETUP.md)
- 서버 IP 조회: `./scripts/cloudways-api.sh server-ip 1574100` → DNS A 레코드에 사용
- 한 번에 체크리스트 + IP 확인: `./scripts/cloudways-domain-prequel.sh`
