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
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';

class ElevatedButton extends StatelessWidget {
  const ElevatedButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required this.child,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final m.ButtonStyle? style;
  final Widget child;

  static m.ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    OutlinedBorder? shape,
    BorderSide? side,
    double? elevation,
    TextStyle? textStyle,
  }) {
    return m.ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      shape: shape,
      side: side,
      elevation: elevation,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyButton2(
      type: EasyButtonType.primary,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: _easyButtonStyleFromMaterial(context, style),
      child: child,
    );
  }
}

class FilledButton extends StatelessWidget {
  const FilledButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required this.child,
  });

  factory FilledButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    m.ButtonStyle? style,
    required Widget icon,
    required Widget label,
  }) {
    return FilledButton._icon(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      icon: icon,
      label: label,
    );
  }

  FilledButton._icon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget icon,
    required Widget label,
  }) : child = _ButtonIconLabel(icon: icon, label: label);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final m.ButtonStyle? style;
  final Widget child;

  static m.ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    OutlinedBorder? shape,
    BorderSide? side,
    TextStyle? textStyle,
  }) {
    return m.FilledButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      shape: shape,
      side: side,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyButton2(
      type: EasyButtonType.primary,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: _easyButtonStyleFromMaterial(context, style),
      child: child,
    );
  }
}

class OutlinedButton extends StatelessWidget {
  const OutlinedButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required this.child,
  });

  factory OutlinedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    m.ButtonStyle? style,
    required Widget icon,
    required Widget label,
  }) {
    return OutlinedButton._icon(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      icon: icon,
      label: label,
    );
  }

  OutlinedButton._icon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget icon,
    required Widget label,
  }) : child = _ButtonIconLabel(icon: icon, label: label);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final m.ButtonStyle? style;
  final Widget child;

  static m.ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    OutlinedBorder? shape,
    BorderSide? side,
    TextStyle? textStyle,
  }) {
    return m.OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      shape: shape,
      side: side,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyButton2(
      type: EasyButtonType.outline,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: _easyButtonStyleFromMaterial(context, style),
      child: child,
    );
  }
}

class TextButton extends StatelessWidget {
  const TextButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required this.child,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final m.ButtonStyle? style;
  final Widget child;

  static m.ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    OutlinedBorder? shape,
    TextStyle? textStyle,
  }) {
    return m.TextButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      shape: shape,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyButton2(
      type: EasyButtonType.text,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: _easyButtonStyleFromMaterial(context, style),
      child: child,
    );
  }
}

class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.color,
    this.style,
    this.padding,
    this.constraints,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final m.ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final size =
        constraints?.biggest.isFinite == true
            ? constraints!.biggest
            : Size.square((iconSize ?? 20) + 20);

    return EasyButton2(
      tooltip: tooltip,
      type: EasyButtonType.iconDefault,
      onPressed: onPressed,
      style: _easyButtonStyleFromMaterial(
        context,
        style,
        fallback: EasyButtonStyle.styleFrom(
          padding: padding ?? EdgeInsets.zero,
          fixedSize: size,
          minimumSize: Size.zero,
          foregroundColor: color ?? easyTheme.neutral66,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(easyTheme.cornerSmall),
          ),
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(size: iconSize, color: color),
        child: icon,
      ),
    );
  }
}

class FloatingActionButton extends StatelessWidget {
  const FloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.heroTag,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  // Kept for API compatibility with Material FloatingActionButton.
  final Object? heroTag;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final size = mini ? 40.0 : 56.0;

    return EasyButton2(
      tooltip: tooltip,
      type: EasyButtonType.iconPrimary,
      onPressed: onPressed,
      style: EasyButtonStyle.styleFrom(
        fixedSize: Size.square(size),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor ?? easyTheme.primaryGreen,
        foregroundColor: foregroundColor ?? Colors.white,
        shape: const CircleBorder(),
      ),
      child: child,
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.enabled,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return EasyTextFormField(
      controller: controller,
      focusNode: focusNode,
      decorationLayoutDelegate: null,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      enabled: enabled,
    );
  }
}

class TextFormField extends StatelessWidget {
  const TextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.inputFormatters,
    this.enabled,
    this.validator,
    this.onSaved,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return EasyTextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decorationLayoutDelegate: null,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      enabled: enabled,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class Switch extends StatelessWidget {
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return EasySwitch(
      checked: value,
      checkedColor: activeColor,
      disabled: onChanged == null,
      onChange: onChanged,
    );
  }
}

class Slider extends StatelessWidget {
  const Slider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return EasySlider(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
    );
  }
}

class RangeSlider extends StatelessWidget {
  const RangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;

  @override
  Widget build(BuildContext context) {
    return EasyRangeSlider(
      values: values,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
      labels: labels,
    );
  }
}

class LinearProgressIndicator extends StatelessWidget {
  const LinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.minHeight,
    this.color,
  });

  final double? value;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;
  final double? minHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return EasyLinearProgressIndicator(
      progress: value ?? 0,
      height: minHeight ?? 4,
      activeBackgroundColor: valueColor?.value ?? color,
      passiveBackgroundColor: backgroundColor,
      showProgressText: false,
    );
  }
}

class CircularProgressIndicator extends StatelessWidget {
  const CircularProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.strokeWidth = 4.0,
  });

  final double? value;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      return EasyRadialProgressIndicator(
        value: value!.clamp(0, 1),
        total: 1,
        size: 36,
        tickCount: 36,
      );
    }
    return EasyLottieIcon(
      type: EasyLottieIconType.loadingBlack,
      width: 32,
      height: 32,
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    super.key,
    this.child,
    this.color,
    this.margin,
    this.clipBehavior,
    this.shape,
    this.elevation,
  });

  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final ShapeBorder? shape;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final borderRadius = switch (shape) {
      RoundedRectangleBorder(borderRadius: final radius) => radius,
      _ => BorderRadius.all(easyTheme.cornerSmall),
    };

    return Container(
      margin: margin,
      clipBehavior: clipBehavior ?? Clip.none,
      decoration: BoxDecoration(
        color: color ?? easyTheme.cardBackground,
        borderRadius: borderRadius,
        border: Border.all(color: easyTheme.neutralEE),
        boxShadow: [
          if ((elevation ?? 0) > 0)
            BoxShadow(
              color: easyTheme.onBackground.withValues(alpha: 0.08),
              blurRadius: elevation! * 2,
              offset: Offset(0, elevation! / 2),
            ),
        ],
      ),
      child: child,
    );
  }
}

class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.dense,
    this.selected = false,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final inner = Padding(
      padding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: dense == true ? 8 : 12,
          ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) title!,
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle.merge(
                    style: TextStyle(fontSize: 12, color: easyTheme.neutral99),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );

    if (onTap == null) return inner;

    return EasyButton2(
      type: EasyButtonType.text,
      onPressed: onTap,
      style: EasyButtonStyle.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        backgroundColor:
            selected
                ? easyTheme.secondaryBlue.withValues(alpha: 0.08)
                : Colors.transparent,
        foregroundColor: easyTheme.neutral66,
        overlayColor: easyTheme.secondaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
      ),
      child: inner,
    );
  }
}

class DataTable extends StatelessWidget {
  const DataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.dataRowMinHeight,
    this.dataRowMaxHeight,
    this.columnSpacing,
    this.horizontalMargin,
    this.showCheckboxColumn = true,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? dataRowMinHeight;
  final double? dataRowMaxHeight;
  final double? columnSpacing;
  final double? horizontalMargin;
  final bool showCheckboxColumn;

  @override
  Widget build(BuildContext context) {
    final rowHeight = dataRowMaxHeight ?? dataRowMinHeight ?? 48;
    final headerHeight = 48.0;
    final height = headerHeight + (rows.length * rowHeight);
    final minimumWidth =
        (columns.length * (columnSpacing ?? 160))
            .clamp(240, double.infinity)
            .toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.hasBoundedWidth ? constraints.maxWidth : minimumWidth;

        return SizedBox(
          height: height.clamp(96, 640).toDouble(),
          width: width,
          child: EasyDataTable(
            loadingData: false,
            headerHeight: headerHeight,
            rowHeight: rowHeight,
            rowCount: rows.length,
            columnConfigs: [
              for (var i = 0; i < columns.length; i++)
                EasyDataTableColumnConfig(
                  visibilityOptionName: null,
                  width: columnSpacing ?? 160,
                  alwaysVisible: true,
                ),
            ],
            headerBuilder:
                (context, column) => DefaultTextStyle.merge(
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  child: columns[column].label,
                ),
            cellBuilder: (context, vicinity) {
              final cell = rows[vicinity.row].cells[vicinity.column];
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? 8,
                  ),
                  child: cell.child,
                ),
              );
            },
            emptyWidget: const EasyEmptyView(),
          ),
        );
      },
    );
  }
}

class DropdownButton<T> extends StatelessWidget {
  const DropdownButton({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.isExpanded = false,
  });

  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final Widget? hint;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final options =
        items
            ?.where((item) => item.value != null)
            .map(
              (item) => EasyListPopMenuOption<T>.simple(
                value: item.value as T,
                title: _textOf(item.child) ?? '${item.value}',
              ),
            )
            .toList() ??
        [];

    return EasySelect<T>(
      initialValue: value,
      placeholder: _textOf(hint) ?? '请选择',
      optionsFetcher: () async => options,
      onChanged: onChanged == null ? null : (value) => onChanged!(value),
    );
  }
}

class AlertDialog extends StatelessWidget {
  const AlertDialog({super.key, this.title, this.content, this.actions});

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return EasyContentDialog(
      title: _textOf(title) ?? '',
      body: content ?? const SizedBox.shrink(),
      actions:
          actions == null
              ? null
              : Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Wrap(spacing: 8, runSpacing: 8, children: actions!),
              ),
    );
  }
}

Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showEasyContentDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: builder,
  );
}

class _ButtonIconLabel extends StatelessWidget {
  const _ButtonIconLabel({required this.icon, required this.label});

  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, const SizedBox(width: 8), label],
    );
  }
}

EasyButtonStyle? _easyButtonStyleFromMaterial(
  BuildContext context,
  m.ButtonStyle? style, {
  EasyButtonStyle? fallback,
}) {
  if (style == null) return fallback;

  final easyTheme = EasyTheme.of(context);
  final states = <WidgetState>{};
  return EasyButtonStyle.styleFrom(
    foregroundColor:
        style.foregroundColor?.resolve(states) ??
        fallback?.foregroundColor?.resolve(states),
    backgroundColor:
        style.backgroundColor?.resolve(states) ??
        fallback?.backgroundColor?.resolve(states),
    padding:
        style.padding?.resolve(states) ?? fallback?.padding?.resolve(states),
    minimumSize:
        style.minimumSize?.resolve(states) ??
        fallback?.minimumSize?.resolve(states),
    fixedSize:
        style.fixedSize?.resolve(states) ??
        fallback?.fixedSize?.resolve(states),
    maximumSize:
        style.maximumSize?.resolve(states) ??
        fallback?.maximumSize?.resolve(states),
    shape:
        style.shape?.resolve(states) ??
        fallback?.shape?.resolve(states) ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
    side: style.side?.resolve(states) ?? fallback?.side?.resolve(states),
  );
}

String? _textOf(Widget? widget) {
  return switch (widget) {
    Text(data: final data) => data,
    _ => null,
  };
}
