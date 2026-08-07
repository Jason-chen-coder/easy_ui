import 'dart:convert';

import 'package:easy_ui/easy_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class G99SequenceSummaryLane {
  const G99SequenceSummaryLane({required this.laneName, required this.entries});

  final String laneName;
  final List<G99SequenceSummaryEntry> entries;
}

class G99SequenceSummaryEntry {
  const G99SequenceSummaryEntry({required this.keyName, required this.value});

  final String keyName;
  final String value;
}

class G99SequenceSummaryPanel extends StatelessWidget {
  const G99SequenceSummaryPanel({super.key, required this.lanes});

  final List<G99SequenceSummaryLane> lanes;

  @override
  Widget build(BuildContext context) {
    final summaryLanes =
        lanes.where((lane) => lane.entries.isNotEmpty).toList();

    if (summaryLanes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: EasyEmptyView(),
      );
    }

    return Container(
      key: const ValueKey('g99-sequence-summary-panel'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (
              var laneIndex = 0;
              laneIndex < summaryLanes.length;
              laneIndex += 1
            ) ...[
              Text(
                summaryLanes[laneIndex].laneName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: summaryLanes[laneIndex].entries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 70,
                ),
                itemBuilder: (context, entryIndex) {
                  final entry = summaryLanes[laneIndex].entries[entryIndex];
                  return _G99SequenceSummaryItem(
                    laneIndex: laneIndex,
                    entry: entry,
                  );
                },
              ),
              if (laneIndex != summaryLanes.length - 1)
                const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _G99SequenceSummaryItem extends StatelessWidget {
  const _G99SequenceSummaryItem({required this.laneIndex, required this.entry});

  final int laneIndex;
  final G99SequenceSummaryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          entry.keyName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          key: ValueKey(
            'g99-sequence-summary-value-box-$laneIndex-${entry.keyName}',
          ),
          height: 34,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            entry.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class G99LaneQcRow {
  const G99LaneQcRow({
    required this.index,
    required this.summary,
    required this.phredQual,
    required this.readNum,
    required this.baseNum,
    required this.nCount,
    required this.gc,
    required this.q10,
    required this.q20,
    required this.q30,
    required this.estErr,
  });

  final String index;
  final String summary;
  final String phredQual;
  final String readNum;
  final String baseNum;
  final String nCount;
  final String gc;
  final String q10;
  final String q20;
  final String q30;
  final String estErr;

  String valueForColumn(int column) {
    return switch (column) {
      0 => index,
      1 => summary,
      2 => phredQual,
      3 => readNum,
      4 => baseNum,
      5 => nCount,
      6 => gc,
      7 => q10,
      8 => q20,
      9 => q30,
      10 => estErr,
      _ => '',
    };
  }
}

class G99SampleQcRow {
  const G99SampleQcRow({
    this.barcodeId,
    this.sampleId,
    this.sampleCode,
    this.summary,
    required this.metrics,
  });

  final String? barcodeId;
  final String? sampleId;
  final String? sampleCode;
  final String? summary;
  final Map<String, String> metrics;

  String valueForColumn(int column) {
    if (column == 0) {
      return barcodeId ?? sampleId ?? '--';
    }
    if (column == 1) {
      return summary ?? '--';
    }
    return metrics[_g99SampleQcColumns[column]] ?? '--';
  }

  String _valueForColumnName(String columnName) {
    if (columnName == _g99SampleQcSampleCodeColumnKey) {
      return sampleCode ?? '--';
    }
    final column = _g99SampleQcColumns.indexOf(columnName);
    return column == -1 ? '--' : valueForColumn(column);
  }
}

class G99CycleQcViewData {
  const G99CycleQcViewData({
    required this.title,
    required this.metrics,
    this.startTime = '--',
    this.endTime = '--',
    this.totalCycleCount,
    this.series = const [],
    this.cycles = const [],
  });

  static const empty = G99CycleQcViewData(title: '--', metrics: []);

  final String title;
  final List<G99CycleQcMetricValue> metrics;
  final String startTime;
  final String endTime;
  final int? totalCycleCount;
  final List<G99CycleQcSeriesData> series;
  final List<G99CycleQcCycleData> cycles;

  factory G99CycleQcViewData.fromString(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return G99CycleQcViewData(
      title: map['title'] as String,
      metrics:
          (map['metrics'] as List<dynamic>)
              .map((metric) => _g99CycleQcMetricFromMap(metric as Map))
              .toList(),
      startTime: map['startTime'] as String? ?? '--',
      endTime: map['endTime'] as String? ?? '--',
      totalCycleCount: map['totalCycleCount'] as int?,
      series:
          (map['series'] as List<dynamic>? ?? const [])
              .map((series) => _g99CycleQcSeriesFromMap(series as Map))
              .toList(),
      cycles:
          (map['cycles'] as List<dynamic>? ?? const [])
              .map((cycle) => _g99CycleQcCycleFromMap(cycle as Map))
              .toList(),
    );
  }

  bool get hasData =>
      metrics.isNotEmpty || series.isNotEmpty || cycles.isNotEmpty;

  @override
  String toString() {
    return json.encode({
      'title': title,
      'metrics': metrics.map(_g99CycleQcMetricToMap).toList(),
      'startTime': startTime,
      'endTime': endTime,
      'totalCycleCount': totalCycleCount,
      'series': series.map(_g99CycleQcSeriesToMap).toList(),
      'cycles': cycles.map(_g99CycleQcCycleToMap).toList(),
    });
  }

  List<G99CycleQcSeriesData> seriesFor(String metricKey) {
    if (cycles.isEmpty) {
      return metricKey == _g99CycleQcDefaultMetric ? series : const [];
    }

    final chartSeries = <G99CycleQcSeriesData>[];
    final single = _seriesForKey(
      metricKey: metricKey,
      label: metricKey,
      colorIndex: chartSeries.length,
    );
    if (single != null) {
      chartSeries.add(single);
    }

    for (final base in const ['A', 'G', 'C', 'T']) {
      final keyed = _seriesForKey(
        metricKey: '${metricKey}_$base',
        label: base,
        colorIndex: chartSeries.length,
      );
      if (keyed != null) {
        chartSeries.add(keyed);
      }
    }

    return chartSeries;
  }

  G99CycleQcSeriesData? _seriesForKey({
    required String metricKey,
    required String label,
    required int colorIndex,
  }) {
    final points = [
      for (final cycle in cycles)
        if (_g99MetricDouble(cycle.metrics, metricKey) != null)
          G99CycleQcPointData(
            cycle: cycle.cycle,
            value: _g99MetricDouble(cycle.metrics, metricKey)!,
          ),
    ];
    if (points.isEmpty) {
      return null;
    }
    return G99CycleQcSeriesData(
      label: label,
      color: _g99CycleQcSeriesColor(colorIndex),
      points: points,
    );
  }
}

const _g99CycleQcDefaultMetric = 'CycQ30';

const _g99CycleQcMetricOptions = [
  'Background',
  'BIC',
  'FIT',
  'LAG',
  'OffsetX',
  'OffsetY',
  'Signal',
  'Runon',
  'SNR',
  'CycQ30',
  'CycQ40',
];

class G99CycleQcMetricValue {
  const G99CycleQcMetricValue({required this.label, required this.value});

  final String label;
  final String value;
}

class G99CycleQcSeriesData {
  const G99CycleQcSeriesData({
    required this.label,
    required this.color,
    required this.points,
  });

  final String label;
  final Color color;
  final List<G99CycleQcPointData> points;
}

class G99CycleQcPointData {
  const G99CycleQcPointData({required this.cycle, required this.value});

  final int cycle;
  final double value;
}

class G99CycleQcCycleData {
  const G99CycleQcCycleData({required this.cycle, required this.metrics});

  final int cycle;
  final Map<String, Object?> metrics;
}

G99CycleQcMetricValue _g99CycleQcMetricFromMap(Map<Object?, Object?> map) {
  return G99CycleQcMetricValue(
    label: map['label'] as String,
    value: map['value'] as String,
  );
}

Map<String, dynamic> _g99CycleQcMetricToMap(G99CycleQcMetricValue metric) {
  return {'label': metric.label, 'value': metric.value};
}

G99CycleQcSeriesData _g99CycleQcSeriesFromMap(Map<Object?, Object?> map) {
  return G99CycleQcSeriesData(
    label: map['label'] as String,
    color: Color(map['color'] as int),
    points:
        (map['points'] as List<dynamic>)
            .map((point) => _g99CycleQcPointFromMap(point as Map))
            .toList(),
  );
}

Map<String, dynamic> _g99CycleQcSeriesToMap(G99CycleQcSeriesData series) {
  return {
    'label': series.label,
    'color': series.color.toARGB32(),
    'points': series.points.map(_g99CycleQcPointToMap).toList(),
  };
}

G99CycleQcPointData _g99CycleQcPointFromMap(Map<Object?, Object?> map) {
  return G99CycleQcPointData(
    cycle: map['cycle'] as int,
    value: (map['value'] as num).toDouble(),
  );
}

Map<String, dynamic> _g99CycleQcPointToMap(G99CycleQcPointData point) {
  return {'cycle': point.cycle, 'value': point.value};
}

G99CycleQcCycleData _g99CycleQcCycleFromMap(Map<Object?, Object?> map) {
  return G99CycleQcCycleData(
    cycle: map['cycle'] as int,
    metrics: Map<String, Object?>.from(map['metrics'] as Map),
  );
}

Map<String, dynamic> _g99CycleQcCycleToMap(G99CycleQcCycleData cycle) {
  return {'cycle': cycle.cycle, 'metrics': cycle.metrics};
}

class G99SequencingStepContent extends StatefulWidget {
  const G99SequencingStepContent({
    super.key,
    required this.cycleQcData,
    required this.laneQcRows,
    required this.sampleQcRows,
    required this.sequenceSummaryLanes,
    required this.fillRemaining,
    this.showSequenceSummary = true,
    this.showSampleCodeColumn = false,
  });

  final G99CycleQcViewData cycleQcData;
  final List<G99LaneQcRow> laneQcRows;
  final List<G99SampleQcRow> sampleQcRows;
  final List<G99SequenceSummaryLane> sequenceSummaryLanes;
  final bool fillRemaining;
  final bool showSequenceSummary;
  final bool showSampleCodeColumn;

  @override
  State<G99SequencingStepContent> createState() =>
      _G99SequencingStepContentState();
}

class _G99SequencingStepContentState extends State<G99SequencingStepContent> {
  int _segmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final alabTheme = EasyTheme.of(context);
    final l10n = EasyUiLocalizations.of(context);

    return Column(
      children: [
        EasySegments(
          height: 40,
          segments: [
            EasySegmentsItem(l10n.g99CycleQc),
            EasySegmentsItem(l10n.g99LaneQc),
            EasySegmentsItem(l10n.g99SampleQc),
            if (widget.showSequenceSummary)
              EasySegmentsItem(l10n.g99SequenceSummary),
          ],
          selectedIndex: _segmentIndex,
          onSegmentChange:
              (index) => setState(() {
                _segmentIndex = index;
              }),
        ),
        const SizedBox(height: 12),
        if (widget.fillRemaining)
          Expanded(child: _buildSegmentContent(alabTheme))
        else
          SizedBox(height: 420, child: _buildSegmentContent(alabTheme)),
      ],
    );
  }

  Widget _buildSegmentContent(EasyThemeData alabTheme) {
    late final Widget child;
    if (_segmentIndex == 0) {
      child = _G99CycleQcPanel(data: widget.cycleQcData);
    } else if (_segmentIndex == 1) {
      child = _G99QcTablePanel(
        tableKey: ValueKey('g99-lane-qc-table'),
        rows: widget.laneQcRows,
      );
    } else if (_segmentIndex == 2) {
      child = _G99SampleQcTablePanel(
        tableKey: ValueKey('g99-sample-qc-table'),
        rows: widget.sampleQcRows,
        showSampleCodeColumn: widget.showSampleCodeColumn,
      );
    } else if (_segmentIndex == 3) {
      child = G99SequenceSummaryPanel(lanes: widget.sequenceSummaryLanes);
    } else {
      child = _G99SequencingEmptyPanel(alabTheme: alabTheme);
    }

    return Container(
      key: const ValueKey('g99-sequencing-segment-content'),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _G99SequencingEmptyPanel extends StatelessWidget {
  const _G99SequencingEmptyPanel({required this.alabTheme});

  final EasyThemeData alabTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: EasyEmptyView(),
    );
  }
}

const List<String> _g99LaneQcColumns = [
  _g99LaneQcIndexColumnKey,
  'Summary',
  'PhredQual',
  'ReadNum',
  'BaseNum',
  'N_Count%',
  'GC%',
  'Q10%',
  'Q20%',
  'Q30%',
  'EstErr%',
];

const _g99LaneQcIndexColumnKey = 'index';

const List<double> _g99LaneQcColumnWidths = [
  118,
  220,
  170,
  190,
  210,
  190,
  150,
  150,
  150,
  150,
  190,
];

const List<String> _g99SampleQcColumns = [
  'BarCode',
  'Summary',
  'PhredQual',
  'ReadNum',
  'BaseNum',
  'N_Count%',
  'GC%',
  'Q10%',
  'Q20%',
  'Q30%',
  'Q40%',
  'EstErr%',
];

const _g99SampleQcSampleCodeColumnKey = 'sampleCode';

const List<double> _g99SampleQcColumnWidths = [
  180,
  180,
  170,
  190,
  210,
  190,
  150,
  150,
  150,
  150,
  150,
  190,
];

class _G99CycleQcPanel extends StatelessWidget {
  const _G99CycleQcPanel({required this.data});

  final G99CycleQcViewData data;

  @override
  Widget build(BuildContext context) {
    if (!data.hasData) {
      return _G99SequencingEmptyPanel(alabTheme: EasyTheme.of(context));
    }

    return G99CycleQcPanelContent(data: data);
  }
}

class G99CycleQcPanelContent extends StatefulWidget {
  const G99CycleQcPanelContent({super.key, required this.data});

  final G99CycleQcViewData data;

  @override
  State<G99CycleQcPanelContent> createState() => _G99CycleQcPanelContentState();
}

class _G99CycleQcPanelContentState extends State<G99CycleQcPanelContent> {
  String _selectedMetric = _g99CycleQcDefaultMetric;

  @override
  Widget build(BuildContext context) {
    final series = widget.data.seriesFor(_selectedMetric);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 360,
                  child: G99CycleQcMetricList(
                    title: widget.data.title,
                    startTime: widget.data.startTime,
                    endTime: widget.data.endTime,
                    metrics: widget.data.metrics,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 420,
                  child: G99CycleQcChartPanel(
                    selectedMetric: _selectedMetric,
                    series: series,
                    totalCycleCount: widget.data.totalCycleCount,
                    onMetricChanged: _onMetricChanged,
                  ),
                ),
              ],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 294,
              child: G99CycleQcMetricList(
                title: widget.data.title,
                startTime: widget.data.startTime,
                endTime: widget.data.endTime,
                metrics: widget.data.metrics,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 536,
              child: G99CycleQcChartPanel(
                selectedMetric: _selectedMetric,
                series: series,
                totalCycleCount: widget.data.totalCycleCount,
                onMetricChanged: _onMetricChanged,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onMetricChanged(String? value) {
    if (value == null || value == _selectedMetric) {
      return;
    }
    setState(() {
      _selectedMetric = value;
    });
  }
}

class _G99QcTablePanel extends StatelessWidget {
  const _G99QcTablePanel({required this.tableKey, required this.rows});

  final Key tableKey;
  final List<G99LaneQcRow> rows;

  @override
  Widget build(BuildContext context) {
    final alabTheme = EasyTheme.of(context);
    final columnConfigs = [
      for (var i = 0; i < _g99LaneQcColumns.length; i++)
        EasyDataTableColumnConfig(
          visibilityOptionName: _g99LaneQcColumns[i],
          width: _g99LaneQcColumnWidths[i],
        ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: EasyDataTable(
        key: tableKey,
        loadingData: false,
        headerHeight: 46,
        rowHeight: 48,
        calculateDelegate: const EasyDataTableCalculateDelegate.normal(),
        columnConfigs: columnConfigs,
        rowCount: rows.length,
        emptyWidget: EasyEmptyView(),
        headerBuilder: (context, column) {
          return EasyDataTableTextHeader(
            text: _g99LaneQcColumnTitle(
              context,
              columnConfigs[column].visibilityOptionName,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          );
        },
        cellBuilder: (context, vicinity) {
          final row = rows[vicinity.row];
          return EasyDataTableTextCell(
            text: row.valueForColumn(vicinity.column),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            textStyle: TextStyle(color: alabTheme.neutral66, fontSize: 15),
          );
        },
      ),
    );
  }
}

String _g99LaneQcColumnTitle(BuildContext context, String? columnName) {
  if (columnName == _g99LaneQcIndexColumnKey) {
    return EasyUiLocalizations.of(context).g99Index;
  }
  return columnName ?? '';
}

class _G99SampleQcTablePanel extends StatelessWidget {
  const _G99SampleQcTablePanel({
    required this.tableKey,
    required this.rows,
    required this.showSampleCodeColumn,
  });

  final Key tableKey;
  final List<G99SampleQcRow> rows;
  final bool showSampleCodeColumn;

  @override
  Widget build(BuildContext context) {
    final alabTheme = EasyTheme.of(context);
    final columnNames = _g99SampleQcTableColumns(showSampleCodeColumn);
    final columnWidths = _g99SampleQcTableColumnWidths(showSampleCodeColumn);
    final columnConfigs = [
      for (var i = 0; i < columnNames.length; i++)
        EasyDataTableColumnConfig(
          visibilityOptionName: columnNames[i],
          width: columnWidths[i],
        ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: EasyDataTable(
        key: tableKey,
        loadingData: false,
        headerHeight: 46,
        rowHeight: 48,
        calculateDelegate: const EasyDataTableCalculateDelegate.normal(),
        columnConfigs: columnConfigs,
        rowCount: rows.length,
        emptyWidget: EasyEmptyView(),
        headerBuilder: (context, column) {
          return EasyDataTableTextHeader(
            text: _g99SampleQcColumnTitle(
              context,
              columnConfigs[column].visibilityOptionName,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          );
        },
        cellBuilder: (context, vicinity) {
          final row = rows[vicinity.row];
          return EasyDataTableTextCell(
            text: row._valueForColumnName(columnNames[vicinity.column]),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            textStyle: TextStyle(color: alabTheme.neutral66, fontSize: 15),
          );
        },
      ),
    );
  }
}

List<String> _g99SampleQcTableColumns(bool showSampleCodeColumn) {
  if (!showSampleCodeColumn) {
    return _g99SampleQcColumns;
  }
  return [
    _g99SampleQcColumns.first,
    _g99SampleQcSampleCodeColumnKey,
    ..._g99SampleQcColumns.skip(1),
  ];
}

List<double> _g99SampleQcTableColumnWidths(bool showSampleCodeColumn) {
  if (!showSampleCodeColumn) {
    return _g99SampleQcColumnWidths;
  }
  return [
    _g99SampleQcColumnWidths.first,
    180,
    ..._g99SampleQcColumnWidths.skip(1),
  ];
}

String _g99SampleQcColumnTitle(BuildContext context, String? columnName) {
  if (columnName == _g99SampleQcSampleCodeColumnKey) {
    return EasyUiLocalizations.of(context).g99SampleCode;
  }
  return columnName ?? '';
}

class G99CycleQcMetricList extends StatelessWidget {
  const G99CycleQcMetricList({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.metrics,
  });

  final String title;
  final String startTime;
  final String endTime;
  final List<G99CycleQcMetricValue> metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);

    return Container(
      key: const ValueKey('g99-cycle-qc-left'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          key: const ValueKey('g99-cycle-qc-scroll-content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                key: const ValueKey('g99-cycle-qc-first-base-title'),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.g99StartTime(startTime),
                key: const ValueKey('g99-cycle-qc-start-time'),
                style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.g99EndTime(endTime),
                key: const ValueKey('g99-cycle-qc-end-time'),
                style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
              const SizedBox(height: 16),
              for (final metric in metrics) ...[
                _G99CycleQcMetricRow(metric: metric),
                if (metric != metrics.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _G99CycleQcMetricRow extends StatelessWidget {
  const _G99CycleQcMetricRow({required this.metric});

  final G99CycleQcMetricValue metric;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Text(
            _g99FormattedCycleQcMetricValue(metric.value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
          ),
        ),
      ],
    );
  }
}

String _g99FormattedCycleQcMetricValue(String value) {
  final trimmed = value.trim();
  final hasPercent = trimmed.endsWith('%');
  final numberText =
      hasPercent ? trimmed.substring(0, trimmed.length - 1).trim() : trimmed;
  final number = double.tryParse(numberText.replaceAll(',', ''));
  if (number == null) {
    return value;
  }
  var formatted = number.toStringAsFixed(3);
  if (formatted.contains('.')) {
    formatted = formatted.replaceFirst(RegExp(r'\.?0+$'), '');
  }
  if (formatted == '-0') {
    formatted = '0';
  }
  return hasPercent ? '$formatted%' : formatted;
}

class G99CycleQcChartPanel extends StatelessWidget {
  const G99CycleQcChartPanel({
    super.key,
    required this.selectedMetric,
    required this.series,
    required this.totalCycleCount,
    required this.onMetricChanged,
  });

  final String selectedMetric;
  final List<G99CycleQcSeriesData> series;
  final int? totalCycleCount;
  final ValueChanged<String?> onMetricChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('g99-cycle-qc-right'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 28, 34, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.82,
            child: _G99CycleQcMetricSelect(
              selectedMetric: selectedMetric,
              onChanged: onMetricChanged,
            ),
          ),
          const SizedBox(height: 30),
          _G99CycleQcLegend(series: series),
          const SizedBox(height: 18),
          Expanded(
            child: _G99CycleQcLineChart(
              key: const ValueKey('g99-cycle-qc-chart'),
              series: series,
              totalCycleCount: totalCycleCount,
            ),
          ),
        ],
      ),
    );
  }
}

class _G99CycleQcMetricSelect extends StatelessWidget {
  const _G99CycleQcMetricSelect({
    required this.selectedMetric,
    required this.onChanged,
  });

  final String selectedMetric;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final alabTheme = EasyTheme.of(context);

    return SizedBox(
      key: const ValueKey('g99-cycle-qc-metric-select'),
      child: EasySelect<String>(
        initialValue: selectedMetric,
        optionsFetcher:
            () => [
              for (final option in _g99CycleQcMetricOptions)
                EasyListPopMenuOption.simple(value: option, title: option),
            ],
        easySelectStyle: EasySelectStyle(
          triggerConstraints: const BoxConstraints.tightFor(height: 42),
          triggerContentPadding: const EdgeInsets.symmetric(horizontal: 16),
          triggerBorderColor: const Color(0xFFD8D8D8),
          displayTextStyle: TextStyle(color: alabTheme.neutral33, fontSize: 18),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _G99CycleQcLegend extends StatelessWidget {
  const _G99CycleQcLegend({required this.series});

  final List<G99CycleQcSeriesData> series;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 18,
      runSpacing: 8,
      children: [
        for (final item in series) _G99CycleQcLegendItem(series: item),
      ],
    );
  }
}

class _G99CycleQcLegendItem extends StatelessWidget {
  const _G99CycleQcLegendItem({required this.series});

  final G99CycleQcSeriesData series;

  @override
  Widget build(BuildContext context) {
    final alabTheme = EasyTheme.of(context);

    return Row(
      key: ValueKey('g99-cycle-qc-legend-${series.label}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(28, 12),
          painter: _G99CycleQcLegendPainter(color: series.color),
        ),
        const SizedBox(width: 10),
        Text(
          series.label,
          style: TextStyle(color: alabTheme.neutral99, fontSize: 15),
        ),
      ],
    );
  }
}

class _G99CycleQcLegendPainter extends CustomPainter {
  const _G99CycleQcLegendPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    canvas.drawCircle(
      Offset(size.width / 2, y),
      4,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _G99CycleQcLegendPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _G99CycleQcLineChart extends StatelessWidget {
  const _G99CycleQcLineChart({
    super.key,
    required this.series,
    required this.totalCycleCount,
  });

  final List<G99CycleQcSeriesData> series;
  final int? totalCycleCount;

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) {
      return EasyEmptyView();
    }

    final allPoints = [for (final item in series) ...item.points];
    var minX = allPoints.first.cycle.toDouble();
    var maxX = minX;
    var minY = allPoints.first.value;
    var maxY = minY;
    for (final point in allPoints) {
      final x = point.cycle.toDouble();
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (point.value < minY) minY = point.value;
      if (point.value > maxY) maxY = point.value;
    }

    if ((totalCycleCount ?? 0) > maxX) {
      maxX = totalCycleCount!.toDouble();
    }
    if (minX == maxX) {
      maxX += 1;
    }
    final yRange = maxY - minY;
    if (yRange == 0) {
      minY = minY > 0 ? 0 : minY - 1;
      maxY += 1;
    } else {
      if (minY > 0) {
        minY = 0;
      } else {
        minY -= yRange * 0.1;
      }
      maxY += yRange * 0.1;
    }

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (_) => const FlLine(color: Color(0xFFE7E7E7), strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Color(0xFFE7E7E7)),
            bottom: BorderSide(color: Color(0xFFE7E7E7)),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget:
                  (value, meta) => SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _g99AxisValue(value),
                      style: const TextStyle(
                        color: Color(0xFFB7B7B7),
                        fontSize: 12,
                      ),
                    ),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _g99CycleInterval(minX, maxX),
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value < minX || value > maxX || value % 1 != 0) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Color(0xFFB7B7B7),
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF333333),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems:
                (spots) => [
                  for (var index = 0; index < spots.length; index += 1)
                    LineTooltipItem(
                      _g99CycleQcTooltipText(spots[index], series, index == 0),
                      const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                ],
          ),
        ),
        lineBarsData: [
          for (final item in series)
            LineChartBarData(
              spots: [
                for (final point in item.points)
                  FlSpot(point.cycle.toDouble(), point.value),
              ],
              isCurved: false,
              color: item.color,
              barWidth: 2,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
        ],
      ),
    );
  }
}

String _g99CycleQcTooltipText(
  LineBarSpot spot,
  List<G99CycleQcSeriesData> series,
  bool includeCycle,
) {
  final label =
      spot.barIndex < series.length ? series[spot.barIndex].label : '';
  final metricText =
      '$label: ${_g99FormattedCycleQcMetricValue(spot.y.toString())}';
  if (!includeCycle) {
    return metricText;
  }
  return 'cycle:${spot.x.toInt()}\n$metricText';
}

double? _g99MetricDouble(Map<String, Object?> metrics, String key) {
  final value = _g99MetricValue(metrics, key);
  if (value is num) {
    return value.toDouble();
  }
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return double.tryParse(text);
}

Object? _g99MetricValue(Map<String, Object?> metrics, String key) {
  if (metrics.containsKey(key)) {
    return metrics[key];
  }
  final lowerKey = key.toLowerCase();
  for (final entry in metrics.entries) {
    if (entry.key.toLowerCase() == lowerKey) {
      return entry.value;
    }
  }
  return null;
}

Color _g99CycleQcSeriesColor(int index) {
  const colors = [
    Color(0xFF55ACED),
    Color(0xFF4FCDB4),
    Color(0xFFB044F6),
    Color(0xFFFFA12B),
    Color(0xFF2F83F7),
    Color(0xFF31DA9F),
    Color(0xFF7B61FF),
    Color(0xFFE28B34),
    Color(0xFF5A8DEE),
    Color(0xFF3AAE8C),
    Color(0xFF9D5BD2),
    Color(0xFFC9792F),
  ];
  return colors[index % colors.length];
}

double _g99CycleInterval(double minX, double maxX) {
  final range = maxX - minX;
  if (range <= 5) {
    return 1;
  }
  var interval = (range / 5).ceil();
  while (_g99CycleTrailingGap(minX, maxX, interval) <=
      _g99CycleMinReadableTrailingGap(interval)) {
    interval += 1;
  }
  return interval.toDouble();
}

int _g99CycleTrailingGap(double minX, double maxX, int interval) {
  final minCycle = minX.round();
  final maxCycle = maxX.round();
  final lastTick = (maxCycle ~/ interval) * interval;
  if (lastTick <= minCycle || lastTick == maxCycle) {
    return interval;
  }
  return maxCycle - lastTick;
}

double _g99CycleMinReadableTrailingGap(int interval) {
  if (interval <= 4) {
    return 1;
  }
  return interval / 4;
}

String _g99AxisValue(double value) {
  if (value.abs() < 1e-9) {
    return '0';
  }
  final absValue = value.abs();
  if (absValue >= 1000000 || (absValue > 0 && absValue < 0.001)) {
    return value.toStringAsExponential(1);
  }
  if (absValue >= 1000) {
    return value.toStringAsFixed(0);
  }
  if (absValue >= 10) {
    return value.toStringAsFixed(1);
  }
  return value.toStringAsFixed(2);
}
