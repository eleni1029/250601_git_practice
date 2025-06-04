#!/bin/bash

# 🚀 FastAPI + Git + Railway 部署工具
# 使用方式：bash deploy.sh

clear

# 預設為 2（整個專案更新）
echo "=============================="
echo "🚀 Git 自動部署工具"
echo "=============================="
echo "請選擇操作方式（預設為 2）："
echo "1) 更新單一檔案"
echo "2) 更新整個專案資料夾"
echo
read -p "請輸入 1 或 2 並按 Enter: " mode
mode=${mode:-2}  # 預設為 2

# 檢查 Git 狀態
if [ ! -d .git ]; then
  echo "❌ 當前資料夾不是 Git 倉庫，請先執行 git init"
  exit 1
fi

# 確保 Git 已設定遠端
remote_url=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote_url" ]; then
  echo "❌ 尚未設定 Git 遠端，請使用 git remote add origin <URL> 設定"
  exit 1
fi

# 確保有變更可提交
if [ -z "$(git status --porcelain)" ]; then
  echo "⚠️ 沒有任何檔案變更，無需提交。請先修改檔案再執行本工具。"
  exit 0
fi

if [ "$mode" = "1" ]; then
  read -p "請輸入要更新的檔案路徑（例如 main.py 或 docs/index.html）: " filepath
  if [ ! -f "$filepath" ]; then
    echo "❌ 找不到檔案：$filepath"
    exit 1
  fi
  git add "$filepath"
  read -p "請輸入 commit 訊息（預設為：常規更新）: " msg
  msg=${msg:-常規更新}
  git commit -m "$msg"
  git push origin main || { echo "❌ 推送失敗，請確認網路或權限問題。"; exit 1; }
  echo "✅ 單一檔案 $filepath 已提交並推送至 GitHub"

elif [ "$mode" = "2" ]; then
  git add .
  read -p "請輸入 commit 訊息（預設為：常規更新）: " msg
  msg=${msg:-常規更新}
  git commit -m "$msg"
  git push origin main || { echo "❌ 推送失敗，請確認網路或權限問題。"; exit 1; }
  echo "✅ 整個專案已提交並推送至 GitHub"
else
  echo "❌ 無效選項，請輸入 1 或 2"
  exit 1
fi

# 結束提示
echo "🎉 Railway 將自動重新部署，請稍候 1~2 分鐘查看結果。"