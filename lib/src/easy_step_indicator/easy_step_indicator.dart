import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_ui/easy_ui.dart';

typedef EasyStepIndicatorStyle =
    ({
      Color? backgroundColor,
      Color? textColor,
      Color? iconBackgroundColor,
      Color? iconColor,
    });

const Color _stepIndicatorDoneIconBackgroundColor = Colors.white;
const Color _stepIndicatorDoingIconBackgroundColor = Color(0xFF31DA9F);
const Color _stepIndicatorWaitingIconBackgroundColor = Color(0xFF999999);
const Color _stepIndicatorDefaultIconColor = Colors.white;

class EasyStepIndicator extends StatelessWidget {
  final int stepsLength;
  final List<String> stepNames;
  final int currentStep;
  final int? selectedStep;
  final double selectedStepScale;
  final ValueChanged<int>? onSelectedStepChanged;
  final double height;
  final Map<int, EasyStepIndicatorStyle>? stepStyles;
  final Map<int, Widget>? stepIcons;

  const EasyStepIndicator({
    super.key,
    required this.stepsLength,
    required this.stepNames,
    required this.currentStep,
    this.selectedStep,
    this.selectedStepScale = 1.15,
    this.onSelectedStepChanged,
    this.height = 76,
    this.stepStyles,
    this.stepIcons,
  });

  Color _getBackgroundColor(BuildContext context, int stepIndex) {
    final customColor = stepStyles?[stepIndex]?.backgroundColor;
    if (customColor != null) return customColor;

    final primaryGreen = EasyTheme.of(context).primaryGreen;
    if (stepIndex < currentStep) return primaryGreen;
    if (stepIndex == currentStep) {
      if (stepIndex == stepsLength - 1) return primaryGreen;
      return const Color(0xFFB5F2DD);
    }
    return EasyTheme.of(context).neutralF8;
  }

  Color _getTextColor(BuildContext context, int stepIndex) {
    final customColor = stepStyles?[stepIndex]?.textColor;
    if (customColor != null) return customColor;

    final primaryGreen = EasyTheme.of(context).primaryGreen;
    if (stepIndex < currentStep) return EasyTheme.of(context).background;
    if (stepIndex == currentStep) {
      if (stepIndex == stepsLength - 1) return EasyTheme.of(context).background;
      return primaryGreen;
    }
    return EasyTheme.of(context).neutral99;
  }

  String _getIconAssetName(int stepIndex) {
    if (stepIndex < currentStep) return 'assets/svgs/ic_did.svg';
    if (stepIndex == currentStep) return 'assets/svgs/ic_doing.svg';
    return 'assets/svgs/ic_waiting.svg';
  }

  Color _getDefaultIconBackgroundColor(int stepIndex) {
    if (stepIndex < currentStep) return _stepIndicatorDoneIconBackgroundColor;
    if (stepIndex == currentStep) {
      return _stepIndicatorDoingIconBackgroundColor;
    }
    return _stepIndicatorWaitingIconBackgroundColor;
  }

  Color _getDefaultIconColor(BuildContext context, int stepIndex) {
    if (stepIndex < currentStep) return EasyTheme.of(context).primaryGreen;
    return _stepIndicatorDefaultIconColor;
  }

  Color _getIconBackgroundColor(int stepIndex) {
    final customColor = stepStyles?[stepIndex]?.iconBackgroundColor;
    if (customColor != null) return customColor;
    return _getDefaultIconBackgroundColor(stepIndex);
  }

  Color _getIconColor(BuildContext context, int stepIndex) {
    final customColor = stepStyles?[stepIndex]?.iconColor;
    if (customColor != null) return customColor;
    return _getDefaultIconColor(context, stepIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (stepsLength == 0) return const SizedBox();

    return Container(
      height: height,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          if (availableWidth == double.infinity) {
            availableWidth = stepsLength * 120.0;
          }

          final double minTotalWidth = stepsLength * 120.0;
          final double width = max(availableWidth, minTotalWidth);

          final double height = 44.0;
          final double arrowWidth = 20.0;
          final double gap = 4.0;
          final double overlap = arrowWidth - gap;

          final int? selectedIndex =
              selectedStep != null &&
                      selectedStep! >= 0 &&
                      selectedStep! < stepsLength
                  ? selectedStep
                  : null;
          final double totalStepWidth = width + (stepsLength - 1) * overlap;
          final double selectedWeight =
              selectedIndex == null ? 1.0 : max(selectedStepScale, 1.0);
          final double totalWeight =
              stepsLength - 1 + (selectedIndex == null ? 1.0 : selectedWeight);
          final double regularStepWidth = totalStepWidth / totalWeight;
          final List<double> stepWidths = List.generate(
            stepsLength,
            (index) =>
                index == selectedIndex
                    ? regularStepWidth * selectedWeight
                    : regularStepWidth,
          );
          final List<double> stepLeftOffsets = [];
          double nextLeftOffset = 0;
          for (final stepWidth in stepWidths) {
            stepLeftOffsets.add(nextLeftOffset);
            nextLeftOffset += stepWidth - overlap;
          }
          final List<int> stepIndexes = List.generate(
            stepsLength,
            (index) => index,
          );
          if (selectedIndex != null) {
            stepIndexes
              ..remove(selectedIndex)
              ..add(selectedIndex);
          }

          Widget content = SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children:
                  stepIndexes.map((index) {
                    final isFirst = index == 0;
                    final isLast = index == stepsLength - 1;
                    final isSelected = index == selectedIndex;
                    final double leftOffset = stepLeftOffsets[index];
                    final double stepWidth = stepWidths[index];
                    final double activeScale =
                        isSelected ? selectedWeight : 1.0;
                    final double unscaledStepWidth = stepWidth / activeScale;
                    final Alignment scaleAlignment =
                        isFirst
                            ? Alignment.centerLeft
                            : isLast
                            ? Alignment.centerRight
                            : Alignment.center;

                    return AnimatedPositioned(
                      key: ValueKey('alab-step-indicator-step-$index'),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: leftOffset,
                      top: 0,
                      bottom: 0,
                      width: stepWidth,
                      child: MouseRegion(
                        cursor:
                            onSelectedStepChanged != null
                                ? SystemMouseCursors.click
                                : MouseCursor.defer,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap:
                              onSelectedStepChanged == null
                                  ? null
                                  : () => onSelectedStepChanged?.call(index),
                          child: Align(
                            alignment: scaleAlignment,
                            child: SizedBox(
                              width: unscaledStepWidth,
                              height: height,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                scale: activeScale,
                                alignment: scaleAlignment,
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  tween: Tween<double>(end: isSelected ? 1 : 0),
                                  builder: (context, shadowOpacity, child) {
                                    return CustomPaint(
                                      painter: _ChevronShadowPainter(
                                        clipper: ChevronClipper(
                                          arrowWidth: arrowWidth,
                                          isFirst: isFirst,
                                          isLast: isLast,
                                        ),
                                        shadow: BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.24,
                                          ),
                                          blurRadius: 14,
                                        ),
                                        shadowOpacity: shadowOpacity,
                                      ),
                                      child: ClipPath(
                                        clipper: ChevronClipper(
                                          arrowWidth: arrowWidth,
                                          isFirst: isFirst,
                                          isLast: isLast,
                                        ),
                                        child: child!,
                                      ),
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: _getBackgroundColor(
                                        context,
                                        index,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      left:
                                          isFirst
                                              ? 16.0
                                              : 16.0 + arrowWidth * 0.5,
                                      right:
                                          isLast
                                              ? 16.0
                                              : 16.0 + arrowWidth * 0.5,
                                    ),
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _getTextColor(context, index),
                                        // Provide default font family to avoid Material default yellow underline if no Theme exists in the context path somehow, though not strictly necessary.
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          stepIcons?[index] ??
                                              SvgPicture.asset(
                                                package: 'easy_ui',
                                                _getIconAssetName(index),
                                                key: ValueKey(
                                                  'alab-step-indicator-icon-$index',
                                                ),
                                                width: 14,
                                                height: 14,
                                                colorMapper:
                                                    _StepIndicatorIconColorMapper(
                                                      defaultBackgroundColor:
                                                          _getDefaultIconBackgroundColor(
                                                            index,
                                                          ),
                                                      defaultIconColor:
                                                          _getDefaultIconColor(
                                                            context,
                                                            index,
                                                          ),
                                                      backgroundColor:
                                                          _getIconBackgroundColor(
                                                            index,
                                                          ),
                                                      iconColor: _getIconColor(
                                                        context,
                                                        index,
                                                      ),
                                                    ),
                                              ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: Text(
                                              stepNames.length > index
                                                  ? stepNames[index]
                                                  : '${index + 1}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          );

          if (width > availableWidth) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }
}

class _ChevronShadowPainter extends CustomPainter {
  final ChevronClipper clipper;
  final BoxShadow shadow;
  final double shadowOpacity;

  _ChevronShadowPainter({
    required this.clipper,
    required this.shadow,
    required this.shadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (shadowOpacity == 0) return;

    final path = clipper.getClip(size).shift(shadow.offset);
    final color = shadow.color.withValues(
      alpha: shadow.color.a * shadowOpacity,
    );
    canvas.drawPath(
      path,
      BoxShadow(
        color: color,
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
        blurStyle: shadow.blurStyle,
      ).toPaint(),
    );
  }

  @override
  bool shouldRepaint(covariant _ChevronShadowPainter oldDelegate) {
    return oldDelegate.clipper.shouldReclip(clipper) ||
        oldDelegate.shadow != shadow ||
        oldDelegate.shadowOpacity != shadowOpacity;
  }
}

class _StepIndicatorIconColorMapper extends ColorMapper {
  final Color defaultBackgroundColor;
  final Color defaultIconColor;
  final Color backgroundColor;
  final Color iconColor;

  const _StepIndicatorIconColorMapper({
    required this.defaultBackgroundColor,
    required this.defaultIconColor,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color == defaultBackgroundColor) return backgroundColor;
    if (color == defaultIconColor) return iconColor;
    return color;
  }

  @override
  bool operator ==(Object other) {
    return other is _StepIndicatorIconColorMapper &&
        other.defaultBackgroundColor == defaultBackgroundColor &&
        other.defaultIconColor == defaultIconColor &&
        other.backgroundColor == backgroundColor &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode => Object.hash(
    defaultBackgroundColor,
    defaultIconColor,
    backgroundColor,
    iconColor,
  );
}

class ChevronClipper extends CustomClipper<Path> {
  final double arrowWidth;
  final bool isFirst;
  final bool isLast;

  ChevronClipper({
    required this.arrowWidth,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (isFirst && isLast) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (isFirst) {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
    } else if (isLast) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ChevronClipper oldClipper) {
    return oldClipper.arrowWidth != arrowWidth ||
        oldClipper.isFirst != isFirst ||
        oldClipper.isLast != isLast;
  }
}
