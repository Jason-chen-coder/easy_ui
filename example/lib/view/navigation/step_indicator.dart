import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart'
    hide
        AlertDialog,
        Card,
        CircularProgressIndicator,
        DataTable,
        DropdownButton,
        ElevatedButton,
        FilledButton,
        FloatingActionButton,
        IconButton,
        LinearProgressIndicator,
        ListTile,
        OutlinedButton,
        RangeSlider,
        Slider,
        Switch,
        TextButton,
        TextField,
        TextFormField,
        showDialog;
import 'package:example/widgets/example_easy_widgets.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class StepIndicatorDemo extends StatelessWidget {
  const StepIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyStepIndicator 步骤指示器示例'),
        h2('基本用法'),
        p('展示基础的步骤指示器，包含多个步骤和当前进度指示。'),
        WidgetHighlight(
          builder: (_) {
            return const _StepIndicatorBaseDemo();
          },
          codeSnippet: '''
```dart
class _StepIndicatorBaseDemo extends StatefulWidget {
  const _StepIndicatorBaseDemo();

  @override
  State<_StepIndicatorBaseDemo> createState() => _StepIndicatorBaseDemoState();
}

class _StepIndicatorBaseDemoState extends State<_StepIndicatorBaseDemo> {
  int _currentStep = 0;
  int _selectedStep = 0;
  final List<String> _steps = ['准备工作', '校准 X 轴', '校准 Y 轴', '完成校准'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyStepIndicator(
          stepsLength: _steps.length,
          stepNames: _steps,
          currentStep: _currentStep,
          selectedStep: _selectedStep,
          onSelectedStepChanged: (step) {
            setState(() {
              _selectedStep = step;
            });
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed: _currentStep > 0
                  ? () {
                      setState(() {
                        _currentStep--;
                        _selectedStep = _currentStep;
                      });
                    }
                  : null,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 16),
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed: _currentStep < _steps.length - 1
                  ? () {
                      setState(() {
                        _currentStep++;
                        _selectedStep = _currentStep;
                      });
                    }
                  : null,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
    );
  }
}
```
''',
        ),
        h2('自定义样式'),
        p('通过 stepStyles 按步骤索引覆盖指定步骤的背景颜色、文字颜色、图标圆形背景颜色和图标颜色。'),
        WidgetHighlight(
          builder: (_) {
            return const _StepIndicatorCustomStyleDemo();
          },
          codeSnippet: '''
```dart
class _StepIndicatorCustomStyleDemo extends StatelessWidget {
  const _StepIndicatorCustomStyleDemo();

  @override
  Widget build(BuildContext context) {
    const steps = ['准备工作', '样本处理', '质控审核', '完成'];

    return EasyStepIndicator(
      stepsLength: steps.length,
      stepNames: steps,
      currentStep: 1,
      stepStyles: const {
        1: (
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          iconBackgroundColor: Colors.white,
          iconColor: Colors.orange,
        ),
        2: (
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          iconBackgroundColor: Colors.white,
          iconColor: Colors.blue,
        ),
      },
    );
  }
}
```
''',
        ),
        h2('参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyStepIndicator 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('默认值')),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('stepsLength')),
                        DataCell(Text('int')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('步骤总数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepNames')),
                        DataCell(Text('List<String>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('各步骤的名称列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('currentStep')),
                        DataCell(Text('int')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('当前所处的步骤索引（从0开始）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedStep')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('当前选中查看的步骤索引（从0开始）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onSelectedStepChanged')),
                        DataCell(Text('ValueChanged<int>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('点击步骤时触发，返回被选中的步骤索引')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedStepScale')),
                        DataCell(Text('double')),
                        DataCell(Text('1.15')),
                        DataCell(Text('否')),
                        DataCell(Text('选中步骤的放大倍率')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double')),
                        DataCell(Text('76')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤总数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepStyles')),
                        DataCell(Text('Map<int, EasyStepIndicatorStyle>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('按步骤索引覆盖背景色、文字颜色、图标圆形背景色和图标颜色')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '',
        ),
      ],
    );
  }
}

class _StepIndicatorBaseDemo extends StatefulWidget {
  const _StepIndicatorBaseDemo();

  @override
  State<_StepIndicatorBaseDemo> createState() => _StepIndicatorBaseDemoState();
}

class _StepIndicatorBaseDemoState extends State<_StepIndicatorBaseDemo> {
  int _currentStep = 0;
  int _selectedStep = 0;
  final List<String> _steps = ['准备工作', '校准 X 轴', '校准 Y 轴', '完成校准'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyStepIndicator(
          stepsLength: _steps.length,
          stepNames: _steps,
          currentStep: _currentStep,
          selectedStep: _selectedStep,
          onSelectedStepChanged: (step) {
            setState(() {
              _selectedStep = step;
            });
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed:
                  _currentStep > 0
                      ? () {
                        setState(() {
                          _currentStep--;
                          _selectedStep = _currentStep;
                        });
                      }
                      : null,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 16),
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed:
                  _currentStep < _steps.length - 1
                      ? () {
                        setState(() {
                          _currentStep++;
                          _selectedStep = _currentStep;
                        });
                      }
                      : null,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepIndicatorCustomStyleDemo extends StatelessWidget {
  const _StepIndicatorCustomStyleDemo();

  @override
  Widget build(BuildContext context) {
    const steps = ['准备工作', '样本处理', '质控审核', '完成'];

    return EasyStepIndicator(
      stepsLength: steps.length,
      stepNames: steps,
      currentStep: 1,
      stepStyles: const {
        1: (
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          iconBackgroundColor: Colors.white,
          iconColor: Colors.orange,
        ),
        2: (
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          iconBackgroundColor: Colors.white,
          iconColor: Colors.blue,
        ),
      },
    );
  }
}
