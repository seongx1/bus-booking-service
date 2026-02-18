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
2. `./scripts/build.sh` 실행
3. **SFTP**로 `dist/` 안 내용을 서버 `public_html/`에 업로드

끝.
