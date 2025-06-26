import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class BrowserUtils {
  /// 現在のブラウザを判定
  static String getCurrentBrowser() {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      
      // Yahoo!ブラウザの判定（Chromeベースだが独自機能あり）
      if (userAgent.contains('yahoo') || userAgent.contains('ybrowser')) {
        return 'yahoo';
      }
      // Chromeの判定（EdgeとYahoo!ブラウザを除外）
      else if (userAgent.contains('chrome') && !userAgent.contains('edge') && !userAgent.contains('yahoo')) {
        return 'chrome';
      } 
      // Safariの判定（ChromeとEdgeを除外）
      else if (userAgent.contains('safari') && !userAgent.contains('chrome') && !userAgent.contains('edge')) {
        return 'safari';
      } 
      // Edgeの判定
      else if (userAgent.contains('edge')) {
        return 'edge';
      } 
      // Firefoxの判定
      else if (userAgent.contains('firefox')) {
        return 'firefox';
      } 
      // Operaの判定
      else if (userAgent.contains('opera') || userAgent.contains('opr')) {
        return 'opera';
      }
      else {
        return 'unknown';
      }
    }
    return 'mobile';
  }

  /// ブラウザがサポートされているかチェック
  static bool isSupportedBrowser() {
    if (kIsWeb) {
      final browser = getCurrentBrowser();
      return ['chrome', 'safari', 'edge', 'firefox', 'yahoo', 'opera'].contains(browser);
    }
    return true; // モバイルアプリの場合は常にtrue
  }

  /// ブラウザのバージョンを取得
  static String getBrowserVersion() {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent;
      final browser = getCurrentBrowser();
      
      switch (browser) {
        case 'chrome':
          final match = RegExp(r'Chrome/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        case 'yahoo':
          // Yahoo!ブラウザのバージョン取得（Chromeベース）
          final match = RegExp(r'Chrome/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        case 'safari':
          final match = RegExp(r'Version/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        case 'edge':
          final match = RegExp(r'Edge/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        case 'firefox':
          final match = RegExp(r'Firefox/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        case 'opera':
          final match = RegExp(r'OPR/(\d+)').firstMatch(userAgent) ?? RegExp(r'Opera/(\d+)').firstMatch(userAgent);
          return match?.group(1) ?? 'unknown';
        default:
          return 'unknown';
      }
    }
    return 'mobile';
  }

  /// ブラウザの機能サポートをチェック
  static Map<String, bool> getBrowserCapabilities() {
    if (kIsWeb) {
      return {
        'localStorage': html.window.localStorage != null,
        'sessionStorage': html.window.sessionStorage != null,
        'geolocation': html.window.navigator.geolocation != null,
        'camera': html.window.navigator.mediaDevices != null,
        'webgl': html.window.navigator.getGamepads != null,
        'serviceWorker': html.window.navigator.serviceWorker != null,
        'webAssembly': html.window.WebAssembly != null,
        'fetch': html.window.fetch != null,
        'promise': html.window.Promise != null,
      };
    }
    return {
      'localStorage': true,
      'sessionStorage': true,
      'geolocation': true,
      'camera': true,
      'webgl': true,
      'serviceWorker': false,
      'webAssembly': true,
      'fetch': true,
      'promise': true,
    };
  }

  /// ブラウザ固有の設定を取得
  static Map<String, dynamic> getBrowserSpecificSettings() {
    final browser = getCurrentBrowser();
    
    switch (browser) {
      case 'safari':
        return {
          'scrollBehavior': 'smooth',
          'touchAction': 'manipulation',
          'webkitUserSelect': 'none',
          'webkitOverflowScrolling': 'touch',
        };
      case 'chrome':
        return {
          'scrollBehavior': 'smooth',
          'touchAction': 'manipulation',
          'overscrollBehavior': 'contain',
        };
      case 'yahoo':
        // Yahoo!ブラウザはChromeベースだが、一部設定が異なる
        return {
          'scrollBehavior': 'smooth',
          'touchAction': 'manipulation',
          'overscrollBehavior': 'contain',
          'webkitUserSelect': 'none',
        };
      case 'edge':
        return {
          'scrollBehavior': 'smooth',
          'touchAction': 'manipulation',
          'overscrollBehavior': 'contain',
        };
      case 'firefox':
        return {
          'scrollBehavior': 'smooth',
          'mozUserSelect': 'none',
          'scrollbarWidth': 'thin',
        };
      case 'opera':
        return {
          'scrollBehavior': 'smooth',
          'touchAction': 'manipulation',
        };
      default:
        return {};
    }
  }

  /// ブラウザの警告メッセージを取得
  static String? getBrowserWarningMessage() {
    if (!kIsWeb) return null;
    
    final browser = getCurrentBrowser();
    final version = getBrowserVersion();
    
    if (browser == 'unknown') {
      return 'サポートされていないブラウザです。Chrome、Safari、Edge、Firefox、Yahoo!ブラウザの最新版をご利用ください。';
    }
    
    // 古いバージョンの警告
    if (version != 'unknown') {
      final versionNum = int.tryParse(version) ?? 0;
      
      switch (browser) {
        case 'chrome':
          if (versionNum < 80) {
            return 'Chromeのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
        case 'yahoo':
          if (versionNum < 80) {
            return 'Yahoo!ブラウザのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
        case 'safari':
          if (versionNum < 13) {
            return 'Safariのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
        case 'edge':
          if (versionNum < 80) {
            return 'Edgeのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
        case 'firefox':
          if (versionNum < 75) {
            return 'Firefoxのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
        case 'opera':
          if (versionNum < 67) {
            return 'Operaのバージョンが古い可能性があります。最新版にアップデートすることをお勧めします。';
          }
          break;
      }
    }
    
    return null;
  }

  /// ブラウザの設定を適用
  static void applyBrowserSettings() {
    if (kIsWeb) {
      final settings = getBrowserSpecificSettings();
      
      // CSSスタイルを動的に適用
      final style = html.StyleElement();
      style.text = '''
        html {
          scroll-behavior: ${settings['scrollBehavior'] ?? 'auto'};
          -webkit-user-select: ${settings['webkitUserSelect'] ?? 'auto'};
          -moz-user-select: ${settings['mozUserSelect'] ?? 'auto'};
          -ms-user-select: ${settings['webkitUserSelect'] ?? 'auto'};
          user-select: ${settings['webkitUserSelect'] ?? 'auto'};
          -webkit-overflow-scrolling: ${settings['webkitOverflowScrolling'] ?? 'auto'};
          scrollbar-width: ${settings['scrollbarWidth'] ?? 'auto'};
        }
        
        body {
          touch-action: ${settings['touchAction'] ?? 'auto'};
          overscroll-behavior: ${settings['overscrollBehavior'] ?? 'auto'};
        }
        
        /* Firefox用のスクロールバー設定 */
        * {
          scrollbar-width: ${settings['scrollbarWidth'] ?? 'auto'};
        }
        
        /* Webkit系ブラウザ用のスクロールバー設定 */
        ::-webkit-scrollbar {
          width: 8px;
        }
        
        ::-webkit-scrollbar-track {
          background: #f1f1f1;
        }
        
        ::-webkit-scrollbar-thumb {
          background: #888;
          border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
          background: #555;
        }
      ''';
      
      html.document.head?.append(style);
    }
  }

  /// ブラウザ固有の問題を回避するための設定
  static Map<String, dynamic> getBrowserWorkarounds() {
    final browser = getCurrentBrowser();
    
    switch (browser) {
      case 'firefox':
        return {
          'useCanvasKit': false, // FirefoxではCanvasKitが不安定な場合がある
          'disableImageSmoothing': true, // 画像のスムージングを無効化
        };
      case 'yahoo':
        return {
          'useCanvasKit': false, // Yahoo!ブラウザでもCanvasKitを無効化
          'disableImageSmoothing': false,
        };
      case 'safari':
        return {
          'useCanvasKit': false, // SafariでもCanvasKitを無効化
          'disableImageSmoothing': false,
        };
      default:
        return {
          'useCanvasKit': false,
          'disableImageSmoothing': false,
        };
    }
  }
} 