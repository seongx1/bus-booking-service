# 프로젝트 보관 (archive)

배포에 직접 쓰지 않는 문서·스크립트·과거 파일을 모아 둔 폴더입니다.

## 구조

- **docs/** – 참고용 문서 (배포는 `docs/` 루트의 4개 문서 기준)
- **2026-03-04/** – 슬랙/캐시 정리 당시 백업 (deploy_files 수정본, GitHub Actions 등)
- **2026-02-26_도메인연결_SSL/** – 도메인·SSL 작업 정리
- **scripts/** – (비어 있음. 필요 시 도메인 연결용 스크립트 등)
- **기타/** – Cloudways 배포 zip, archive, temp_deploy 등

## 실제 배포

- 소스: `src/`
- 빌드: `scripts/build.sh`
- 배포: `scripts/deploy-to-cloudways.sh` (Cloudways SFTP)
- 슬랙 복구: `scripts/restore-slack-on-cloudways.sh`
