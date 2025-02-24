import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../responsive/breakpoints/responsive_breakpoints.dart';

extension PlatformHelper on void {
  static double get width => Get.width;
  static double get height => Get.height;
  static bool get isDesktop => width >= ResponsiveBreakpoints.desktop;
  static bool get isMobile => width < ResponsiveBreakpoints.tablet;
  static bool get isTablet => width >= ResponsiveBreakpoints.tablet && width < ResponsiveBreakpoints.desktop;

  static bool get isMobileOs => !isWeb && (isAndroid || isIOS);
  static bool get isWeb => kIsWeb;
  static bool get isWindows => !isWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => !isWeb && defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMacOS => !isWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isAndroid => !isWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => !isWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isDesktopOs => isWindows || isLinux || isMacOS;
}
