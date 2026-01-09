# 로컬 개발 환경 설정 가이드

## Slack Webhook 프록시 서버 (로컬 개발용)

로컬 환경(localhost)에서 개발할 때는 브라우저의 CORS 정책 때문에 Slack Webhook에 직접 요청을 보낼 수 없습니다. 이를 해결하기 위해 로컬 프록시 서버를 제공합니다.

### 프록시 서버 실행 방법

#### 방법 1: 스크립트 사용 (권장)

```bash
# 기본 포트(8888)로 실행
./scripts/start_proxy.sh

# 커스텀 포트로 실행
./scripts/start_proxy.sh 8888
```

#### 방법 2: Python 직접 실행

```bash
# 기본 포트(8888)로 실행
python3 scripts/slack_proxy.py

# 커스텀 포트로 실행
python3 scripts/slack_proxy.py 8888
```

### 프록시 서버 동작 방식

1. 프록시 서버는 `http://localhost:8888/slack-webhook` 엔드포인트에서 요청을 받습니다.
2. 요청을 받으면 CORS 헤더를 추가하여 브라우저에서 정상적으로 응답을 받을 수 있도록 합니다.
3. 실제 Slack Webhook URL로 요청을 프록시하여 전송합니다.

### 웹사이트 실행 방법

프록시 서버를 실행한 후, 별도의 터미널에서 웹사이트를 실행하세요:

#### 방법 1: 개발 서버 스크립트 사용 (권장) ⭐

```bash
# src/html/ 폴더에서 자동으로 서버 실행
./scripts/dev-server.sh

# 또는 커스텀 포트 지정
./scripts/dev-server.sh 8000
```

#### 방법 2: 수동 실행

```bash
# ⚠️ 중요: src/html/ 폴더로 이동 후 실행
cd src/html
python3 -m http.server 8000

# 또는 Node.js http-server 사용
cd src/html
npx http-server -p 8000
```

#### 접속 URL

서버 실행 후 브라우저에서 접속:
- **영어**: `http://localhost:8000/index_v2.html`
- **한국어**: `http://localhost:8000/index_v2_ko.html`
- **일본어**: `http://localhost:8000/index_v2_ja.html`
- **중국어**: `http://localhost:8000/index_v2_zh.html`

⚠️ **주의**: 루트에서 `python3 -m http.server`를 실행하면 404 에러가 발생합니다. 반드시 `src/html/` 폴더에서 실행하세요!

### 자동 환경 감지

웹사이트 코드는 자동으로 로컬 환경인지 배포 환경인지 감지합니다:

- **로컬 환경** (`localhost`, `127.0.0.1`): 프록시 서버 사용 (`http://localhost:8888/slack-webhook`)
- **배포 환경** (GitHub Pages 등): 직접 Slack Webhook URL 사용 (여러 방법 시도)

### 문제 해결

#### 프록시 서버가 시작되지 않을 때

```bash
# Python 3가 설치되어 있는지 확인
python3 --version

# 포트가 이미 사용 중인지 확인
lsof -i :8888

# 다른 포트로 실행
./scripts/start_proxy.sh 8889
```

#### CORS 에러가 계속 발생할 때

1. 프록시 서버가 실행 중인지 확인
2. 브라우저 콘솔에서 프록시 URL이 올바르게 감지되었는지 확인
3. 브라우저 캐시를 지우고 다시 시도

### 주의사항

- 프록시 서버는 **로컬 개발용**입니다. 배포 환경에서는 필요하지 않습니다.
- 프록시 서버를 실행하지 않으면 로컬 환경에서 Slack 메시지가 전송되지 않을 수 있습니다.
- 프록시 서버를 종료하려면 `Ctrl+C`를 누르세요.
