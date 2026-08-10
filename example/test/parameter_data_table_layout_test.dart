import 'package:easy_ui/easy_ui.dart';
import 'package:example/view/data_entry/tool_tip.dart' as tool_tip_example;
import 'package:example/widgets/example_easy_widgets.dart' as example_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('parameter table fills the available parent width', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(parentWidth: 720, columnCount: 3));
    await tester.pump();

    expect(tester.getSize(find.byType(EasyDataTable)).width, 720);
  });

  testWidgets('parameter table scrolls horizontally inside a narrow parent', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(parentWidth: 320, columnCount: 5));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(EasyDataTable)).width, 320);

    final horizontalScrollable = find.descendant(
      of: find.byType(EasyDataTable),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable &&
            axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
      ),
    );
    expect(horizontalScrollable, findsOneWidget);

    final scrollableState = tester.state<ScrollableState>(horizontalScrollable);
    expect(scrollableState.position.maxScrollExtent, greaterThan(0));
  });

  testWidgets(
    'ToolTip parameter table receives the full example content width',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            data: EasyThemeData(),
            child: const tool_tip_example.ToolTip(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(EasyDataTable), findsOneWidget);
      expect(
        tester.getSize(find.byType(EasyDataTable)).width,
        greaterThan(800),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _testApp({required double parentWidth, required int columnCount}) {
  return MaterialApp(
    home: EasyTheme(
      data: EasyThemeData(),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: parentWidth,
            child: Align(
              alignment: Alignment.topLeft,
              child: example_widgets.DataTable(
                columns: List.generate(
                  columnCount,
                  (index) => DataColumn(label: Text('Column $index')),
                ),
                rows: [
                  DataRow(
                    cells: List.generate(
                      columnCount,
                      (index) => DataCell(Text('Value $index')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
