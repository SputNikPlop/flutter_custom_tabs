import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_custom_tabs_platform_interface/src/method_channel_custom_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> log;
  late MethodChannelCustomTabs customTabs;

  const channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          channel, (methodCall) async => log.add(methodCall));

  setUp(() {
    log = <MethodCall>[];
    customTabs = MethodChannelCustomTabs();
  });

  test('launch invoke method "launch" with null option', () async {
    await customTabs.launch('http://example.com/');
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'customTabsOptions': const <String, dynamic>{},
          'safariVCOptions': const <String, dynamic>{}
        }),
      ],
    );
  });

  test('launch invoke method "launch" with option', () async {
    await customTabs.launch(
      'http://example.com/',
      customTabsOptions: const CustomTabsOptions(
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: false,
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'customTabsOptions': const <String, dynamic>{
            'urlBarHidingEnabled': true,
          },
          'safariVCOptions': const <String, dynamic>{
            'barCollapsingEnabled': false
          }
        }),
      ],
    );
  });

  test('closeAllIfPossible invoke method "closeAllIfPossible"', () async {
    await customTabs.closeAllIfPossible();
    expect(
      log,
      <Matcher>[
        isMethodCall('closeAllIfPossible', arguments: null),
      ],
    );
  });
}
