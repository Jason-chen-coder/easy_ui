import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
