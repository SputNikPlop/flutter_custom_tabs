import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> log;
  late CustomTabsPluginIOS customTabs;

  const channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (methodCall) async => log.add(methodCall),
  );

  setUp(() {
    log = <MethodCall>[];
    customTabs = CustomTabsPluginIOS();
  });

  test('launch() invoke method "launch" with SafariViewControllerOptions',
      () async {
    await customTabs.launch(
      'http://example.com/',
      prefersDeepLink: true,
      customTabsOptions: const _LaunchOptions(),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': true,
          'safariVCOptions': const <String, dynamic>{
            'barCollapsingEnabled': true,
          },
        }),
      ],
    );
  });

  test('launch() invoke method "launch" with invalid options', () async {
    await customTabs.launch(
      'http://example.com/',
      prefersDeepLink: true,
      customTabsOptions: const _LaunchOptions(),
      safariVCOptions: const _LaunchOptions(
        barCollapsingEnabled: true,
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': true,
          'safariVCOptions': const <String, dynamic>{},
        }),
      ],
    );
  });

  test('closeAllIfPossible() invoke method "closeAllIfPossible"', () async {
    await customTabs.closeAllIfPossible();
    expect(
      log,
      <Matcher>[
        isMethodCall('closeAllIfPossible', arguments: null),
      ],
    );
  });
}

class _LaunchOptions implements PlatformOptions {
  final bool? barCollapsingEnabled;

  const _LaunchOptions({
    this.barCollapsingEnabled,
  });

  @override
  Map<String, dynamic> toMap() => {
        if (barCollapsingEnabled != null)
          'barCollapsingEnabled': barCollapsingEnabled,
      };
}
