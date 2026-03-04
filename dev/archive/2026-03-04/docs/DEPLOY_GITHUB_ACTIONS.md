# GitHub Actions로 자동 배포

`main` 또는 `master` 브랜치에 푸시하거나, Actions에서 **Deploy to Cloudways** 워크플로를 수동 실행하면 **빌드 후 SFTP로 Cloudways에 자동 업로드**됩니다.

## 1. 시크릿 등록 (한 번만)

저장소 **Settings** → **Secrets and variables** → **Actions** → **New repository secret** 에서 아래 3개 추가:

| 이름 | 설명 |
|------|------|
| `CLOUDWAYS_SFTP_HOST` | 서버 공용 IP (로컬에서 `./scripts/cloudways-api.sh server-ip 1574100` 로 조회 가능) |
| `CLOUDWAYS_SFTP_USER` | Cloudways SFTP 사용자명 |
| `CLOUDWAYS_SFTP_PASSWORD` | Cloudways SFTP 비밀번호 |

선택:

| 이름 | 설명 |
|------|------|
| `CLOUDWAYS_SFTP_REMOTE_PATH` | 원격 경로 (기본: `applications/tjjsevvqfe/public_html`) |
| `SLACK_WEBHOOK_URL` | Slack Webhook URL (설정 시 서버에 `slack_webhook_config.php` 자동 생성·업로드 → 폼 제출 시 슬랙 알림) |

## 2. 배포 트리거

- **푸시 시:** `main` 또는 `master`에 push 하면 자동으로 빌드 + 업로드
- **수동:** Actions 탭 → **Deploy to Cloudways** → **Run workflow**

## 3. 시크릿 없을 때

시크릿을 등록하지 않았으면 업로드 단계는 건너뛰고, 빌드만 수행됩니다.  
나중에 시크릿을 추가한 뒤 다시 푸시하거나 수동 실행하면 그때부터 자동 배포됩니다.
