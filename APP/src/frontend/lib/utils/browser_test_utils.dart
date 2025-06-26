import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'browser_utils.dart';

class BrowserTestUtils {
  /// ブラウザの詳細情報を取得
  static Map<String, dynamic> getBrowserInfo() {
    if (!kIsWeb) {
      return {
        'platform': 'mobile',
        'browser': 'mobile_app',
        'version': 'unknown',
        'userAgent': 'mobile_app',
      };
    }

    final userAgent = html.window.navigator.userAgent;
    final browser = BrowserUtils.getCurrentBrowser();
    final version = BrowserUtils.getBrowserVersion();
    final capabilities = BrowserUtils.getBrowserCapabilities();

    return {
      'platform': 'web',
      'browser': browser,
      'version': version,
      'userAgent': userAgent,
      'capabilities': capabilities,
      'language': html.window.navigator.language,
      'platform': html.window.navigator.platform,
      'cookieEnabled': html.window.navigator.cookieEnabled,
      'onLine': html.window.navigator.onLine,
    };
  }

  /// ブラウザの機能テストを実行
  static Map<String, bool> runBrowserTests() {
    if (!kIsWeb) {
      return {
        'localStorage': true,
        'sessionStorage': true,
        'fetch': true,
        'promise': true,
        'webAssembly': true,
        'canvas': true,
        'webgl': true,
        'geolocation': true,
        'camera': true,
      };
    }

    final results = <String, bool>{};

    // LocalStorage テスト
    try {
      html.window.localStorage['test'] = 'test';
      results['localStorage'] = html.window.localStorage['test'] == 'test';
      html.window.localStorage.remove('test');
    } catch (e) {
      results['localStorage'] = false;
    }

    // SessionStorage テスト
    try {
      html.window.sessionStorage['test'] = 'test';
      results['sessionStorage'] = html.window.sessionStorage['test'] == 'test';
      html.window.sessionStorage.remove('test');
    } catch (e) {
      results['sessionStorage'] = false;
    }

    // Fetch API テスト
    results['fetch'] = html.window.fetch != null;

    // Promise テスト
    results['promise'] = html.window.Promise != null;

    // WebAssembly テスト
    results['webAssembly'] = html.window.WebAssembly != null;

    // Canvas テスト
    try {
      final canvas = html.CanvasElement();
      final ctx = canvas.getContext('2d');
      results['canvas'] = ctx != null;
    } catch (e) {
      results['canvas'] = false;
    }

    // WebGL テスト
    try {
      final canvas = html.CanvasElement();
      final gl = canvas.getContext('webgl') ?? canvas.getContext('experimental-webgl');
      results['webgl'] = gl != null;
    } catch (e) {
      results['webgl'] = false;
    }

    // Geolocation テスト
    results['geolocation'] = html.window.navigator.geolocation != null;

    // Camera テスト
    results['camera'] = html.window.navigator.mediaDevices != null;

    return results;
  }

  /// ブラウザのパフォーマンステストを実行
  static Map<String, dynamic> runPerformanceTests() {
    if (!kIsWeb) {
      return {
        'memory': 'unknown',
        'connection': 'unknown',
        'devicePixelRatio': 1.0,
      };
    }

    final results = <String, dynamic>{};

    // メモリ使用量（利用可能な場合）
    if (html.window.performance != null && html.window.performance.memory != null) {
      final memory = html.window.performance.memory!;
      results['memory'] = {
        'used': memory.usedJSHeapSize,
        'total': memory.totalJSHeapSize,
        'limit': memory.jsHeapSizeLimit,
      };
    } else {
      results['memory'] = 'unavailable';
    }

    // ネットワーク接続情報
    if (html.window.navigator.connection != null) {
      final connection = html.window.navigator.connection!;
      results['connection'] = {
        'effectiveType': connection.effectiveType,
        'downlink': connection.downlink,
        'rtt': connection.rtt,
        'saveData': connection.saveData,
      };
    } else {
      results['connection'] = 'unavailable';
    }

    // デバイスピクセル比
    results['devicePixelRatio'] = html.window.devicePixelRatio;

    return results;
  }

  /// ブラウザの互換性レポートを生成
  static Map<String, dynamic> generateCompatibilityReport() {
    final browserInfo = getBrowserInfo();
    final testResults = runBrowserTests();
    final performanceInfo = runPerformanceTests();
    final warningMessage = BrowserUtils.getBrowserWarningMessage();

    return {
      'browserInfo': browserInfo,
      'testResults': testResults,
      'performanceInfo': performanceInfo,
      'warningMessage': warningMessage,
      'isSupported': BrowserUtils.isSupportedBrowser(),
      'recommendations': _generateRecommendations(browserInfo, testResults),
    };
  }

  /// 推奨事項を生成
  static List<String> _generateRecommendations(
    Map<String, dynamic> browserInfo,
    Map<String, bool> testResults,
  ) {
    final recommendations = <String>[];

    // ブラウザ固有の推奨事項
    final browser = browserInfo['browser'] as String;
    switch (browser) {
      case 'firefox':
        if (!testResults['webgl']!) {
          recommendations.add('FirefoxでWebGLが無効になっています。about:configでwebgl.disabledをfalseに設定してください。');
        }
        break;
      case 'safari':
        if (!testResults['localStorage']!) {
          recommendations.add('Safariでプライベートブラウジングモードが有効になっている可能性があります。');
        }
        break;
      case 'yahoo':
        recommendations.add('Yahoo!ブラウザを使用しています。Chromeベースですが、一部機能が制限される場合があります。');
        break;
    }

    // 機能別の推奨事項
    if (!testResults['localStorage']!) {
      recommendations.add('ローカルストレージが利用できません。プライベートブラウジングモードを無効にしてください。');
    }

    if (!testResults['webgl']!) {
      recommendations.add('WebGLが利用できません。ハードウェアアクセラレーションを有効にしてください。');
    }

    if (!testResults['camera']!) {
      recommendations.add('カメラ機能が利用できません。HTTPS接続が必要です。');
    }

    return recommendations;
  }

  /// デバッグ情報をコンソールに出力
  static void logDebugInfo() {
    if (!kIsWeb) return;

    final report = generateCompatibilityReport();
    
    print('=== ブラウザ互換性レポート ===');
    print('ブラウザ: ${report['browserInfo']['browser']}');
    print('バージョン: ${report['browserInfo']['version']}');
    print('サポート状況: ${report['isSupported']}');
    
    if (report['warningMessage'] != null) {
      print('警告: ${report['warningMessage']}');
    }
    
    print('機能テスト結果:');
    final testResults = report['testResults'] as Map<String, bool>;
    testResults.forEach((key, value) {
      print('  $key: ${value ? '✅' : '❌'}');
    });
    
    if (report['recommendations'].isNotEmpty) {
      print('推奨事項:');
      for (final recommendation in report['recommendations']) {
        print('  - $recommendation');
      }
    }
    print('==============================');
  }
} 