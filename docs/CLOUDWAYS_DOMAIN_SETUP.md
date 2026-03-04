# Cloudways 도메인 연결 가이드

도메인 연결 **현재 상태**와 **연결 전단계**까지 정리한 문서입니다.

---

## 1. 현재 상태 (프로젝트 기준)

| 항목 | 값 |
|------|-----|
| **서버 ID** | `1574100` |
| **앱 이름** | Korea bus charter |
| **앱 시스템 경로** | `applications/tjjsevvqfe/public_html` |
| **임시 URL** | https://phpstack-1574100-6221145.cloudwaysapps.com/ |
| **운영 도메인** | https://koreabuscharter.com/ |
| **배포 방법** | SFTP → `public_html/` (또는 `./scripts/deploy-to-cloudways.sh`) |

- **도메인 연결 전**: 위 임시 URL로만 접속 가능합니다.
- **도메인 연결 후**: `https://koreabuscharter.com` 등으로 접속 가능 (DNS + SSL 설정 필요).  
  **도메인 연결 후 슬랙 알림이 안 오면** → [도메인 연결 후 슬랙 복구](SLACK_PROXY_SETUP.md#도메인-연결-후-슬랙-메시지가-안-갈-때-복구) 참고.

---

## 2. 현재 상태 확인 방법 (실서버 기준)

실제 서버 정보·앱 목록·**공용 IP**는 Cloudways API로 조회할 수 있습니다.

### 2.1 환경 변수 설정

`.env` 파일에 다음이 있어야 합니다 (없으면 `cp .env.example .env` 후 입력).

```bash
CLOUDWAYS_EMAIL=your@email.com
CLOUDWAYS_API_KEY=발급한_API_키
```

- API 키 발급: [Cloudways](https://platform.cloudways.com) 로그인 → 왼쪽 아래 **메뉴** → **API Integration** → **Generate Key**

### 2.2 조회 명령

```bash
# 터미널에서 프로젝트 루트로 이동 후
export CLOUDWAYS_EMAIL="your@email.com"   # 또는 .env 로드
export CLOUDWAYS_API_KEY="your_api_key"

# 서버 목록
./scripts/cloudways-api.sh servers

# 이 서버의 앱 목록·상세
./scripts/cloudways-api.sh apps 1574100

# ★ 도메인 DNS 설정에 쓸 서버 공용 IP만 출력
./scripts/cloudways-api.sh server-ip 1574100
```

- **도메인 연결 전단계**에서 DNS A 레코드에 넣을 값은 위 `server-ip` 출력값입니다.
- `.env`가 있으면 `./scripts/cloudways-domain-prequel.sh` 로 한 번에 체크리스트 + IP 조회 가능 (아래 4절).

---

## 3. 도메인 연결 전단계 체크리스트

아래를 순서대로 진행하면 **도메인 연결 직전**까지 준비됩니다.

### 3.1 준비물

- [ ] **도메인** 보유 (가비아, 후이즈, Namecheap, Cloudflare 등)
- [ ] **Cloudways 로그인** 가능
- [ ] (선택) 프로젝트 `.env`에 `CLOUDWAYS_EMAIL`, `CLOUDWAYS_API_KEY` 설정 → 터미널에서 서버 IP 조회용

### 3.2 서버 공용 IP 확보

**방법 A – 터미널 (API)**

```bash
export CLOUDWAYS_EMAIL="your@email.com"
export CLOUDWAYS_API_KEY="your_api_key"
./scripts/cloudways-api.sh server-ip 1574100
```

출력된 IP를 메모 (예: `123.45.67.89`).

**방법 B – Cloudways 대시보드**

1. [Cloudways 대시보드](https://platform.cloudways.com) 로그인
2. 해당 **서버(1574100)** 선택
3. **Master Credentials** 또는 서버 상세에서 **Public IP** 확인

→ 이 IP를 **DNS A 레코드**에 사용합니다.

### 3.3 DNS 설정값 정리 (도메인 등록 기관에서 할 일)

도메인 등록 기관의 DNS 관리 페이지에서 아래처럼 설정할 예정입니다.

| 타입 | 호스트 | 값(Points to) | TTL |
|------|--------|----------------|-----|
| **A** | `@` (또는 비움) | **위에서 확보한 서버 공용 IP** | 3600 |
| **A** | `www` | **위와 동일한 서버 공용 IP** | 3600 |

- `www`만 쓸 경우: A 레코드 `www` → 서버 IP  
- 루트(`@`)만 쓸 경우: A 레코드 `@` → 서버 IP  
- 둘 다 쓸 경우: 위 두 개 모두 추가 (또는 `www`를 CNAME으로 `yourdomain.com`에 연결해도 됨).

**정리:**  
- **서버 공용 IP** = `./scripts/cloudways-api.sh server-ip 1574100` 출력값 (또는 대시보드 Public IP)  
- 이 IP를 **도메인 연결 전단계**에서 반드시 확보해 두세요.

### 3.4 Cloudways 대시보드에서 할 일 (연결 직전 단계)

1. Cloudways 대시보드 → **애플리케이션 관리** (Korea bus charter 앱 선택)
2. **도메인 관리(Domain Management)** 메뉴
3. **도메인 추가(Add Domain)** 클릭
4. 사용할 도메인 입력 (예: `noguribus.com`) → **추가**

→ 여기까지가 **도메인 연결 전단계**입니다.  
이후 **도메인 등록 기관에서 위 3.3 대로 A 레코드 설정** → DNS 전파 후 접속 확인 → **SSL 인증서 설치**(`docs/CLOUDWAYS_DEPLOY_SUMMARY.md` 4단계 참고).

---

## 4. 전단계 한 번에 확인 (스크립트)

`.env`에 `CLOUDWAYS_EMAIL`, `CLOUDWAYS_API_KEY`가 있으면 아래 스크립트로 **체크리스트 + 서버 IP**를 한 번에 볼 수 있습니다.

```bash
./scripts/cloudways-domain-prequel.sh
```

- 서버 IP가 출력되면 그 값을 DNS A 레코드에 사용하면 됩니다.
- `.env`가 없거나 API 키가 없으면 IP 없이 체크리스트만 출력됩니다.

---

## 5. 도메인 관리 (Primary / Alias)

Cloudways **Domain Management**에서:

| 도메인 | 유형 | 비고 |
|--------|------|------|
| `phpstack-1574100-6221145.cloudwaysapps.com` | **Primary** | 앱 기본 URL |
| `koreabuscharter.com` | Alias | 커스텀 도메인 |
| `www.koreabuscharter.com` | Alias | www 서브도메인 |

- **Primary** = 애플리케이션의 기본 도메인(DB base URL 등에 사용).
- **Alias** = 같은 앱의 같은 `public_html`을 가리키므로, 슬랙 프록시·설정 파일은 **한 번만** 올리면 두 도메인 모두 동작합니다.
- 운영 도메인을 메인으로 쓰려면: 도메인 목록 옆 **⋮** → **Set as Primary** 로 `koreabuscharter.com`을 Primary로 바꿀 수 있습니다. (선택 사항)

---

## 6. 다음 단계 (도메인 연결 이후)

- **DNS 전파 대기** (보통 5분~24시간)
- **SSL 인증서 설치**: 대시보드 → 애플리케이션 관리 → **SSL 인증서** → Let's Encrypt 설치
- **HTTPS 접속 확인**: `https://koreabuscharter.com`

자세한 배포·SSL 절차는 아래 문서를 참고하세요.

- [Cloudways 배포 요약](CLOUDWAYS_DEPLOY_SUMMARY.md)
- [Cloudways 배포 상세](CLOUDWAYS_DEPLOY_DETAILED.md)
