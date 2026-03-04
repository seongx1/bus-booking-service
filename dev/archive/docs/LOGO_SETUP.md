# 로고 파일 설정 가이드

## 📋 필요한 로고 파일

웹사이트에 로고를 표시하려면 다음 두 개의 로고 파일이 필요합니다:

1. **`logo.png`** - 원형 버전 (Hero 섹션용)
2. **`logo-horizontal.png`** - 가로 버전 (네비게이션 바용)

## 📁 파일 위치

로고 파일들을 다음 위치에 저장하세요:

### 배포용 (deploy_files/)
```
/Volumes/choimacssd/너구리여행사 버스예약 서비스/deploy_files/
├── logo.png
└── logo-horizontal.png
```

### 프로젝트 루트
```
/Volumes/choimacssd/너구리여행사 버스예약 서비스/
├── logo.png
└── logo-horizontal.png
```

### Public 폴더 (GitHub Pages용)
```
/Volumes/choimacssd/너구리여행사 버스예약 서비스/public/
├── logo.png
└── logo-horizontal.png
```

## 🚀 배포 방법

### 방법 1: Netlify Drop (가장 빠름)
1. https://app.netlify.com/drop 접속
2. `deploy_files/` 폴더의 모든 파일을 드래그 앤 드롭
   - HTML 파일들 (index_v2.html, index_v2_ko.html, index_v2_zh.html, index_v2_ja.html)
   - styles_v2.css
   - script.js
   - config.js
   - **로고 파일들 (logo.png, logo-horizontal.png)**

### 방법 2: GitHub Pages
1. 로고 파일들을 프로젝트 루트에 추가
2. Git에 커밋 및 푸시:
   ```bash
   cd "/Volumes/choimacssd/너구리여행사 버스예약 서비스"
   git add logo.png logo-horizontal.png
   git add deploy_files/
   git commit -m "로고 추가 및 배포 파일 업데이트"
   git push origin main
   ```

## ✅ 현재 상태

- ✅ HTML 파일에 로고 코드 추가 완료
- ✅ CSS 스타일 적용 완료
- ✅ 배포 파일 업데이트 완료
- ⚠️ 로고 이미지 파일 추가 필요

## 📝 참고사항

- 로고 파일이 없으면 이미지가 표시되지 않지만, 웹사이트는 정상 작동합니다
- 로고 파일을 추가하면 자동으로 표시됩니다
- 모든 화면 크기에서 적절히 표시되도록 반응형 스타일이 적용되어 있습니다
