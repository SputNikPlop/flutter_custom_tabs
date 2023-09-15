import 'package:flutter/material.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Custom Tabs Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _launchURL(context),
                  child: const Text(
                    'Show Flutter homepage',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _launchURLInBottomSheet(context),
                  child: const Text(
                    'Show Flutter homepage(bottom Sheet)',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launch(
        'https://flutter.dev',
        customTabsOptions: CustomTabsOptions(
          toolbarColor: theme.colorScheme.surface,
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcon.back,
          ),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Future<void> _launchURLInBottomSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    try {
      await launch(
        'https://flutter.dev',
        customTabsOptions: CustomTabsOptions.bottomSheet(
          configuration: CustomTabsBottomSheetConfiguration(
            initialHeight: mediaQuery.size.height * 0.7,
          ),
          toolbarColor: theme.primaryColor,
          showPageTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions.pageSheet(
          configuration: const SheetPresentationControllerConfiguration(
            detents: {
              SheetPresentationControllerDetent.large,
              SheetPresentationControllerDetent.medium,
            },
            largestUndimmedDetentIdentifier:
                SheetPresentationControllerDetent.medium,
            prefersScrollingExpandsWhenScrolledToEdge: false,
            prefersGrabberVisible: true,
            prefersEdgeAttachedInCompactHeight: true,
            preferredCornerRadius: 16.0,
          ),
          preferredBarTintColor: theme.primaryColor,
          preferredControlTintColor: Colors.white,
          entersReaderIfAvailable: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
