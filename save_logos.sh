#!/bin/bash
# 로고 파일 저장 스크립트

PROJECT_ROOT="/Volumes/choimacssd/너구리여행사 버스예약 서비스"

# 로고 파일 저장 함수
save_logo() {
    local source_file=$1
    local dest_name=$2
    
    if [ -f "$source_file" ]; then
        # 프로젝트 루트에 저장
        cp "$source_file" "$PROJECT_ROOT/$dest_name"
        echo "✅ $dest_name (프로젝트 루트) 저장 완료"
        
        # deploy_files에 복사
        cp "$source_file" "$PROJECT_ROOT/deploy_files/$dest_name"
        echo "✅ $dest_name (deploy_files) 저장 완료"
        
        # public에 복사
        cp "$source_file" "$PROJECT_ROOT/public/$dest_name"
        echo "✅ $dest_name (public) 저장 완료"
        
        return 0
    else
        echo "❌ 파일을 찾을 수 없습니다: $source_file"
        return 1
    fi
}

echo "로고 파일 저장 준비 완료!"
echo "사용법: save_logo <원본파일경로> <저장할파일명>"
echo "예: save_logo ~/Downloads/logo.png logo.png"
