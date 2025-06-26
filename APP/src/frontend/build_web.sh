#!/bin/bash

# KingFisher Web用ビルドスクリプト
# 全ブラウザ対応版（Chrome、Safari、Edge、Firefox、Yahoo!ブラウザ、Opera）

echo "🚀 KingFisher Webアプリケーションをビルドしています..."

# 依存関係を更新
echo "📦 依存関係を更新中..."
flutter pub get

# 古いビルドファイルをクリーンアップ
echo "🧹 古いビルドファイルをクリーンアップ中..."
flutter clean

# Web用にビルド（ブラウザ互換性を考慮）
echo "🔨 Web用にビルド中..."
flutter build web \
  --release \
  --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
  --base-href "/" \
  --pwa-strategy offline-first \
  --optimization-level 4

# ビルドファイルをコピー
echo "Webサーバーに転送"
scp -r -i "/Users/akaishiyuuto/Desktop/CID/KingFisher.pem" /Users/akaishiyuuto/Desktop/KingFisher/APP/src/frontend/web akaishe@18.208.63.153:~/Win/

# ビルド結果を確認
if [ $? -eq 0 ]; then
    echo "✅ ビルドが完了しました！"
    echo "📁 ビルドファイル: build/web/"
    echo ""
    echo "🌐 デプロイ手順:"
    echo "1. build/web/ フォルダの内容をWebサーバーにアップロード"
    echo "2. サーバーで以下のMIMEタイプを設定:"
    echo "   - .js: application/javascript"
    echo "   - .wasm: application/wasm"
    echo "   - .json: application/json"
    echo "   - .css: text/css"
    echo "   - .html: text/html"
    echo ""
    echo "🔧 推奨サーバー設定:"
    echo "- gzip圧縮を有効にする"
    echo "- キャッシュヘッダーを適切に設定する"
    echo "- HTTPSを有効にする"
    echo "- CORS設定を適切に構成する"
    echo ""
    echo "📊 ブラウザ対応状況:"
    echo "- Chrome 80+ ✅"
    echo "- Safari 13+ ✅"
    echo "- Edge 80+ ✅"
    echo "- Firefox 75+ ✅"
    echo "- Yahoo!ブラウザ 80+ ✅"
    echo "- Opera 67+ ✅"
    echo ""
    echo "🔍 ブラウザ固有の最適化:"
    echo "- Firefox: CanvasKit無効化、スクロールバー最適化"
    echo "- Yahoo!ブラウザ: Chromeベース最適化"
    echo "- Safari: WebKit固有設定適用"
    echo "- Edge: Chromiumベース最適化"
    echo ""
    echo "⚠️  注意事項:"
    echo "- 古いブラウザでは警告メッセージが表示されます"
    echo "- 一部の機能はブラウザによって制限される場合があります"
    echo "- モバイルブラウザでも動作します"
else
    echo "❌ ビルドに失敗しました"
    exit 1
fi 