import 'package:easy_ui/easy_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('G99CycleQcViewData converts to and from string', () {
    const data = G99CycleQcViewData(
      title: 'Run G99-20260629-A01',
      startTime: '2026-06-29 08:32:15',
      endTime: '2026-06-29 11:48:02',
      totalCycleCount: 120,
      metrics: [G99CycleQcMetricValue(label: 'Mean CycQ30', value: '91.42%')],
      series: [
        G99CycleQcSeriesData(
          label: 'CycQ30',
          color: Color(0xFF55ACED),
          points: [
            G99CycleQcPointData(cycle: 1, value: 89.5),
            G99CycleQcPointData(cycle: 2, value: 91.2),
          ],
        ),
      ],
      cycles: [
        G99CycleQcCycleData(
          cycle: 1,
          metrics: {'CycQ30': 89.5, 'Signal_A': '128.2'},
        ),
      ],
    );

    final parsed = G99CycleQcViewData.fromString(data.toString());

    expect(parsed.title, data.title);
    expect(parsed.startTime, data.startTime);
    expect(parsed.endTime, data.endTime);
    expect(parsed.totalCycleCount, data.totalCycleCount);
    expect(parsed.metrics.single.label, 'Mean CycQ30');
    expect(parsed.metrics.single.value, '91.42%');
    expect(parsed.series.single.label, 'CycQ30');
    expect(parsed.series.single.color, const Color(0xFF55ACED));
    expect(parsed.series.single.points.last.cycle, 2);
    expect(parsed.series.single.points.last.value, 91.2);
    expect(parsed.cycles.single.cycle, 1);
    expect(parsed.cycles.single.metrics['Signal_A'], '128.2');
  });

  test('G99CycleQcViewData matches cycle metric keys case-insensitively', () {
    const data = G99CycleQcViewData(
      title: 'First Base',
      metrics: [G99CycleQcMetricValue(label: 'Fit', value: '0.795')],
      cycles: [
        G99CycleQcCycleData(cycle: 1, metrics: {'Fit': 0.795, 'Fit_A': 0.812}),
      ],
    );

    final series = data.seriesFor('FIT');

    expect(series, hasLength(2));
    expect(series[0].label, 'FIT');
    expect(series[0].points.single.value, 0.795);
    expect(series[1].label, 'A');
    expect(series[1].points.single.value, 0.812);
  });

  testWidgets('G99 sequence summary renders lane names', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: const G99SequenceSummaryPanel(
          lanes: [
            G99SequenceSummaryLane(
              laneName: 'Lane A',
              entries: [
                G99SequenceSummaryEntry(keyName: 'Total Reads', value: '1200'),
              ],
            ),
            G99SequenceSummaryLane(
              laneName: 'Lane B',
              entries: [
                G99SequenceSummaryEntry(keyName: 'Q30 Rate', value: '91.2%'),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('Lane A'), findsOneWidget);
    expect(find.text('Lane B'), findsOneWidget);
  });

  testWidgets('G99 sequencing segments use Chinese localizations', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('zh'),
        child: const G99SequencingStepContent(
          cycleQcData: G99CycleQcViewData.empty,
          laneQcRows: [],
          sampleQcRows: [],
          sequenceSummaryLanes: [],
          fillRemaining: false,
        ),
      ),
    );

    expect(find.text('Cycle QC'), findsOneWidget);
    expect(find.text('Lane QC'), findsOneWidget);
    expect(find.text('Sample QC'), findsOneWidget);
    expect(find.text('Sequence Summary'), findsOneWidget);
    expect(find.text('循环质控'), findsNothing);
    expect(find.text('样本质控'), findsNothing);
  });

  test('G99 lane QC exposes Q30 and estimated error columns', () {
    const row = G99LaneQcRow(
      index: '1',
      summary: 'Read1',
      phredQual: '33',
      readNum: '47680329',
      baseNum: '95360658',
      nCount: '2.193',
      gc: '24.937',
      q10: '81.634',
      q20: '73.718',
      q30: '69.125',
      estErr: '0.170',
    );

    expect(row.valueForColumn(9), '69.125');
    expect(row.valueForColumn(10), '0.170');
  });

  testWidgets('G99 lane QC renders index as the first column', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: const G99SequencingStepContent(
          cycleQcData: G99CycleQcViewData.empty,
          laneQcRows: [
            G99LaneQcRow(
              index: '1',
              summary: 'Read1',
              phredQual: '33',
              readNum: '47680329',
              baseNum: '95360658',
              nCount: '2.193',
              gc: '24.937',
              q10: '81.634',
              q20: '73.718',
              q30: '69.125',
              estErr: '0.170',
            ),
          ],
          sampleQcRows: [],
          sequenceSummaryLanes: [],
          fillRemaining: false,
        ),
      ),
    );

    await tester.tap(find.text('Lane QC'));
    await tester.pump();

    final laneQcTable = find.byKey(const ValueKey('g99-lane-qc-table'));
    expect(laneQcTable, findsOneWidget);
    expect(
      find.descendant(of: laneQcTable, matching: find.text('序号')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: laneQcTable, matching: find.text('1')),
      findsOneWidget,
    );
  });

  testWidgets('G99 sample QC renders barcode summary statistic rows', (
    tester,
  ) async {
    const read1Row = G99SampleQcRow(
      barcodeId: '9-1',
      sampleId: 'RAW-SAMPLE-001',
      summary: 'Read1',
      metrics: {
        'PhredQual': '33',
        'ReadNum': '16567190',
        'BaseNum': '2485078500',
        'N_Count%': '0.002',
        'GC%': '50.970',
        'Q10%': '99.666',
        'Q20%': '98.579',
        'Q30%': '96.484',
        'Q40%': '',
        'EstErr%': '0.170',
      },
    );
    const totalReadRow = G99SampleQcRow(
      barcodeId: '9-1',
      sampleId: 'RAW-SAMPLE-001',
      summary: 'Total Read',
      metrics: {
        'PhredQual': '33',
        'ReadNum': '16567190',
        'BaseNum': '4970157000',
        'N_Count%': '0.002',
        'GC%': '50.970',
        'Q10%': '99.666',
        'Q20%': '98.579',
        'Q30%': '96.484',
        'Q40%': '',
        'EstErr%': '0.170',
      },
    );

    await tester.pumpWidget(
      _buildTestApp(
        child: const G99SequencingStepContent(
          cycleQcData: G99CycleQcViewData.empty,
          laneQcRows: [],
          sampleQcRows: [read1Row, totalReadRow],
          sequenceSummaryLanes: [],
          fillRemaining: false,
        ),
      ),
    );

    await tester.tap(find.text('Sample QC'));
    await tester.pump();

    expect(find.text('BarCode'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('PhredQual'), findsOneWidget);
    expect(find.text('ReadNum'), findsOneWidget);
    expect(find.text('BaseNum'), findsOneWidget);
    expect(find.text('N_Count%'), findsOneWidget);
    expect(find.text('9-1'), findsWidgets);
    expect(find.text('Read1'), findsOneWidget);
    expect(find.text('Total Read'), findsOneWidget);
    expect(find.text('RAW-SAMPLE-001'), findsNothing);
    expect(find.text('33'), findsWidgets);
    expect(find.text('16567190'), findsWidgets);
    expect(find.text('4970157000'), findsOneWidget);
    expect(read1Row.valueForColumn(6), '50.970');
    expect(read1Row.valueForColumn(7), '99.666');
    expect(read1Row.valueForColumn(8), '98.579');
    expect(read1Row.valueForColumn(9), '96.484');
    expect(read1Row.valueForColumn(10), '');
    expect(read1Row.valueForColumn(11), '0.170');
  });

  testWidgets('G99 sample QC can show sample code next to barcode', (
    tester,
  ) async {
    const row = G99SampleQcRow(
      barcodeId: '1',
      sampleCode: 'YBC260629003',
      summary: 'Read1',
      metrics: {'PhredQual': '33'},
    );

    await tester.pumpWidget(
      _buildTestApp(
        child: const G99SequencingStepContent(
          cycleQcData: G99CycleQcViewData.empty,
          laneQcRows: [],
          sampleQcRows: [row],
          sequenceSummaryLanes: [],
          fillRemaining: false,
          showSampleCodeColumn: true,
        ),
      ),
    );

    await tester.tap(find.text('Sample QC'));
    await tester.pump();

    final sampleQcTable = find.byKey(const ValueKey('g99-sample-qc-table'));
    expect(sampleQcTable, findsOneWidget);
    expect(
      find.descendant(of: sampleQcTable, matching: find.text('样本编号')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sampleQcTable, matching: find.text('YBC260629003')),
      findsOneWidget,
    );
  });

  testWidgets('G99 cycle QC metric list uses English time labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('en'),
        child: const G99CycleQcMetricList(
          title: 'Run G99-20260629-A01',
          startTime: '2026-06-29 08:32:15',
          endTime: '2026-06-29 11:48:02',
          metrics: [
            G99CycleQcMetricValue(label: 'Mean CycQ30', value: '91.42%'),
          ],
        ),
      ),
    );

    expect(find.text('Start Time: 2026-06-29 08:32:15'), findsOneWidget);
    expect(find.text('End Time: 2026-06-29 11:48:02'), findsOneWidget);
    expect(find.text('开始时间： 2026-06-29 08:32:15'), findsNothing);
  });

  testWidgets('G99 cycle QC metric list renders the provided title', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: const G99CycleQcMetricList(
          title: 'Run G99-20260629-A01',
          startTime: '2026-06-29 08:32:15',
          endTime: '2026-06-29 11:48:02',
          metrics: [
            G99CycleQcMetricValue(label: 'Mean CycQ30', value: '91.42%'),
          ],
        ),
      ),
    );

    expect(find.text('Run G99-20260629-A01'), findsOneWidget);
    expect(find.text('First Base'), findsNothing);
  });

  testWidgets(
    'G99 cycle QC metric list formats numeric values up to 3 decimals',
    (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const G99CycleQcMetricList(
            title: 'First Base',
            startTime: '2026-06-29 08:32:15',
            endTime: '2026-06-29 11:48:02',
            metrics: [
              G99CycleQcMetricValue(label: 'Signal_A', value: '1.586864E+07'),
              G99CycleQcMetricValue(label: 'Mean CycQ30', value: '91.42%'),
              G99CycleQcMetricValue(label: 'Background', value: '18.34567'),
            ],
          ),
        ),
      );

      expect(find.text('15868640'), findsOneWidget);
      expect(find.text('91.42%'), findsOneWidget);
      expect(find.text('18.346'), findsOneWidget);
      expect(find.text('15868640.000'), findsNothing);
      expect(find.text('91.420%'), findsNothing);
      expect(find.text('1.586864E+07'), findsNothing);
      expect(find.text('18.34567'), findsNothing);
    },
  );

  testWidgets('G99 cycle QC chart formats near-zero Y axis labels as zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: SizedBox(
          width: 640,
          height: 640,
          child: G99CycleQcChartPanel(
            selectedMetric: 'Base',
            totalCycleCount: null,
            onMetricChanged: (_) {},
            series: const [
              G99CycleQcSeriesData(
                label: 'A',
                color: Color(0xFF55ACED),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 2, value: 0),
                  G99CycleQcPointData(cycle: 4, value: 0),
                  G99CycleQcPointData(cycle: 5, value: 0),
                  G99CycleQcPointData(cycle: 6, value: 0),
                  G99CycleQcPointData(cycle: 8, value: 0),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'G',
                color: Color(0xFF4FCDB4),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 2, value: 0),
                  G99CycleQcPointData(cycle: 4, value: 0),
                  G99CycleQcPointData(cycle: 5, value: 0),
                  G99CycleQcPointData(cycle: 6, value: 0),
                  G99CycleQcPointData(cycle: 8, value: 0),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'C',
                color: Color(0xFFB044F6),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 2, value: 0),
                  G99CycleQcPointData(cycle: 4, value: 0),
                  G99CycleQcPointData(cycle: 5, value: 0),
                  G99CycleQcPointData(cycle: 6, value: 0),
                  G99CycleQcPointData(cycle: 8, value: 0),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'T',
                color: Color(0xFFFFA12B),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 2, value: 0),
                  G99CycleQcPointData(cycle: 4, value: 0),
                  G99CycleQcPointData(cycle: 5, value: 0),
                  G99CycleQcPointData(cycle: 6, value: 0),
                  G99CycleQcPointData(cycle: 8, value: 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.textContaining('e-'), findsNothing);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('G99 cycle QC chart keeps the last cycle label readable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: SizedBox(
          width: 640,
          height: 640,
          child: G99CycleQcChartPanel(
            selectedMetric: 'CycQ30',
            totalCycleCount: 111,
            onMetricChanged: (_) {},
            series: const [
              G99CycleQcSeriesData(
                label: 'CycQ30',
                color: Color(0xFF55ACED),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 2, value: 0),
                  G99CycleQcPointData(cycle: 3, value: 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    expect(chart.data.titlesData.bottomTitles.sideTitles.interval, 23);
    expect(find.text('110'), findsNothing);
    expect(find.text('111'), findsOneWidget);
  });

  testWidgets('G99 cycle QC chart tooltip formats values up to 3 decimals', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        child: SizedBox(
          width: 640,
          height: 640,
          child: G99CycleQcChartPanel(
            selectedMetric: 'Base',
            totalCycleCount: null,
            onMetricChanged: (_) {},
            series: const [
              G99CycleQcSeriesData(
                label: 'A',
                color: Color(0xFF55ACED),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 30, value: 0),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'G',
                color: Color(0xFF4FCDB4),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 30, value: 1.234),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'C',
                color: Color(0xFFB044F6),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 30, value: 2.346),
                ],
              ),
              G99CycleQcSeriesData(
                label: 'T',
                color: Color(0xFFFFA12B),
                points: [
                  G99CycleQcPointData(cycle: 1, value: 0),
                  G99CycleQcPointData(cycle: 30, value: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    final bars = chart.data.lineBarsData;
    final tooltipItems = chart.data.lineTouchData.touchTooltipData
        .getTooltipItems([
          LineBarSpot(bars[0], 0, bars[0].spots[1]),
          LineBarSpot(bars[1], 1, bars[1].spots[1]),
          LineBarSpot(bars[2], 2, bars[2].spots[1]),
          LineBarSpot(bars[3], 3, bars[3].spots[1]),
        ]);

    expect(tooltipItems.map((item) => item?.text).toList(), [
      'cycle:30\nA: 0',
      'G: 1.234',
      'C: 2.346',
      'T: 10',
    ]);
    expect(
      tooltipItems.map((item) => item?.textAlign).toList(),
      List.filled(4, TextAlign.left),
    );
  });
}

Widget _buildTestApp({
  required Widget child,
  Locale locale = const Locale('zh'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: EasyUiLocalizations.supportedLocales,
    localizationsDelegates: EasyUiLocalizations.localizationsDelegates,
    home: EasyTheme(data: EasyThemeData(), child: Scaffold(body: child)),
  );
}
