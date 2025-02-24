import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';
import '../../widgets/sidebar/widgets/sidebar.dart';
import '../breakpoints/responsive_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final bool useScaffold;
  final Widget? drawer;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.appBar,
    this.floatingActionButton,
    this.useScaffold = true,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Desktop layout
        if (ResponsiveBreakpoints.isDesktop(width)) {
          return Row(
            children: [
              Expanded(child: SideBar()),
              Expanded(
                flex: 5,
                child: useScaffold
                    ? Scaffold(
                        backgroundColor: HColors.primaryBackground,
                        appBar: appBar,
                        body: desktop ?? mobile,
                      )
                    : desktop ?? mobile,
              ),
            ],
          );
        }

        // Tablet layout
        if (ResponsiveBreakpoints.isTablet(width)) {
          return tablet ?? mobile;
        }

        // Mobile layout
        return useScaffold
            ? Scaffold(
                drawer: drawer,
                backgroundColor: HColors.white,
                appBar: appBar,
                floatingActionButton: floatingActionButton,
                body: mobile,
              )
            : mobile;
      },
    );
  }
}
