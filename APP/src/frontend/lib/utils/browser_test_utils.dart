import 'dart:html' as html;
import 'dart:js' as js;
import 'browser_utils.dart';

class BrowserTestUtils {
  /// ブラウザの詳細情報を取得
  static Map<String, dynamic> getBrowserInfo() {
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
    final results = <String, bool>{};
    try {
      html.window.localStorage['test'] = 'test';
      results['localStorage'] = html.window.localStorage['test'] == 'test';
      html.window.localStorage.remove('test');
    } catch (e) {
      results['localStorage'] = false;
    }
    try {
      html.window.sessionStorage['test'] = 'test';
      results['sessionStorage'] = html.window.sessionStorage['test'] == 'test';
      html.window.sessionStorage.remove('test');
    } catch (e) {
      results['sessionStorage'] = false;
    }
    results['fetch'] = html.window.fetch != null;
    results['promise'] = js.context.hasProperty('Promise');
    results['webAssembly'] = js.context.hasProperty('WebAssembly');
    try {
      final canvas = html.CanvasElement();
      final ctx = canvas.getContext('2d');
      results['canvas'] = ctx != null;
    } catch (e) {
      results['canvas'] = false;
    }
    try {
      final canvas = html.CanvasElement();
      final gl =
          canvas.getContext('webgl') ?? canvas.getContext('experimental-webgl');
      results['webgl'] = gl != null;
    } catch (e) {
      results['webgl'] = false;
    }
    results['geolocation'] = html.window.navigator.geolocation != null;
    results['camera'] = html.window.navigator.mediaDevices != null;
    return results;
  }

  /// ブラウザのパフォーマンステストを実行
  static Map<String, dynamic> runPerformanceTests() {
    final results = <String, dynamic>{};
    if (html.window.performance.memory != null) {
      final memory = html.window.performance.memory!;
      results['memory'] = {
        'used': memory.usedJSHeapSize,
        'total': memory.totalJSHeapSize,
        'limit': memory.jsHeapSizeLimit,
      };
    } else {
      results['memory'] = 'unavailable';
    }
    if (html.window.navigator.connection != null) {
      final connection = html.window.navigator.connection!;
      results['connection'] = {
        'effectiveType': connection.effectiveType,
        'downlink': connection.downlink,
        'rtt': connection.rtt,
        'saveData':
            js.context.hasProperty('saveData') ? js.context['saveData'] : false,
      };
    } else {
      results['connection'] = 'unavailable';
    }
    results['devicePixelRatio'] = html.window.devicePixelRatio;
    return results;
  }

  /// ブラウザの互換性レポートを生成
  static Map<String, dynamic> generateCompatibilityReport() {
    final browserInfo = getBrowserInfo();
    final isSupported = BrowserUtils.isSupportedBrowser();
    final warningMessage = BrowserUtils.getBrowserWarningMessage();
    final testResults = runBrowserTests();
    final recommendations = getRecommendations(testResults);
    return {
      'browserInfo': browserInfo,
      'isSupported': isSupported,
      'warningMessage': warningMessage,
      'testResults': testResults,
      'recommendations': recommendations,
    };
  }

  /// 推奨事項を生成
  static List<String> getRecommendations(Map<String, bool> testResults) {
    final recommendations = <String>[];
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
