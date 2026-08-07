import 'dart:ui' show SemanticsFlag;

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum _Action { edit, copy, delete }

void main() {
  Future<void> pumpMenu(
    WidgetTester tester, {
    required ValueChanged<_Action> onSelected,
    bool enabled = true,
    List<EasyMoreMenuItem<_Action>>? items,
    Widget? button,
    String? tooltip,
    String? semanticLabel,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: EasyTheme(
          data: EasyThemeData(),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: EasyMoreMenu<_Action>(
                enabled: enabled,
                button: button,
                tooltip: tooltip,
                semanticLabel: semanticLabel,
                items:
                    items ??
                    const [
                      EasyMoreMenuItem(value: _Action.edit, label: 'Edit'),
                      EasyMoreMenuItem(value: _Action.copy, label: 'Copy'),
                      EasyMoreMenuItem(
                        value: _Action.delete,
                        label: 'Delete',
                        danger: true,
                      ),
                    ],
                onSelected: onSelected,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('opens and emits the selected typed value', (tester) async {
    _Action? selected;
    await pumpMenu(tester, onSelected: (value) => selected = value);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(selected, _Action.copy);
    expect(find.text('Copy'), findsNothing);
  });

  testWidgets('does not select a disabled item', (tester) async {
    _Action? selected;
    await pumpMenu(
      tester,
      onSelected: (value) => selected = value,
      items: const [
        EasyMoreMenuItem(value: _Action.edit, label: 'Edit', enabled: false),
        EasyMoreMenuItem(value: _Action.copy, label: 'Copy'),
      ],
    );

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('stays closed when the whole menu is disabled', (tester) async {
    await pumpMenu(tester, enabled: false, onSelected: (_) {});

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsNothing);
  });

  testWidgets('uses warning color for danger items', (tester) async {
    await pumpMenu(tester, onSelected: (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    final deleteText = tester.widget<Text>(find.text('Delete'));
    expect(deleteText.style?.color, EasyThemeData().warning);
  });

  testWidgets('scrolls long menus within a small viewport', (tester) async {
    tester.view.physicalSize = const Size(240, 140);
    addTearDown(tester.view.resetPhysicalSize);

    await pumpMenu(
      tester,
      onSelected: (_) {},
      items: List.generate(
        12,
        (index) => EasyMoreMenuItem(
          value: _Action.values[index % _Action.values.length],
          label: 'Action $index',
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Action 0'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(find.text('Action 11'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled menu absorbs interaction from a custom button', (
    tester,
  ) async {
    var customButtonPresses = 0;
    await pumpMenu(
      tester,
      enabled: false,
      onSelected: (_) {},
      button: ElevatedButton(
        onPressed: () => customButtonPresses++,
        child: const Text('Custom trigger'),
      ),
    );

    await tester.tap(find.text('Custom trigger'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(customButtonPresses, 0);
    expect(find.text('Edit'), findsNothing);
  });

  testWidgets('exposes trigger and item button semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpMenu(
      tester,
      onSelected: (_) {},
      semanticLabel: 'Parameter actions',
    );

    final trigger = tester.getSemantics(
      find.bySemanticsLabel('Parameter actions'),
    );
    expect(trigger.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(trigger.hasFlag(SemanticsFlag.isEnabled), isTrue);

    await tester.tap(find.bySemanticsLabel('Parameter actions'));
    await tester.pumpAndSettle();
    final editItem = tester.getSemantics(find.bySemanticsLabel('Edit'));
    expect(editItem.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(editItem.hasFlag(SemanticsFlag.isEnabled), isTrue);
    semantics.dispose();
  });
}
