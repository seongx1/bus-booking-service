# 로컬 보관 (2026-03-04)

배포에 직접 쓰지 않는 파일·문서를 모아 둔 폴더입니다.  
실제 배포는 `src/` → `scripts/build.sh` → `scripts/deploy-to-cloudways.sh` 로 진행합니다.

## 포함 내용

- **docs/** – DEPLOY_GITHUB_ACTIONS.md, SLACK_TEST_REPORT.md (참고용)
- **scripts/** – cloudways-domain-prequel.sh, connect-domain-koreabuscharter.sh, deploy-now.sh (도메인 연결 시 참고)
- **deploy_files/** – 수정했던 deploy_files HTML 백업 (현재 배포는 src 기반)
- **.github/workflows/** – deploy-cloudways.yml (GitHub Actions 배포용, 필요 시 복사해 사용)
- **2026-02-26_도메인연결_SSL/** – 도메인/SSL 작업 정리
