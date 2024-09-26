import 'package:flutter/material.dart';

class Responsive {
  static const int desktopBreakpoint = 1024; // Desktop width threshold

  static double getDialogWidth(BuildContext context) {
    // Check the screen width and return appropriate dialog width
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= desktopBreakpoint) {
      return 800.0; // Desktop size
    } else if (screenWidth >= 600) {
      return 500.0; // Tablet size
    } else {
      return 400.0; // Mobile size
    }
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < desktopBreakpoint;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
}
