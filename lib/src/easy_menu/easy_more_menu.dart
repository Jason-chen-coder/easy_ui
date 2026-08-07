import 'package:flutter/material.dart';

import '../easy_theme.dart';
import 'easy_menu_anchor.dart';
import 'easy_menu_anchor_layout_delegate.dart';
import 'easy_menu_style.dart';

/// A compact action menu, typically used for edit, copy, and delete actions.
class EasyMoreMenu<T> extends StatelessWidget {
  const EasyMoreMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.button,
    this.tooltip,
    this.semanticLabel,
    this.enabled = true,
    this.menuWidth = 112,
    this.itemHeight = 36,
    this.menuPadding = const EdgeInsets.symmetric(vertical: 6),
    this.offset = const Offset(0, 2),
    this.style,
    this.onOpen,
    this.onClose,
  }) : assert(menuWidth > 0),
       assert(itemHeight > 0);

  /// Actions displayed in their given order.
  final List<EasyMoreMenuItem<T>> items;

  /// Called after an enabled item is selected and the menu starts closing.
  final ValueChanged<T> onSelected;

  /// Replaces the default 30-by-30 more icon button.
  final Widget? button;

  /// Optional tooltip for the trigger button.
  final String? tooltip;

  /// Accessibility label for the trigger. Defaults to [tooltip], then
  /// "More actions".
  final String? semanticLabel;

  /// Whether the menu can be opened.
  final bool enabled;

  final double menuWidth;
  final double itemHeight;
  final EdgeInsetsGeometry menuPadding;
  final Offset offset;
  final EasyMenuStyle? style;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  bool get _canOpen => enabled && items.any((item) => item.enabled);

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return EasyMenuAnchor(
      style: style,
      offset: offset,
      layoutDelegate: const EasyMenuAnchorLayoutDelegate(),
      onOpen: onOpen,
      onClose: onClose,
      childBuilder: (context, controller, child) {
        final trigger = Semantics(
          button: true,
          enabled: _canOpen,
          expanded: controller.isOpen,
          label: semanticLabel ?? tooltip ?? 'More actions',
          child: InkResponse(
            excludeFromSemantics: true,
            onTap:
                _canOpen
                    ? () =>
                        controller.isOpen
                            ? controller.close()
                            : controller.open()
                    : null,
            radius: 18,
            child:
                button != null
                    ? IgnorePointer(child: button)
                    : SizedBox.square(
                      dimension: 30,
                      child: Icon(
                        Icons.more_horiz,
                        size: 20,
                        color: _canOpen ? theme.neutral33 : theme.neutral99,
                      ),
                    ),
          ),
        );

        return tooltip == null
            ? trigger
            : Tooltip(
              message: tooltip!,
              excludeFromSemantics: true,
              child: trigger,
            );
      },
      menuBuilder: (context, controller, overlayInfo) {
        return SizedBox(
          width: menuWidth,
          child: Padding(
            padding: menuPadding,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final item in items)
                    _EasyMoreMenuEntry<T>(
                      item: item,
                      height: itemHeight,
                      onTap: () {
                        controller.close();
                        onSelected(item.value);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Describes one action in an [EasyMoreMenu].
@immutable
class EasyMoreMenuItem<T> {
  const EasyMoreMenuItem({
    required this.value,
    required this.label,
    this.leading,
    this.enabled = true,
    this.danger = false,
    this.textStyle,
  });

  final T value;
  final String label;

  /// Optional icon or other compact widget shown before [label].
  final Widget? leading;

  final bool enabled;
  final bool danger;

  /// Overrides the default label style while preserving disabled opacity.
  final TextStyle? textStyle;
}

class _EasyMoreMenuEntry<T> extends StatelessWidget {
  const _EasyMoreMenuEntry({
    required this.item,
    required this.height,
    required this.onTap,
  });

  final EasyMoreMenuItem<T> item;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    final color =
        item.enabled
            ? (item.danger ? theme.warning : theme.neutral33)
            : theme.neutral99;
    final mergedStyle = TextStyle(
      fontSize: 14,
      color: color,
    ).merge(item.textStyle);
    final style =
        item.enabled
            ? mergedStyle
            : mergedStyle.copyWith(color: theme.neutral99);

    return SizedBox(
      height: height,
      child: Semantics(
        button: true,
        enabled: item.enabled,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: item.enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (item.leading != null) ...[
                  IconTheme(
                    data: IconThemeData(size: 16, color: style.color),
                    child: item.leading!,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
