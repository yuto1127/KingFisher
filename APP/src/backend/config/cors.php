<?php

return [

    // CORSを有効にするパス。ここではAPI全体とSanctumのCSRF用クッキー取得に対応。
    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    // 許可するHTTPメソッド。['GET', 'POST']のように個別指定も可能。['*']で全て許可。
    'allowed_methods' => ['*'],

    // 許可するオリジン（リクエスト元のドメイン）。['*']はすべてのオリジンを許可。
    'allowed_origins' => [
        '*',
        'http://18.208.63.153',
        // 本番用ドメインもここに追加
    ],
    // 本番はFlutter Webのドメイン指定

    // 動的なオリジンマッチに使用。正規表現で記述可能（例：['/^https:\/\/.*\.example\.com$/']）。
    'allowed_origins_patterns' => [],

    // 許可するリクエストヘッダー。['*']で全て許可。セキュリティ的に必要なヘッダーだけを指定するのが理想。
    'allowed_headers' => ['Content-Type', 'X-Requested-With', 'Authorization', 'Accept', 'Origin'],

    // レスポンス時にクライアント側へ公開するヘッダーを指定。例：['Authorization', 'X-Custom-Header']。
    'exposed_headers' => [],

    // ブラウザがプリフライトリクエスト（OPTIONS）をキャッシュする時間（秒単位）。0でキャッシュしない。
    'max_age' => 0,

    // 認証情報（クッキー、認証ヘッダーなど）を許可するか。trueにするとCORSで資格情報付きリクエストを許可。
    'supports_credentials' => true,

];