# 로고 파일 저장 안내

## 📁 저장할 위치

로고 파일을 다음 위치에 저장해야 합니다:

1. **프로젝트 루트**
   - `logo.png` (원형 버전)
   - `logo-horizontal.png` (가로 버전)

2. **deploy_files/ 폴더**
   - `deploy_files/logo.png`
   - `deploy_files/logo-horizontal.png`

3. **public/ 폴더**
   - `public/logo.png`
   - `public/logo-horizontal.png`

## 🔧 저장 방법

### 방법 1: 파일 경로 제공
이미지 파일의 경로를 알려주시면 자동으로 복사해드리겠습니다.

예:
- `/Users/username/Downloads/logo.png`
- `/Users/username/Desktop/logo-horizontal.png`

### 방법 2: 직접 저장
로고 파일을 다음 위치에 직접 저장하세요:

1. 원형 버전: `logo.png`
2. 가로 버전: `logo-horizontal.png`

그런 다음 다음 명령어로 모든 위치에 복사:

```bash
cd "/Volumes/choimacssd/너구리여행사 버스예약 서비스"

# 원형 버전 복사
cp logo.png deploy_files/
cp logo.png public/

# 가로 버전 복사
cp logo-horizontal.png deploy_files/
cp logo-horizontal.png public/
```

### 방법 3: 자동 스크립트 사용
`save_logos.sh` 스크립트를 사용:

```bash
./save_logos.sh ~/Downloads/logo.png logo.png
./save_logos.sh ~/Downloads/logo-horizontal.png logo-horizontal.png
```

## ✅ 확인

파일이 제대로 저장되었는지 확인:

```bash
ls -lh logo*.png
ls -lh deploy_files/logo*.png
ls -lh public/logo*.png
```

## 🚀 배포

로고 파일이 저장되면 바로 웹에 배포할 수 있습니다!
