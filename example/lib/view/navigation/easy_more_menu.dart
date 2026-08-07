import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/example_easy_widgets.dart';
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

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

enum _ParameterAction { edit, copy, archive, share, delete }

class EasyMoreMenuDemo extends StatefulWidget {
  const EasyMoreMenuDemo({super.key});

  @override
  State<EasyMoreMenuDemo> createState() => _EasyMoreMenuDemoState();
}

class _EasyMoreMenuDemoState extends State<EasyMoreMenuDemo> {
  String _lastAction = '尚未选择';

  void _handleSelected(_ParameterAction action) {
    setState(() {
      _lastAction = switch (action) {
        _ParameterAction.edit => '编辑',
        _ParameterAction.copy => '复制',
        _ParameterAction.archive => '归档',
        _ParameterAction.share => '分享',
        _ParameterAction.delete => '删除',
      };
    });
  }

  Widget _selectionFeedback() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text('最近操作：$_lastAction', style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyMoreMenu 更多菜单'),
        p('用于在紧凑区域中收纳一组上下文操作，支持泛型值、危险操作、禁用项和自定义触发器。'),
        h2('基本用法'),
        p('使用泛型枚举声明操作值，在 onSelected 中集中处理用户选择。'),
        WidgetHighlight(
          builder: (_) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '实验参数',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      EasyMoreMenu<_ParameterAction>(
                        tooltip: '更多操作',
                        semanticLabel: '参数操作',
                        items: const [
                          EasyMoreMenuItem(
                            value: _ParameterAction.edit,
                            label: '编辑',
                          ),
                          EasyMoreMenuItem(
                            value: _ParameterAction.copy,
                            label: '复制',
                          ),
                          EasyMoreMenuItem(
                            value: _ParameterAction.delete,
                            label: '删除',
                            danger: true,
                          ),
                        ],
                        onSelected: _handleSelected,
                      ),
                    ],
                  ),
                  _selectionFeedback(),
                ],
              ),
            );
          },
          codeSnippet: '''
```dart
enum ParameterAction { edit, copy, delete }

EasyMoreMenu<ParameterAction>(
  tooltip: '更多操作',
  semanticLabel: '参数操作',
  items: const [
    EasyMoreMenuItem(
      value: ParameterAction.edit,
      label: '编辑',
    ),
    EasyMoreMenuItem(
      value: ParameterAction.copy,
      label: '复制',
    ),
    EasyMoreMenuItem(
      value: ParameterAction.delete,
      label: '删除',
      danger: true,
    ),
  ],
  onSelected: (action) {
    switch (action) {
      case ParameterAction.edit:
        // 编辑参数
        break;
      case ParameterAction.copy:
        // 复制参数
        break;
      case ParameterAction.delete:
        // 删除参数
        break;
    }
  },
)
```
''',
        ),
        h2('图标、禁用项与危险操作'),
        p('leading 用于增强操作识别；enabled 可禁用暂不可用的操作；danger 用于突出破坏性操作。'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('项目操作'),
                    const SizedBox(width: 8),
                    EasyMoreMenu<_ParameterAction>(
                      tooltip: '项目操作',
                      menuWidth: 136,
                      items: const [
                        EasyMoreMenuItem(
                          value: _ParameterAction.archive,
                          label: '归档',
                          leading: Icon(Icons.archive_outlined),
                        ),
                        EasyMoreMenuItem(
                          value: _ParameterAction.share,
                          label: '分享',
                          leading: Icon(Icons.share_outlined),
                          enabled: false,
                        ),
                        EasyMoreMenuItem(
                          value: _ParameterAction.delete,
                          label: '删除',
                          leading: Icon(Icons.delete_outline),
                          danger: true,
                        ),
                      ],
                      onSelected: _handleSelected,
                    ),
                  ],
                ),
                _selectionFeedback(),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyMoreMenu<ParameterAction>(
  tooltip: '项目操作',
  menuWidth: 136,
  items: const [
    EasyMoreMenuItem(
      value: ParameterAction.archive,
      label: '归档',
      leading: Icon(Icons.archive_outlined),
    ),
    EasyMoreMenuItem(
      value: ParameterAction.share,
      label: '分享',
      leading: Icon(Icons.share_outlined),
      enabled: false,
    ),
    EasyMoreMenuItem(
      value: ParameterAction.delete,
      label: '删除',
      leading: Icon(Icons.delete_outline),
      danger: true,
    ),
  ],
  onSelected: _handleSelected,
)
```
''',
        ),
        h2('自定义触发器'),
        p('通过 button 替换默认的更多图标，菜单的打开、关闭和禁用状态仍由组件统一管理。'),
        WidgetHighlight(
          builder: (context) {
            final theme = EasyTheme.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyMoreMenu<_ParameterAction>(
                  tooltip: '自定义更多操作',
                  menuWidth: 128,
                  button: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.background,
                      border: Border.all(color: theme.neutralEE),
                      borderRadius: BorderRadius.all(theme.cornerSmall),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.more_horiz, size: 18),
                        SizedBox(width: 6),
                        Text('操作'),
                      ],
                    ),
                  ),
                  items: const [
                    EasyMoreMenuItem(value: _ParameterAction.edit, label: '编辑'),
                    EasyMoreMenuItem(value: _ParameterAction.copy, label: '复制'),
                  ],
                  onSelected: _handleSelected,
                ),
                _selectionFeedback(),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyMoreMenu<ParameterAction>(
  tooltip: '自定义更多操作',
  menuWidth: 128,
  button: Container(
    height: 34,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffdddddd)),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.more_horiz, size: 18),
        SizedBox(width: 6),
        Text('操作'),
      ],
    ),
  ),
  items: const [
    EasyMoreMenuItem(value: ParameterAction.edit, label: '编辑'),
    EasyMoreMenuItem(value: ParameterAction.copy, label: '复制'),
  ],
  onSelected: _handleSelected,
)
```
''',
        ),
        h2('参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyMoreMenu 参数：'),
                _parameterTable(const [
                  _Parameter(
                    'items',
                    'List<EasyMoreMenuItem<T>>',
                    '-',
                    '是',
                    '按顺序展示的操作列表',
                  ),
                  _Parameter(
                    'onSelected',
                    'ValueChanged<T>',
                    '-',
                    '是',
                    '选择可用操作后的回调',
                  ),
                  _Parameter(
                    'button',
                    'Widget?',
                    'null',
                    '否',
                    '替换默认 30×30 更多图标触发器',
                  ),
                  _Parameter('tooltip', 'String?', 'null', '否', '触发器悬停提示'),
                  _Parameter(
                    'semanticLabel',
                    'String?',
                    'tooltip / More actions',
                    '否',
                    '触发器无障碍标签',
                  ),
                  _Parameter('enabled', 'bool', 'true', '否', '是否允许打开菜单'),
                  _Parameter('menuWidth', 'double', '112', '否', '菜单宽度'),
                  _Parameter('itemHeight', 'double', '36', '否', '单个菜单项高度'),
                  _Parameter(
                    'menuPadding',
                    'EdgeInsetsGeometry',
                    '垂直 6',
                    '否',
                    '菜单内部留白',
                  ),
                  _Parameter(
                    'offset',
                    'Offset',
                    'Offset(0, 2)',
                    '否',
                    '菜单相对触发器的偏移',
                  ),
                  _Parameter(
                    'style',
                    'EasyMenuStyle?',
                    'null',
                    '否',
                    '菜单背景、边框、圆角与阴影',
                  ),
                  _Parameter(
                    'onOpen / onClose',
                    'VoidCallback?',
                    'null',
                    '否',
                    '菜单打开或关闭时回调',
                  ),
                ]),
                const SizedBox(height: 24),
                p('EasyMoreMenuItem 参数：'),
                _parameterTable(const [
                  _Parameter('value', 'T', '-', '是', '操作对应的泛型值'),
                  _Parameter('label', 'String', '-', '是', '菜单项文字'),
                  _Parameter('leading', 'Widget?', 'null', '否', '菜单项前置图标或紧凑组件'),
                  _Parameter('enabled', 'bool', 'true', '否', '菜单项是否可选择'),
                  _Parameter('danger', 'bool', 'false', '否', '是否使用危险操作颜色'),
                  _Parameter(
                    'textStyle',
                    'TextStyle?',
                    'null',
                    '否',
                    '覆盖菜单项文字样式',
                  ),
                ]),
              ],
            );
          },
          codeSnippet: '',
        ),
      ],
    );
  }
}

Widget _parameterTable(List<_Parameter> parameters) {
  return DataTable(
    dataRowMaxHeight: 64,
    columns: const [
      DataColumn(label: Text('参数名')),
      DataColumn(label: Text('类型')),
      DataColumn(label: Text('默认值')),
      DataColumn(label: Text('是否必填')),
      DataColumn(label: Text('说明')),
    ],
    rows: [
      for (final parameter in parameters)
        DataRow(
          cells: [
            DataCell(Text(parameter.name)),
            DataCell(Text(parameter.type)),
            DataCell(Text(parameter.defaultValue)),
            DataCell(Text(parameter.required)),
            DataCell(Text(parameter.description)),
          ],
        ),
    ],
  );
}

class _Parameter {
  const _Parameter(
    this.name,
    this.type,
    this.defaultValue,
    this.required,
    this.description,
  );

  final String name;
  final String type;
  final String defaultValue;
  final String required;
  final String description;
}
