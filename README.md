# KingFisher - 2025年度専攻研究用

## 実施作業

1. **リポジトリをリモートにクローン**
   - プロジェクトのリポジトリをリモートからクローンします。

2. **Reactの環境構築**
   - プロジェクトは作成せずに、Reactの環境を構築します。

3. **PHP、Laravelの環境構築**
   - プロジェクトは作成せずに、PHPとLaravelの環境を構築します。

4. **MySQLのインストール**
   - MySQLをインストールします。



my-app/
├── public/                  # 静的ファイル（画像、favicon など）
├── src/
│   ├── assets/              # 画像やフォントなどのアセット
│   ├── components/          # UI部品などの共通コンポーネント
│   │   └── common/          # 汎用ボタンや入力フィールドなど
│   │   └── layout/          # Header, Footer, Sidebarなど
│   ├── features/            # 機能単位でまとめる（Domainごと）
│   │   └── user/            # 例：ユーザー機能関連（UserList.tsxなど）
│   │   └── event/           # 例：イベント機能関連
│   ├── pages/               # ルーティングされるページコンポーネント（React Router）
│   │   └── Home.tsx
│   │   └── About.tsx
│   ├── routes/              # React Router のルート定義ファイル
│   │   └── index.tsx
│   ├── hooks/               # カスタムフック
│   ├── utils/               # 汎用関数やユーティリティ
│   ├── types/               # 型定義（interface や type）
│   ├── services/            # API通信（Axios などを使う層）
│   ├── store/               # グローバルステート管理（Redux, Zustandなど）
│   ├── App.tsx              # ルートコンポーネント
│   └── main.tsx             # エントリーポイント
├── .env                     # 環境変数
├── .gitignore
├── package.json
└── tsconfig.json

## 実装機能
____
# ホーム画面
会員証（QRコード）
ニックネーム

# フロアマップ
会場の全体マップ

# インフォメーション
現在開催イベントの表示

# QRリーダー
QRコード（会員証）
保有ポイント
QRリーダー

# ログイン
新規登録
ログイン
