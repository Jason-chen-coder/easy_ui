import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class G99SequencingQcDemo extends StatelessWidget {
  const G99SequencingQcDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);

    return Body.multi(
      children: [
        h1(l10n.g99SequencingQcExampleTitle),
        p(l10n.g99SequencingQcExampleDescription),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              width: double.infinity,
              child: G99SequencingStepContent(
                cycleQcData: _mockCycleQcData,
                laneQcRows: _mockLaneQcRows,
                sampleQcRows: _mockSampleQcRows,
                sequenceSummaryLanes: _mockSequenceSummaryLanes,
                fillRemaining: false,
              ),
            );
          },
          codeSnippet: '''
```dart
G99SequencingStepContent(
  cycleQcData: mockCycleQcData,
  laneQcRows: mockLaneQcRows,
  sampleQcRows: mockSampleQcRows,
  sequenceSummaryLanes: mockSequenceSummaryLanes,
  fillRemaining: false,
)
```
''',
        ),
        h2(l10n.g99SequencingQcMockDataCoverageTitle),
        p(l10n.g99SequencingQcMockDataCoverageDescription),
      ],
    );
  }
}

final _mockCycleQcData = G99CycleQcViewData(
  title: 'G99-20260629-A01',
  startTime: '2026-06-29 08:32:15',
  endTime: '2026-06-29 11:48:02',
  totalCycleCount: 12,
  metrics: const [
    G99CycleQcMetricValue(label: 'Total Cycles', value: '12'),
    G99CycleQcMetricValue(label: 'Mean CycQ30', value: '91.42%'),
    G99CycleQcMetricValue(label: 'Mean SNR', value: '13.86'),
    G99CycleQcMetricValue(label: 'Mean Signal', value: '468.25'),
    G99CycleQcMetricValue(label: 'Background', value: '18.34'),
    G99CycleQcMetricValue(label: 'Runon', value: '0.31%'),
  ],
  cycles: _mockCycleQcCycles,
);

final _mockCycleQcCycles = [
  for (var cycle = 1; cycle <= 12; cycle += 1)
    G99CycleQcCycleData(
      cycle: cycle,
      metrics: {
        'CycQ30': 87.6 + cycle * 0.62,
        'CycQ30_A': 88.1 + cycle * 0.55,
        'CycQ30_G': 87.2 + cycle * 0.68,
        'CycQ30_C': 86.9 + cycle * 0.64,
        'CycQ30_T': 87.8 + cycle * 0.59,
        'SNR': 11.8 + cycle * 0.34,
        'SNR_A': 12.0 + cycle * 0.31,
        'SNR_G': 11.4 + cycle * 0.36,
        'SNR_C': 11.7 + cycle * 0.35,
        'SNR_T': 11.9 + cycle * 0.32,
        'Signal': 420 + cycle * 8.5,
        'Signal_A': 428 + cycle * 8.1,
        'Signal_G': 414 + cycle * 9.0,
        'Signal_C': 419 + cycle * 8.8,
        'Signal_T': 423 + cycle * 8.3,
        'Background': 21.0 - cycle * 0.42,
        'Background_A': 20.6 - cycle * 0.38,
        'Background_G': 21.4 - cycle * 0.45,
        'Background_C': 21.2 - cycle * 0.41,
        'Background_T': 20.9 - cycle * 0.39,
      },
    ),
];

const _mockLaneQcRows = [
  G99LaneQcRow(
    index: '1',
    summary: 'Pass',
    phredQual: '34.81',
    readNum: '1,284,923',
    baseNum: '192,738,450',
    nCount: '0.04',
    gc: '51.28',
    q10: '99.94',
    q20: '96.72',
    q30: '91.76',
    estErr: '0.18',
  ),
  G99LaneQcRow(
    index: '2',
    summary: 'Pass',
    phredQual: '35.04',
    readNum: '1,301,774',
    baseNum: '195,266,100',
    nCount: '0.03',
    gc: '50.86',
    q10: '99.96',
    q20: '97.18',
    q30: '92.04',
    estErr: '0.16',
  ),
  G99LaneQcRow(
    index: '3',
    summary: 'Review',
    phredQual: '32.67',
    readNum: '1,098,406',
    baseNum: '164,760,900',
    nCount: '0.11',
    gc: '52.43',
    q10: '99.71',
    q20: '94.85',
    q30: '89.32',
    estErr: '0.27',
  ),
  G99LaneQcRow(
    index: '4',
    summary: 'Pass',
    phredQual: '34.26',
    readNum: '1,242,083',
    baseNum: '186,312,450',
    nCount: '0.05',
    gc: '51.74',
    q10: '99.88',
    q20: '96.31',
    q30: '91.24',
    estErr: '0.19',
  ),
];

const _mockSampleQcRows = [
  G99SampleQcRow(
    sampleId: 'ALAB-G99-S001',
    metrics: {
      'Sam_GC': '50.84',
      'Sam_QC30_total': '91.76',
      'Sam_N_count_total': '0.04',
      'Sam_QC30_read1': '92.14',
      'Sam_QC30_read2': '91.38',
      'Sam_BaseNum': '128,492,300',
      'Sam_ReadNum': '856,615',
      'lib_BaseNum': '129,004,520',
      'Sam_QC10': '99.96',
      'Sam_QC20': '97.20',
      'Sam_Decoded_PCT': '34.28',
      'Sam_N_count_read1': '0.03',
      'Sam_N_count_read2': '0.05',
      'SAM_AT_SPLIT_READ1': '48.86',
      'SAM_AT_SPLIT_READ2': '49.07',
      'SAM_CG_SPLIT_READ1': '51.14',
      'SAM_CG_SPLIT_READ2': '50.93',
    },
  ),
  G99SampleQcRow(
    sampleId: 'ALAB-G99-S002',
    metrics: {
      'Sam_GC': '52.11',
      'Sam_QC30_total': '90.42',
      'Sam_N_count_total': '0.06',
      'Sam_QC30_read1': '91.25',
      'Sam_QC30_read2': '89.59',
      'Sam_BaseNum': '116,204,850',
      'Sam_ReadNum': '774,699',
      'lib_BaseNum': '116,886,500',
      'Sam_QC10': '99.90',
      'Sam_QC20': '96.36',
      'Sam_Decoded_PCT': '31.01',
      'Sam_N_count_read1': '0.05',
      'Sam_N_count_read2': '0.07',
      'SAM_AT_SPLIT_READ1': '47.38',
      'SAM_AT_SPLIT_READ2': '48.40',
      'SAM_CG_SPLIT_READ1': '52.62',
      'SAM_CG_SPLIT_READ2': '51.60',
    },
  ),
  G99SampleQcRow(
    sampleId: 'ALAB-G99-S003',
    metrics: {
      'Sam_GC': '49.73',
      'Sam_QC30_total': '92.08',
      'Sam_N_count_total': '0.03',
      'Sam_QC30_read1': '92.67',
      'Sam_QC30_read2': '91.49',
      'Sam_BaseNum': '130,911,450',
      'Sam_ReadNum': '872,743',
      'lib_BaseNum': '131,205,400',
      'Sam_QC10': '99.97',
      'Sam_QC20': '97.62',
      'Sam_Decoded_PCT': '34.71',
      'Sam_N_count_read1': '0.02',
      'Sam_N_count_read2': '0.04',
      'SAM_AT_SPLIT_READ1': '50.02',
      'SAM_AT_SPLIT_READ2': '50.52',
      'SAM_CG_SPLIT_READ1': '49.98',
      'SAM_CG_SPLIT_READ2': '49.48',
    },
  ),
];

const _mockSequenceSummaryLanes = [
  G99SequenceSummaryLane(
    laneName: 'L01',
    entries: [
      G99SequenceSummaryEntry(keyName: 'Flowcell ID', value: 'FC240629001'),
      G99SequenceSummaryEntry(keyName: 'Instrument', value: 'G99-08'),
      G99SequenceSummaryEntry(keyName: 'Run Mode', value: 'PE150'),
      G99SequenceSummaryEntry(keyName: 'Total Reads', value: '2,586,697'),
      G99SequenceSummaryEntry(keyName: 'Total Bases', value: '388,004,550'),
      G99SequenceSummaryEntry(keyName: 'Q30 Rate', value: '91.76%'),
    ],
  ),
  G99SequenceSummaryLane(
    laneName: 'L02',
    entries: [
      G99SequenceSummaryEntry(keyName: 'Flowcell ID', value: 'FC240629001'),
      G99SequenceSummaryEntry(keyName: 'Instrument', value: 'G99-08'),
      G99SequenceSummaryEntry(keyName: 'Run Mode', value: 'SE100'),
      G99SequenceSummaryEntry(keyName: 'Total Reads', value: '2,340,489'),
      G99SequenceSummaryEntry(keyName: 'Total Bases', value: '234,048,900'),
      G99SequenceSummaryEntry(keyName: 'Q30 Rate', value: '90.42%'),
    ],
  ),
];
