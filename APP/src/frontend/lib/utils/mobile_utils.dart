import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class MobileUtils {
  /// モバイルデバイスかどうかを判定
  static bool get isMobile {
    if (!kIsWeb) return false;

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        userAgent.contains('tablet');
  }

  /// タブレットかどうかを判定
  static bool get isTablet {
    if (!kIsWeb) return false;

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('ipad') ||
        userAgent.contains('tablet') ||
        (userAgent.contains('android') && !userAgent.contains('mobile'));
  }

  /// スマートフォンかどうかを判定
  static bool get isSmartphone {
    if (!kIsWeb) return false;

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return (userAgent.contains('mobile') && !userAgent.contains('tablet')) ||
        (userAgent.contains('android') && userAgent.contains('mobile')) ||
        userAgent.contains('iphone');
  }

  /// 画面サイズに基づくデバイスタイプを取得
  static String getDeviceType() {
    if (!kIsWeb) return 'desktop';

    final width = html.window.innerWidth ?? 1024;
    final height = html.window.innerHeight ?? 768;

    if (width < 768) {
      return 'mobile';
    } else if (width < 1024) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }

  /// モバイルブラウザの種類を取得
  static String getMobileBrowser() {
    if (!kIsWeb) return 'unknown';

    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (userAgent.contains('safari') && userAgent.contains('mobile')) {
      return 'mobile_safari';
    } else if (userAgent.contains('chrome') && userAgent.contains('mobile')) {
      return 'mobile_chrome';
    } else if (userAgent.contains('firefox') && userAgent.contains('mobile')) {
      return 'mobile_firefox';
    } else if (userAgent.contains('edge') && userAgent.contains('mobile')) {
      return 'mobile_edge';
    } else if (userAgent.contains('opera') && userAgent.contains('mobile')) {
      return 'mobile_opera';
    } else if (userAgent.contains('samsung')) {
      return 'samsung_internet';
    } else if (userAgent.contains('ucbrowser')) {
      return 'uc_browser';
    }

    return 'unknown_mobile';
  }

  /// モバイルデバイスでのローカルストレージの可用性をチェック
  static Future<bool> checkLocalStorageAvailability() async {
    if (!kIsWeb) return false;

    try {
      // テスト用のキーでローカルストレージをテスト
      final testKey = 'mobile_storage_test';
      final testValue = 'test_value_${DateTime.now().millisecondsSinceEpoch}';

      html.window.localStorage[testKey] = testValue;
      final retrieved = html.window.localStorage[testKey];
      html.window.localStorage.remove(testKey);

      return retrieved == testValue;
    } catch (e) {
      return false;
    }
  }

  /// モバイルデバイスでのセッションストレージの可用性をチェック
  static Future<bool> checkSessionStorageAvailability() async {
    if (!kIsWeb) return false;

    try {
      final testKey = 'mobile_session_test';
      final testValue = 'test_value_${DateTime.now().millisecondsSinceEpoch}';

      html.window.sessionStorage[testKey] = testValue;
      final retrieved = html.window.sessionStorage[testKey];
      html.window.sessionStorage.remove(testKey);

      return retrieved == testValue;
    } catch (e) {
      return false;
    }
  }

  /// モバイルデバイスでのネットワーク接続状況を取得
  static Map<String, dynamic> getNetworkInfo() {
    if (!kIsWeb) {
      return {
        'online': false,
        'effectiveType': 'unknown',
        'downlink': 0,
        'rtt': 0,
        'saveData': false,
      };
    }

    final connection = html.window.navigator.connection;
    if (connection != null) {
      return {
        'online': html.window.navigator.onLine,
        'effectiveType': connection.effectiveType ?? 'unknown',
        'downlink': connection.downlink ?? 0,
        'rtt': connection.rtt ?? 0,
        'saveData': false,
      };
    }

    return {
      'online': html.window.navigator.onLine,
      'effectiveType': 'unknown',
      'downlink': 0,
      'rtt': 0,
      'saveData': false,
    };
  }

  /// モバイルデバイスでのタッチサポート状況をチェック
  static bool get hasTouchSupport {
    if (!kIsWeb) return false;

    return html.window.navigator.maxTouchPoints != null &&
        html.window.navigator.maxTouchPoints! > 0;
  }

  /// モバイルデバイスでの問題を診断
  static Map<String, dynamic> diagnoseMobileIssues() {
    if (!kIsWeb) {
      return {
        'isMobile': false,
        'issues': [],
        'recommendations': [],
      };
    }

    final issues = <String>[];
    final recommendations = <String>[];

    // デバイスタイプの確認
    final deviceType = getDeviceType();
    final isMobileDevice = isMobile;

    if (isMobileDevice) {
      // ローカルストレージの確認
      checkLocalStorageAvailability().then((available) {
        if (!available) {
          issues.add('localStorage_unavailable');
          recommendations.add('プライベートブラウジングモードを無効にしてください');
        }
      });

      // ネットワーク接続の確認
      final networkInfo = getNetworkInfo();
      if (!networkInfo['online']) {
        issues.add('network_offline');
        recommendations.add('インターネット接続を確認してください');
      }

      if (networkInfo['saveData'] == true) {
        issues.add('data_saver_enabled');
        recommendations.add('データセーバーを無効にしてください');
      }

      // ブラウザの確認
      final browser = getMobileBrowser();
      if (browser == 'unknown_mobile') {
        issues.add('unsupported_browser');
        recommendations.add('Chrome、Safari、Firefoxの最新版をご利用ください');
      }

      // タッチサポートの確認
      if (!hasTouchSupport) {
        issues.add('no_touch_support');
        recommendations.add('タッチ対応デバイスをご利用ください');
      }
    }

    return {
      'isMobile': isMobileDevice,
      'deviceType': deviceType,
      'browser': getMobileBrowser(),
      'networkInfo': getNetworkInfo(),
      'hasTouchSupport': hasTouchSupport,
      'issues': issues,
      'recommendations': recommendations,
    };
  }

  /// モバイルデバイスでの最適化設定を適用
  static void applyMobileOptimizations() {
    if (!kIsWeb || !isMobile) return;

    // ビューポートの設定
    final viewport = html.document.querySelector('meta[name="viewport"]');
    if (viewport == null) {
      final meta = html.MetaElement()
        ..name = 'viewport'
        ..content =
            'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
      html.document.head?.append(meta);
    }

    // タッチ操作の最適化
    final style = html.StyleElement();
    style.text = '''
      * {
        -webkit-touch-callout: none;
        -webkit-user-select: none;
        -khtml-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        -webkit-tap-highlight-color: transparent;
      }
      
      input, textarea {
        -webkit-user-select: text;
        -khtml-user-select: text;
        -moz-user-select: text;
        -ms-user-select: text;
        user-select: text;
      }
      
      button, a {
        -webkit-tap-highlight-color: rgba(0,0,0,0.1);
      }
    ''';

    html.document.head?.append(style);
  }

  /// モバイルデバイスでのデバッグ情報を出力
  static void logMobileDebugInfo() {
    if (!kIsWeb) return;

    final diagnosis = diagnoseMobileIssues();

    print('=== モバイルデバイス診断 ===');
    print('デバイスタイプ: ${diagnosis['deviceType']}');
    print('ブラウザ: ${diagnosis['browser']}');
    print('タッチサポート: ${diagnosis['hasTouchSupport']}');
    print('ネットワーク情報: ${diagnosis['networkInfo']}');

    if (diagnosis['issues'].isNotEmpty) {
      print('問題: ${diagnosis['issues']}');
      print('推奨事項: ${diagnosis['recommendations']}');
    }
    print('============================');
  }
}
