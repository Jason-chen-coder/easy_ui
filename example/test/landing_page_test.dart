import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('desktop hero keeps a usable height in short viewports', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    expect(find.text('Easy UI Design'), findsOneWidget);
    expect(
      tester.getSize(_byRuntimeType('_HeroVisual')).height,
      greaterThanOrEqualTo(320),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('footer author link opens the public Jason Chen profile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final launchedUrls = <String>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_urlLauncherChannel, (call) async {
      if (call.method == 'launch') {
        launchedUrls.add(
          (call.arguments as Map<Object?, Object?>)['url']! as String,
        );
        return true;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(_urlLauncherChannel, null),
    );

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    final landingScrollable =
        find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first;
    final scrollableState = tester.state<ScrollableState>(landingScrollable);
    scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);
    await tester.pump();

    await tester.tap(find.text('Jason Chen'));
    await tester.pump();

    expect(launchedUrls, ['https://github.com/Jason-chen-coder']);
  });

  testWidgets(
    'landing uses the split feature structure without legacy widgets',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MainApp());
      await tester.pump();

      expect(find.text('Easy UI Design'), findsOneWidget);
      expect(_byRuntimeType('_PlatformFeatureSection'), findsOneWidget);
      expect(_byRuntimeType('_CapabilityFeatureSection'), findsOneWidget);
      expect(_byRuntimeType('_FeatureSection'), findsNothing);
      expect(_byRuntimeType('_HeroNav'), findsNothing);
      expect(find.byType(Table), findsNothing);
    },
  );

  testWidgets('landing keeps sponsors without the legacy footer links', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    final landingScrollView = find.byType(CustomScrollView);
    for (var i = 0; i < 12; i++) {
      await tester.drag(landingScrollView, const Offset(0, -700));
      await tester.pump();
    }

    expect(find.text('合作与赞助'), findsOneWidget);
    expect(find.text('Mxgraph EasyFlowEditor'), findsOneWidget);
    expect(find.text('Flutter EasySpeechRecognition'), findsOneWidget);
    expect(find.text('讨论区'), findsNothing);
    expect(find.text('在线预览'), findsNothing);

    for (final asset in const [
      'assets/images/mxgraph_app_icon.png',
      'assets/images/easy_speech_logo.jpg',
    ]) {
      expect(await rootBundle.load(asset), isNotNull, reason: asset);
    }
  });

  testWidgets('sponsor cards are visible after a single jump to the bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    final landingScrollable =
        find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first;
    final scrollableState = tester.state<ScrollableState>(landingScrollable);
    scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);
    await tester.pump();

    for (final projectName in const [
      'Mxgraph EasyFlowEditor',
      'Flutter EasySpeechRecognition',
    ]) {
      final project = _sponsorProjectName(projectName);
      expect(project, findsOneWidget);
      expect(
        find.ancestor(
          of: project,
          matching: find.byWidgetPredicate(
            (widget) => widget is AnimatedOpacity && widget.opacity == 0,
          ),
        ),
        findsNothing,
        reason: projectName,
      );
    }
  });

  testWidgets('compact sponsor project names use two lines without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    final landingScrollable =
        find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first;
    final scrollableState = tester.state<ScrollableState>(landingScrollable);
    scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);
    await tester.pump();

    for (final projectName in const [
      'Mxgraph EasyFlowEditor',
      'Flutter EasySpeechRecognition',
    ]) {
      final projectText = tester.widget<Text>(_sponsorProjectName(projectName));
      expect(projectText.maxLines, 2, reason: projectName);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('starts on a standalone landing page before opening workspace', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    expect(find.text('Easy UI Design'), findsOneWidget);
    expect(find.text('搜索组件...'), findsNothing);

    await tester.tap(find.text('浏览组件'));
    await tester.pumpAndSettle();

    expect(find.text('Easy UI 组件库'), findsOneWidget);
    expect(find.text('搜索组件...'), findsOneWidget);
    expect(find.text('组件总览'), findsWidgets);
  });

  testWidgets('sidebar language and theme dropdowns open from their buttons', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.pump();

    await tester.tap(find.text('浏览组件'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Theme Mode'));
    await tester.pumpAndSettle();
    expect(find.text('亮色'), findsOneWidget);
    expect(find.text('暗色'), findsOneWidget);
  });
}

const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');

Finder _byRuntimeType(String typeName) {
  return find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == typeName,
    skipOffstage: false,
  );
}

Finder _sponsorProjectName(String name) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text && widget.data == name && widget.style?.fontSize == 22,
  );
}
