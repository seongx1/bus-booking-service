# 파일 구조 및 경로 정리 완료

## 📁 폴더 구조

```
너구리여행사 버스예약 서비스/
├── public/                    # 배포용 파일 (Vercel 등)
│   ├── index_v2*.html        # HTML 파일들
│   ├── styles_v2.css         # 스타일시트
│   ├── script.js             # JavaScript
│   ├── logo-가로.png         # 로고 이미지
│   └── favicon-*.png         # 파비콘 파일들
│
├── deploy_files/             # 배포 준비 파일
│   └── (public과 동일한 구조)
│
├── dist/                     # 빌드된 배포 파일
│   └── (public과 동일한 구조)
│
├── src/                      # 소스 파일
│   ├── html/                 # HTML 템플릿
│   │   └── index_v2*.html
│   ├── css/                  # 스타일시트
│   │   └── styles_v2.css
│   ├── js/                   # JavaScript
│   │   └── script.js
│   └── assets/
│       └── images/           # 이미지 및 파비콘
│           ├── logo-가로.png
│           └── favicon-*.png
│
└── archive/                  # 백업 파일
    └── favicon-sources/      # 파비콘 원본
```

## 🔗 경로 규칙

### public, deploy_files, dist 폴더
모든 리소스가 같은 폴더에 있으므로 **상대 경로** 사용:
- CSS: `styles_v2.css`
- JS: `script.js`
- 로고: `logo-가로.png`
- 파비콘: `favicon-32x32.png`

### src/html 폴더
소스 구조이므로 **상대 경로** 사용:
- CSS: `../css/styles_v2.css`
- JS: `../js/script.js`
- 로고: `../assets/images/logo-가로.png`
- 파비콘: `../assets/images/favicon-32x32.png`

## ✅ 정리 완료 사항

1. ✅ 파비콘 파일 생성 및 배치 완료
2. ✅ 모든 HTML 파일에 파비콘 링크 추가 완료
3. ✅ favicon-source.png 파일들 archive로 이동
4. ✅ 각 폴더별 경로 검증 완료
5. ✅ 필요한 리소스 파일 확인 완료

## 📝 참고사항

- 루트 폴더의 파비콘 파일들은 배포용으로 유지
- 각 배포 폴더(public, deploy_files, dist)는 독립적으로 작동 가능
- src 폴더는 개발용 소스 파일
