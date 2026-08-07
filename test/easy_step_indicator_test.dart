import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  Future<void> pumpStepIndicator(
    WidgetTester tester, {
    required int currentStep,
    int? selectedStep,
    double selectedStepScale = 1.15,
    ValueChanged<int>? onSelectedStepChanged,
    Map<int, EasyStepIndicatorStyle>? stepStyles,
    Map<int, Widget>? stepIcons,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: EasyTheme(
          data: EasyThemeData(),
          child: SizedBox(
            width: 480,
            child: EasyStepIndicator(
              stepsLength: 3,
              stepNames: const ['A', 'B', 'C'],
              currentStep: currentStep,
              selectedStep: selectedStep,
              selectedStepScale: selectedStepScale,
              onSelectedStepChanged: onSelectedStepChanged,
              stepStyles: stepStyles,
              stepIcons: stepIcons,
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer containerForStep(WidgetTester tester, String stepName) {
    return tester.widget<AnimatedContainer>(
      find.ancestor(
        of: find.text(stepName),
        matching: find.byType(AnimatedContainer),
      ),
    );
  }

  AnimatedScale scaleForStep(WidgetTester tester, String stepName) {
    return tester.widget<AnimatedScale>(
      find.ancestor(
        of: find.text(stepName),
        matching: find.byType(AnimatedScale),
      ),
    );
  }

  AnimatedDefaultTextStyle textStyleForStep(
    WidgetTester tester,
    String stepName,
  ) {
    return tester.widget<AnimatedDefaultTextStyle>(
      find.ancestor(
        of: find.text(stepName),
        matching: find.byType(AnimatedDefaultTextStyle),
      ),
    );
  }

  AnimatedPositioned positionedForStep(WidgetTester tester, String stepName) {
    return tester.widget<AnimatedPositioned>(
      find.ancestor(
        of: find.text(stepName),
        matching: find.byType(AnimatedPositioned),
      ),
    );
  }

  TweenAnimationBuilder<double> shadowOpacityAnimationForStep(
    WidgetTester tester,
    String stepName,
  ) {
    return tester.widget<TweenAnimationBuilder<double>>(
      find.ancestor(
        of: find.text(stepName),
        matching: find.byType(TweenAnimationBuilder<double>),
      ),
    );
  }

  CustomPaint shadowPaintForStep(WidgetTester tester, String stepName) {
    final customPaints =
        tester
            .widgetList<CustomPaint>(
              find.ancestor(
                of: find.text(stepName),
                matching: find.byType(CustomPaint),
              ),
            )
            .where((paint) => paint.painter != null)
            .toList();
    expect(customPaints, hasLength(1));
    return customPaints.single;
  }

  dynamic shadowPainterForStep(WidgetTester tester, String stepName) {
    return shadowPaintForStep(tester, stepName).painter as dynamic;
  }

  SvgPicture iconForStep(WidgetTester tester, int stepIndex) {
    return tester.widget<SvgPicture>(
      find.byKey(ValueKey('alab-step-indicator-icon-$stepIndex')),
    );
  }

  ColorMapper iconColorMapperForStep(WidgetTester tester, int stepIndex) {
    final bytesLoader = iconForStep(tester, stepIndex).bytesLoader;
    expect(bytesLoader, isA<SvgAssetLoader>());

    final colorMapper = (bytesLoader as SvgAssetLoader).colorMapper;
    expect(colorMapper, isNotNull);
    return colorMapper!;
  }

  Row labelRowForStep(WidgetTester tester, String stepName) {
    final textStyle = find.ancestor(
      of: find.text(stepName),
      matching: find.byType(AnimatedDefaultTextStyle),
    );

    return tester.widget<Row>(
      find.descendant(of: textStyle, matching: find.byType(Row)),
    );
  }

  double stepWidthForStep(WidgetTester tester, String stepName) {
    return positionedForStep(tester, stepName).width!;
  }

  double indicatorWidth(WidgetTester tester) {
    return tester.getSize(find.byType(LayoutBuilder)).width;
  }

  testWidgets('emits selected step changes when tapped', (tester) async {
    int? changedStep;

    await pumpStepIndicator(
      tester,
      currentStep: 0,
      selectedStep: 0,
      onSelectedStepChanged: (step) {
        changedStep = step;
      },
    );

    await tester.tap(find.text('B'));

    expect(changedStep, 1);
  });

  testWidgets('uses selectedStep for emphasis independently of currentStep', (
    tester,
  ) async {
    await pumpStepIndicator(tester, currentStep: 0, selectedStep: 2);
    await tester.pumpAndSettle();

    expect(
      stepWidthForStep(tester, 'C'),
      greaterThan(stepWidthForStep(tester, 'A')),
    );
    expect(scaleForStep(tester, 'C').scale, 1.15);
    expect(
      stepWidthForStep(tester, 'A'),
      closeTo(stepWidthForStep(tester, 'B'), 0.001),
    );

    final currentStepContainer = containerForStep(tester, 'A');
    final selectedStepContainer = containerForStep(tester, 'C');
    expect(
      (currentStepContainer.decoration as BoxDecoration).color,
      const Color(0xFFB5F2DD),
    );
    expect(
      (selectedStepContainer.decoration as BoxDecoration).color,
      EasyThemeData().neutralF8,
    );
  });

  testWidgets('uses 1.15 as the default selectedStepScale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EasyTheme(
          data: EasyThemeData(),
          child: const SizedBox(
            width: 480,
            child: EasyStepIndicator(
              stepsLength: 3,
              stepNames: ['A', 'B', 'C'],
              currentStep: 0,
              selectedStep: 2,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(scaleForStep(tester, 'C').scale, 1.15);
    expect(
      stepWidthForStep(tester, 'C') / stepWidthForStep(tester, 'A'),
      closeTo(1.15, 0.001),
    );
  });

  testWidgets('uses custom selectedStepScale for selected emphasis', (
    tester,
  ) async {
    await pumpStepIndicator(
      tester,
      currentStep: 0,
      selectedStep: 2,
      selectedStepScale: 1.3,
    );
    await tester.pumpAndSettle();

    expect(scaleForStep(tester, 'C').scale, 1.3);
    expect(
      stepWidthForStep(tester, 'C') / stepWidthForStep(tester, 'A'),
      closeTo(1.3, 0.001),
    );
  });

  testWidgets('updates selected emphasis from external selectedStep state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EasyTheme(
          data: EasyThemeData(),
          child: const _SelectableStepIndicatorHarness(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(
      stepWidthForStep(tester, 'A'),
      greaterThan(stepWidthForStep(tester, 'B')),
    );
    expect(scaleForStep(tester, 'A').scale, 1.15);
    expect(scaleForStep(tester, 'B').scale, 1.0);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(
      stepWidthForStep(tester, 'B'),
      greaterThan(stepWidthForStep(tester, 'A')),
    );
    expect(scaleForStep(tester, 'A').scale, 1.0);
    expect(scaleForStep(tester, 'B').scale, 1.15);
    expect(
      stepWidthForStep(tester, 'A'),
      closeTo(stepWidthForStep(tester, 'C'), 0.001),
    );
  });

  testWidgets('animates selected emphasis changes over 0.3 seconds', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EasyTheme(
          data: EasyThemeData(),
          child: const _SelectableStepIndicatorHarness(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('B'));
    await tester.pump();

    expect(
      positionedForStep(tester, 'B').duration,
      const Duration(milliseconds: 300),
    );
    expect(
      scaleForStep(tester, 'B').duration,
      const Duration(milliseconds: 300),
    );
    expect(
      shadowOpacityAnimationForStep(tester, 'B').duration,
      const Duration(milliseconds: 300),
    );
    expect(shadowPainterForStep(tester, 'B').shadow.offset, Offset.zero);
    expect(shadowPainterForStep(tester, 'B').shadow.blurRadius, 14);
    expect(shadowPainterForStep(tester, 'B').shadow.spreadRadius, 0);
    expect(shadowPainterForStep(tester, 'B').shadowOpacity, 0);

    await tester.pump(const Duration(milliseconds: 150));
    final midpointOpacity = shadowPainterForStep(tester, 'B').shadowOpacity;
    expect(midpointOpacity, greaterThan(0));
    expect(midpointOpacity, lessThan(1));

    await tester.pumpAndSettle();
    expect(shadowPainterForStep(tester, 'B').shadowOpacity, 1);
  });

  testWidgets(
    'lets the selected step take scaled width while others share the rest',
    (tester) async {
      await pumpStepIndicator(
        tester,
        currentStep: 0,
        selectedStep: 0,
        selectedStepScale: 1.5,
      );
      await tester.pumpAndSettle();

      expect(
        stepWidthForStep(tester, 'A'),
        greaterThan(stepWidthForStep(tester, 'B')),
      );
      expect(
        stepWidthForStep(tester, 'B'),
        closeTo(stepWidthForStep(tester, 'C'), 0.001),
      );
      expect(
        stepWidthForStep(tester, 'A') / stepWidthForStep(tester, 'B'),
        closeTo(1.5, 0.001),
      );
      expect(scaleForStep(tester, 'A').scale, 1.5);
      expect(scaleForStep(tester, 'A').alignment, Alignment.centerLeft);
      expect(scaleForStep(tester, 'B').scale, 1.0);
      expect(positionedForStep(tester, 'A').left, 0);
      expect(
        positionedForStep(tester, 'C').left! + stepWidthForStep(tester, 'C'),
        closeTo(indicatorWidth(tester), 0.001),
      );

      await pumpStepIndicator(
        tester,
        currentStep: 0,
        selectedStep: 2,
        selectedStepScale: 1.5,
      );
      await tester.pumpAndSettle();

      expect(
        stepWidthForStep(tester, 'C'),
        greaterThan(stepWidthForStep(tester, 'A')),
      );
      expect(
        stepWidthForStep(tester, 'A'),
        closeTo(stepWidthForStep(tester, 'B'), 0.001),
      );
      expect(
        stepWidthForStep(tester, 'C') / stepWidthForStep(tester, 'A'),
        closeTo(1.5, 0.001),
      );
      expect(scaleForStep(tester, 'A').scale, 1.0);
      expect(scaleForStep(tester, 'C').scale, 1.5);
      expect(scaleForStep(tester, 'C').alignment, Alignment.centerRight);
      expect(positionedForStep(tester, 'A').left, 0);
      expect(
        positionedForStep(tester, 'C').left! + stepWidthForStep(tester, 'C'),
        closeTo(indicatorWidth(tester), 0.001),
      );
    },
  );

  testWidgets('does not emphasize any step when selectedStep is null', (
    tester,
  ) async {
    await pumpStepIndicator(tester, currentStep: 1);
    await tester.pumpAndSettle();

    expect(
      stepWidthForStep(tester, 'A'),
      closeTo(stepWidthForStep(tester, 'B'), 0.001),
    );
    expect(
      stepWidthForStep(tester, 'B'),
      closeTo(stepWidthForStep(tester, 'C'), 0.001),
    );
    expect(scaleForStep(tester, 'A').scale, 1.0);
    expect(scaleForStep(tester, 'B').scale, 1.0);
    expect(scaleForStep(tester, 'C').scale, 1.0);
  });

  testWidgets(
    'does not fall back to currentStep when selectedStep is invalid',
    (tester) async {
      await pumpStepIndicator(tester, currentStep: 1, selectedStep: 99);
      await tester.pumpAndSettle();

      expect(
        stepWidthForStep(tester, 'A'),
        closeTo(stepWidthForStep(tester, 'B'), 0.001),
      );
      expect(
        stepWidthForStep(tester, 'B'),
        closeTo(stepWidthForStep(tester, 'C'), 0.001),
      );
      expect(scaleForStep(tester, 'A').scale, 1.0);
      expect(scaleForStep(tester, 'B').scale, 1.0);
      expect(scaleForStep(tester, 'C').scale, 1.0);
    },
  );

  testWidgets('uses custom step colors from stepStyles', (tester) async {
    await pumpStepIndicator(
      tester,
      currentStep: 0,
      selectedStep: 2,
      stepStyles: const {
        1: (
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          iconBackgroundColor: null,
          iconColor: null,
        ),
      },
    );

    await tester.pumpAndSettle();

    expect(
      (containerForStep(tester, 'B').decoration as BoxDecoration).color,
      Colors.orange,
    );

    final customStepTextStyle = tester.widget<AnimatedDefaultTextStyle>(
      find.ancestor(
        of: find.text('B'),
        matching: find.byType(AnimatedDefaultTextStyle),
      ),
    );
    expect(customStepTextStyle.style.color, Colors.white);
  });

  testWidgets('uses custom icon colors from stepStyles', (tester) async {
    await pumpStepIndicator(
      tester,
      currentStep: 1,
      stepStyles: const {
        1: (
          backgroundColor: null,
          textColor: null,
          iconBackgroundColor: Colors.purple,
          iconColor: Colors.black,
        ),
      },
    );

    await tester.pumpAndSettle();

    final iconColorMapper = iconColorMapperForStep(tester, 1);
    expect(
      iconColorMapper.substitute(null, 'rect', 'fill', const Color(0xFF31DA9F)),
      Colors.purple,
    );
    expect(
      iconColorMapper.substitute(null, 'path', 'stroke', Colors.white),
      Colors.black,
    );

    expect(
      (containerForStep(tester, 'B').decoration as BoxDecoration).color,
      const Color(0xFFB5F2DD),
    );
    expect(
      textStyleForStep(tester, 'B').style.color,
      EasyThemeData().primaryGreen,
    );
  });

  testWidgets('uses custom step icons by index', (tester) async {
    await pumpStepIndicator(
      tester,
      currentStep: 1,
      stepIcons: const {
        1: Icon(Icons.warning, key: ValueKey('custom-step-icon')),
      },
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('custom-step-icon')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('alab-step-indicator-icon-1')),
      findsNothing,
    );
    expect(
      iconForStep(tester, 0).bytesLoader.toString(),
      'SvgAssetLoader(assets/svgs/ic_did.svg)',
    );
    expect(
      iconForStep(tester, 2).bytesLoader.toString(),
      'SvgAssetLoader(assets/svgs/ic_waiting.svg)',
    );
  });

  testWidgets('shows 14px status badges 12px before each step label', (
    tester,
  ) async {
    await pumpStepIndicator(tester, currentStep: 1);
    await tester.pumpAndSettle();

    expect(
      iconForStep(tester, 0).bytesLoader.toString(),
      'SvgAssetLoader(assets/svgs/ic_did.svg)',
    );
    expect(
      iconColorMapperForStep(
        tester,
        0,
      ).substitute(null, 'circle', 'fill', Colors.white),
      Colors.white,
    );
    expect(
      iconColorMapperForStep(
        tester,
        0,
      ).substitute(null, 'path', 'fill', const Color(0xFF31DA9F)),
      EasyThemeData().primaryGreen,
    );
    expect(
      iconForStep(tester, 1).bytesLoader.toString(),
      'SvgAssetLoader(assets/svgs/ic_doing.svg)',
    );
    expect(
      iconColorMapperForStep(
        tester,
        1,
      ).substitute(null, 'rect', 'fill', const Color(0xFF31DA9F)),
      EasyThemeData().primaryGreen,
    );
    expect(
      iconColorMapperForStep(
        tester,
        1,
      ).substitute(null, 'path', 'stroke', Colors.white),
      Colors.white,
    );
    expect(
      iconForStep(tester, 2).bytesLoader.toString(),
      'SvgAssetLoader(assets/svgs/ic_waiting.svg)',
    );
    expect(
      iconColorMapperForStep(
        tester,
        2,
      ).substitute(null, 'rect', 'fill', const Color(0xFF999999)),
      const Color(0xFF999999),
    );
    expect(
      iconColorMapperForStep(
        tester,
        2,
      ).substitute(null, 'path', 'fill', Colors.white),
      Colors.white,
    );

    for (final stepName in ['A', 'B', 'C']) {
      final row = labelRowForStep(tester, stepName);
      expect(row.children, hasLength(3));
      expect(row.children.first, isA<SvgPicture>());
      expect((row.children.first as SvgPicture).width, 14);
      expect((row.children.first as SvgPicture).height, 14);
      expect(row.children[1], isA<SizedBox>());
      expect((row.children[1] as SizedBox).width, 12);
    }

    expect(
      (containerForStep(tester, 'A').decoration as BoxDecoration).color,
      EasyThemeData().primaryGreen,
    );
    expect(
      textStyleForStep(tester, 'A').style.color,
      EasyThemeData().background,
    );

    expect(
      (containerForStep(tester, 'B').decoration as BoxDecoration).color,
      const Color(0xFFB5F2DD),
    );
    expect(
      textStyleForStep(tester, 'B').style.color,
      EasyThemeData().primaryGreen,
    );

    expect(
      (containerForStep(tester, 'C').decoration as BoxDecoration).color,
      EasyThemeData().neutralF8,
    );
    expect(
      textStyleForStep(tester, 'C').style.color,
      EasyThemeData().neutral99,
    );
  });
}

class _SelectableStepIndicatorHarness extends StatefulWidget {
  const _SelectableStepIndicatorHarness();

  @override
  State<_SelectableStepIndicatorHarness> createState() =>
      _SelectableStepIndicatorHarnessState();
}

class _SelectableStepIndicatorHarnessState
    extends State<_SelectableStepIndicatorHarness> {
  int _selectedStep = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 480,
      child: EasyStepIndicator(
        stepsLength: 3,
        stepNames: const ['A', 'B', 'C'],
        currentStep: 2,
        selectedStep: _selectedStep,
        onSelectedStepChanged: (step) {
          setState(() {
            _selectedStep = step;
          });
        },
      ),
    );
  }
}
