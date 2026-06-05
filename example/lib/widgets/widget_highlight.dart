import 'package:easy_ui/easy_ui.dart';
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

class WidgetHighlight extends StatefulWidget {
  const WidgetHighlight({
    super.key,
    this.backgroundColor,
    this.header,
    required this.builder,
    required this.codeSnippet,
    this.initiallyOpen = false,
  });

  /// 折叠部分的标题 默认为"源代码"
  final Widget? header;

  /// 需要展示的组件
  final Widget Function(BuildContext) builder;

  /// 组件对应的代码片段（传入markdown文本，亦可是组件文档）
  final String codeSnippet;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否默认展开
  final bool initiallyOpen;

  @override
  State<WidgetHighlight> createState() => _WidgetHighlightState();
}

class _WidgetHighlightState extends State<WidgetHighlight> {
  late bool isOpen = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          color: easyTheme.onBackground.withValues(alpha: 0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: easyTheme.onBackground.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        color: widget.backgroundColor ?? easyTheme.background,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            alignment: AlignmentDirectional.topStart,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: easyTheme.onBackground.withValues(alpha: 0.1),
                  width: 2.0,
                ),
              ),
            ),
            child: widget.builder.call(context),
          ),
          if (widget.codeSnippet != "") _buildCodePanel(context, easyTheme),
        ],
      ),
    );
  }

  Widget _buildCodePanel(BuildContext context, EasyThemeData easyTheme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: EasyButton2(
            type: EasyButtonType.text,
            style: EasyButtonStyle.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              minimumSize: Size.zero,
              backgroundColor: Colors.transparent,
              foregroundColor: easyTheme.neutral66,
              overlayColor: easyTheme.secondaryBlue,
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () {
              if (mounted) setState(() => isOpen = !isOpen);
            },
            child: Row(
              children: [
                Expanded(
                  child:
                      widget.header ??
                      const Text(
                        '源代码',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18,
                  color: easyTheme.neutral99,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: EasyMarkdown(text: widget.codeSnippet),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeOut,
          sizeCurve: Curves.easeOut,
        ),
      ],
    );
  }
}
