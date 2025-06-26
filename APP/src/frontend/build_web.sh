#!/bin/bash

# KingFisher Web用ビルドスクリプト
# 全ブラウザ対応版（Chrome、Safari、Edge、Firefox、Yahoo!ブラウザ、Opera）
# モバイルデバイス対応強化版

echo "🚀 KingFisher Webアプリケーションをビルドしています..."

# 依存関係を更新
echo "📦 依存関係を更新中..."
flutter pub get

# 古いビルドファイルをクリーンアップ
echo "🧹 古いビルドファイルをクリーンアップ中..."
flutter clean

# Web用にビルド（モバイルデバイス対応強化）
echo "🔨 Web用にビルド中（モバイル対応強化）..."
flutter build web \
  --release \
  --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
  --base-href "/" \
  --pwa-strategy offline-first \
  --optimization-level 4 \
  --source-maps

# ビルド結果を確認
if [ $? -eq 0 ]; then
    echo "✅ ビルドが完了しました！"
    echo "📁 ビルドファイル: build/web/"
    # 自動アップロード
    scp -r -i "/Users/akaishiyuuto/Desktop/CID/KingFisher.pem" /Users/akaishiyuuto/Desktop/KingFisher/APP/src/frontend/web/ akaishe@18.208.63.153:/var/www/html/
    echo ""
    echo "🌐 デプロイ手順:"
    echo "1. build/web/ フォルダの内容をWebサーバーにアップロード"
    echo "   例: rsync -avz build/web/ ユーザー名@サーバーIP:/var/www/html/"
    echo "   または: scp -r build/web/* ユーザー名@サーバーIP:/var/www/html/"
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
    echo "- モバイルデバイス用のビューポート設定を確認する"
    echo ""
    echo "📱 モバイルデバイス対応:"
    echo "- スマートフォン（iOS/Android）✅"
    echo "- タブレット（iPad/Android）✅"
    echo "- プライベートブラウジングモード対応✅"
    echo "- タッチ操作最適化✅"
    echo "- ネットワーク接続診断✅"
    echo "- ローカルストレージ代替手段✅"
    echo ""
    echo "📊 ブラウザ対応状況:"
    echo "- Chrome 80+ ✅"
    echo "- Safari 13+ ✅"
    echo "- Edge 80+ ✅"
    echo "- Firefox 75+ ✅"
    echo "- Yahoo!ブラウザ 80+ ✅"
    echo "- Opera 67+ ✅"
    echo "- モバイルChrome ✅"
    echo "- モバイルSafari ✅"
    echo "- モバイルFirefox ✅"
    echo "- Samsung Internet ✅"
    echo ""
    echo "🔍 ブラウザ固有の最適化:"
    echo "- Firefox: CanvasKit無効化、スクロールバー最適化"
    echo "- Yahoo!ブラウザ: Chromeベース最適化"
    echo "- Safari: WebKit固有設定適用"
    echo "- Edge: Chromiumベース最適化"
    echo "- モバイル: タッチ操作、ビューポート最適化"
    echo ""
    echo "⚠️  注意事項:"
    echo "- 古いブラウザでは警告メッセージが表示されます"
    echo "- 一部の機能はブラウザによって制限される場合があります"
    echo "- モバイルブラウザでも動作します"
    echo "- プライベートブラウジングモードでは一部機能が制限されます"
    echo "- データセーバーが有効な場合はパフォーマンスが低下する場合があります"
else
    echo "❌ ビルドに失敗しました"
    exit 1
fi 