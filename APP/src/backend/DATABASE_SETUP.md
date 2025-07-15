# KingFisher Database Setup

## 概要
このドキュメントでは、KingFisherアプリケーションのデータベースセットアップ手順を説明します。

## 前提条件
- PHP 8.1以上
- Composer
- MySQL 8.0以上
- Laravel 10.x

## セットアップ手順

### 1. 環境設定
```bash
# .envファイルをコピー
cp .env.example .env

# アプリケーションキーを生成
php artisan key:generate

# .envファイルでデータベース設定を確認
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=KingFisher
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### 2. 依存関係のインストール
```bash
composer install
```

### 3. データベースセットアップ

#### 方法1: 自動セットアップスクリプト（推奨）
```bash
# スクリプトに実行権限を付与
chmod +x setup-database.sh

# セットアップスクリプトを実行
./setup-database.sh
```

#### 方法2: 手動セットアップ
```bash
# マイグレーションを実行
php artisan migrate

# シーダーを順番に実行
php artisan db:seed --class=RolesSeeder
php artisan db:seed --class=UsersSeeder
php artisan db:seed --class=UserPassesSeeder
php artisan db:seed --class=HelpDesksSeeder
php artisan db:seed --class=CustomersSeeder
php artisan db:seed --class=EventsSeeder
php artisan db:seed --class=EntryStatusesSeeder
php artisan db:seed --class=PointsSeeder
```

## トラブルシューティング

### よくあるエラーと解決方法

#### 1. マイグレーションエラー
**エラー**: `Column already exists: event_id`
**原因**: マイグレーション履歴と実際のテーブル構造が不一致
**解決方法**:
```bash
# マイグレーション履歴をリセット
php artisan migrate:reset

# または、特定のマイグレーションを削除
php artisan tinker --execute="DB::table('migrations')->where('migration', '2025_06_25_022419_remove_event_id_from_entry_statuses_table')->delete();"
```

#### 2. シーダーエラー
**エラー**: `Duplicate entry for key`
**原因**: 重複データの挿入
**解決方法**: シーダーは`updateOrCreate`を使用するように修正済みです。

#### 3. モデルが見つからないエラー
**エラー**: `Target class [Database\Seeders\Points] does not exist`
**原因**: クラス名の指定ミス
**解決方法**: 正しいクラス名を使用（例: `PointsSeeder`）

## データベース構造

### 主要テーブル
- `users` - ユーザー情報
- `roles` - ロール情報
- `user_passes` - ユーザー認証情報
- `help_desks` - ヘルプデスク情報
- `customers` - 顧客情報
- `events` - イベント情報
- `entry_statuses` - 入退場状況
- `points` - ポイント情報
- `lost_items` - 忘れ物情報

## 開発時の注意事項

### マイグレーション作成時
1. マイグレーションファイル名は日時を含める
2. `up()`と`down()`メソッドの整合性を保つ
3. 外部キー制約の存在チェックを行う

### シーダー作成時
1. `updateOrCreate`を使用して重複を避ける
2. 依存関係のあるデータは順序を考慮する
3. エラーハンドリングを適切に行う

## 本番環境での注意事項

1. データベースのバックアップを定期的に取得
2. マイグレーション実行前にテスト環境で検証
3. シーダーは本番環境では慎重に実行

## サポート

問題が発生した場合は、以下を確認してください：
1. Laravel のログファイル (`storage/logs/laravel.log`)
2. データベースのエラーログ
3. マイグレーション履歴 (`php artisan migrate:status`) 