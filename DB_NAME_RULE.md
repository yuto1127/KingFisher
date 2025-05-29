# LaravelのModel / Factory / Migration / Seederの命名規則まとめ

## 🧩 1. Model の命名規則

| 項目 | 命名規則 | 例 |
|------|-----------|----|
| クラス名 | 単数形・パスカルケース | `User`, `OrderItem`, `HelpDesk` |
| ファイル名 | クラス名と同じ | `User.php`, `OrderItem.php` |
| テーブル名 | 複数形・スネークケース | `users`, `order_items`, `help_desks`（自動で推論） |

> 💡 テーブル名を明示的に指定したい場合は、`protected $table = 'custom_table_name';` をモデル内で指定。

---

## 🧪 2. Factory の命名規則

| 項目 | 命名規則 | 例 |
|------|-----------|----|
| クラス名 | モデル名 + `Factory` | `UserFactory`, `HelpDeskFactory` |
| ファイル名 | クラス名と同じ | `UserFactory.php` |
| 作成コマンド | `php artisan make:factory` | `php artisan make:factory UserFactory --model=User` |

> ✅ Laravel 8以降はクラスベースのファクトリに対応（`database/factories/` に配置）。

---

## 📜 3. Migration の命名規則

| 項目 | 命名規則 | 例 |
|------|-----------|----|
| ファイル名 | 動作 + テーブル名（複数形） | `create_users_table`, `add_status_to_orders_table` |
| クラス名 | パスカルケース | `CreateUsersTable`, `AddStatusToOrdersTable` |
| 作成コマンド | `php artisan make:migration` | `php artisan make:migration create_users_table` |

> 📌 テーブル定義は `Schema::create('users', function (Blueprint $table) { ... });` のように記述。

---

## 🌱 4. Seeder の命名規則

| 項目 | 命名規則 | 例 |
|------|-----------|----|
| クラス名 | モデル名 + `Seeder`（複数形が一般的） | `UsersTableSeeder`, `HelpDesksSeeder` |
| ファイル名 | クラス名と同じ | `UsersTableSeeder.php` |
| 実行コマンド | `php artisan db:seed --class=クラス名` | `php artisan db:seed --class=UsersTableSeeder` |
| 作成コマンド | `php artisan make:seeder` | `php artisan make:seeder UsersTableSeeder` |

> 🧠 複数のSeederをまとめたい場合は、`DatabaseSeeder` で `call()` を使って指定。

---

## 🔄 命名の対応関係（早見表）

| 種別 | クラス名 | ファイル名 | 対応するテーブル名 |
|------|----------|-------------|--------------------|
| Model | `User` | `User.php` | `users` |
| Factory | `UserFactory` | `UserFactory.php` | - |
| Migration | `CreateUsersTable` | `create_users_table.php` | `users` |
| Seeder | `UsersTableSeeder` | `UsersTableSeeder.php` | `users` |

---

## 📌 注意ポイントまとめ

- モデル名は **単数形**、テーブル名は **複数形** が原則。
- 命名規則に従うと、Laravelの **自動推論（convention over configuration）** によって効率的に開発できる。
- Laravel 8以降は、Factory はクラス形式。
- テーブル名・外部キー・リレーションの自動推論は **命名規則に依存**。