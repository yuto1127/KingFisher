import 'dart:html' as html;

class MobileUtils {
  /// 常にfalse（Web専用）
  static bool get isMobile => false;
  static bool get isTablet => false;
  static bool get isSmartphone => false;

  static String getDeviceType() => 'desktop';
  static String getMobileBrowser() => 'unknown';

  static Future<bool> checkLocalStorageAvailability() async => true;
  static Future<bool> checkSessionStorageAvailability() async => true;

  static Map<String, dynamic> getNetworkInfo() {
    return {
      'online': html.window.navigator.onLine,
      'effectiveType': 'unknown',
      'downlink': 0,
      'rtt': 0,
      'saveData': false,
    };
  }

  static bool get hasTouchSupport => false;

  static Map<String, dynamic> diagnoseMobileIssues() {
    return {
      'isMobile': false,
      'deviceType': 'desktop',
      'browser': 'unknown',
      'networkInfo': getNetworkInfo(),
      'hasTouchSupport': false,
      'issues': [],
      'recommendations': [],
    };
  }

  static Map<String, dynamic> getDevicePerformance() {
    return {
      'memory': 'sufficient',
      'cpu': 'sufficient',
      'storage': 'sufficient',
      'battery': 'sufficient',
    };
  }

  static Map<String, dynamic> getOptimizedSettings() {
    return {
      'animations': true,
      'highQuality': true,
      'autoSave': true,
      'offlineMode': true,
    };
  }

  static void applyMobileOptimizations() {
    // Web専用なので何もしない
  }

  static void logMobileDebugInfo() {
    print('=== Webデバッグ情報 ===');
    print('デバイスタイプ: desktop');
    print('タッチサポート: false');
    print('ネットワーク情報: ${getNetworkInfo()}');
    print('性能情報: ${getDevicePerformance()}');
    print('最適化設定: ${getOptimizedSettings()}');
    print('======================');
  }
}
