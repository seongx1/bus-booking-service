# Slack 웹훅 만드는 법 (간단)

## 1. Slack 접속

- [slack.com](https://slack.com) 로그인 → 워크스페이스 선택

## 2. Incoming Webhooks 앱 추가

1. 왼쪽 채널 목록 아래 **앱** 클릭 (또는 **추가**)
2. 검색창에 **Incoming Webhooks** 입력
3. **Incoming Webhooks** 선택 → **Slack에 추가** (또는 **추가**)
4. **Allow** / **허용** 클릭

## 3. 웹훅 만들기

1. **Add to Slack** (Slack에 추가) 클릭
2. **메시지를 받을 채널** 선택 (예: #견적문의) → **Incoming Webhooks 앱 추가** 클릭
3. 나오는 화면에서 **Webhook URL** 복사  
   - 형식: `https://hooks.slack.com/services/T.../B.../...`

## 4. 끝

복사한 URL을 홈페이지 설정에 넣으면, Get a Quote 폼 제출 시 그 채널로 메시지가 옵니다.  
(URL은 다른 사람에게 공유하지 마세요.)
