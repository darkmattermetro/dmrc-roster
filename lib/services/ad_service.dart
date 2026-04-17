import 'package:flutter/foundation.dart';

class AdService {
  static bool _isInitialized = false;
  static bool _isEnabled = false;
  static int _searchCount = 0;

  static const String _publisherId = 'YOUR_ADSENSE_PUBLISHER_ID';
  static const String _bannerAdUnit = 'YOUR_BANNER_AD_UNIT_ID';
  static const String _interstitialAdUnit = 'YOUR_INTERSTITIAL_AD_UNIT_ID';

  static Future<void> init() async {
    if (kIsWeb) {
      _isEnabled = true;
    }
    _isInitialized = true;
  }

  static bool shouldShowInterstitial() {
    if (!_isEnabled) return false;
    
    _searchCount++;
    return _searchCount % 3 == 0;
  }

  static void resetSearchCount() {
    _searchCount = 0;
  }

  static String get bannerAdCode {
    if (!_isEnabled) return '';
    
    return '''
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=$_publisherId"
     crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="$_publisherId"
     data-ad-slot="$_bannerAdUnit"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
''';
  }

  static String get interstitialAdCode {
    if (!_isEnabled) return '';
    
    return '''
<script>
     (adsbygoogle = window.adsbygoogle || []).push({
          onerror: function() { /* Ad error */ },
          onload: function() { /* Ad loaded */ }
     });
</script>
''';
  }

  static bool get isEnabled => _isEnabled;
  static bool get isInitialized => _isInitialized;
}

class AdPlacement {
  static const String topBanner = 'top_banner';
  static const String bottomBanner = 'bottom_banner';
  static const String native = 'native';
  static const String interstitial = 'interstitial';
}
