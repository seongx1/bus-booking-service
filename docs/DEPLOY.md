# 웹사이트 배포 가이드 (Cloudways)

이 프로젝트는 **Cloudways**로만 배포합니다. GitHub Pages는 사용하지 않습니다.

## 배포 절차

**한 번에 배포 (권장)**  
`.env`에 `CLOUDWAYS_SFTP_HOST`, `CLOUDWAYS_SFTP_USER`, `CLOUDWAYS_SFTP_PASSWORD`를 넣은 뒤:
```bash
./scripts/deploy-to-cloudways.sh
```
→ 빌드 후 자동으로 SFTP 업로드됩니다.

**수동 업로드**
1. `./scripts/deploy-cloudways.sh` 로 빌드
2. `dist/` 폴더 **안의 모든 파일**을 SFTP로 Cloudways 앱 **`/public_html/`** 에 업로드 (FileZilla, WinSCP 등)

3. **자세한 가이드**
   - [Cloudways 배포 요약](CLOUDWAYS_DEPLOY_SUMMARY.md)
   - [Cloudways 배포 상세](CLOUDWAYS_DEPLOY_DETAILED.md)
   - [Cloudways API/CLI 가이드](CLOUDWAYS_API_CLI_GUIDE.md)

## 참고사항

- `config.js`는 보안상 GitHub에 포함되지 않습니다. 배포 서버에서 별도 설정합니다.
- Slack Webhook URL은 배포 후 서버 환경 또는 HTML 주입으로 설정합니다.

## (참고) GitHub Pages

GitHub Pages는 **폐쇄**되었습니다. 기존에 Pages를 사용 중이었다면, 저장소 **Settings → Pages**에서 Source를 **None**으로 설정해 두세요.
