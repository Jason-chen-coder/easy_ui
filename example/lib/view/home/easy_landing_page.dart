import 'dart:async';
import 'dart:math' as math;

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
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const _easyUiRepoUrl = 'https://github.com/Jason-chen-coder/EasyUI';
const _githubProfileUrl = 'https://github.com/Jason-chen-coder';
const _sponsorEmail = 'hongxin.jasonchen@gmail.com';

const _skillInstallCommand = 'npx --yes github:Jason-chen-coder/EasyUI';

Future<void> _launchExternal(
  Uri uri, {
  String webOnlyWindowName = '_blank',
}) async {
  final launched = await launchUrl(
    uri,
    mode: LaunchMode.platformDefault,
    webOnlyWindowName: webOnlyWindowName,
  );

  if (!launched) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<void> _copyText(
  BuildContext context, {
  required String text,
  required String message,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class _LandingTypography {
  const _LandingTypography._();

  static TextStyle heroTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 56,
      height: 1.02,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
    );
  }

  static TextStyle heroSubtitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 21,
      height: 1.42,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }

  static TextStyle sectionTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 31,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  static TextStyle sectionEyebrow(_LandingPalette palette) {
    return TextStyle(
      color: palette.primary,
      fontSize: 13,
      height: 1.3,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
    );
  }

  static TextStyle contentTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 18,
      height: 1.35,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  static TextStyle body(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 16,
      height: 1.7,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );
  }

  static TextStyle bodySmall(_LandingPalette palette) {
    return TextStyle(
      color: palette.textSoft,
      fontSize: 14,
      height: 1.65,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }

  static TextStyle link(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 17,
      height: 1.35,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }

  static TextStyle linkStrong(_LandingPalette palette) {
    return link(
      palette,
    ).copyWith(color: palette.blue, fontWeight: FontWeight.w800);
  }
}

class EasyLandingPage extends StatefulWidget {
  const EasyLandingPage({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  static const _maxWidth = 1180.0;

  @override
  State<EasyLandingPage> createState() => _EasyLandingPageState();
}

class _EasyLandingPageState extends State<EasyLandingPage> {
  final _revealTick = ValueNotifier<int>(0);

  @override
  void dispose() {
    _revealTick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = _LandingPalette.resolve(isDark);

    return Scaffold(
      backgroundColor: palette.background,
      body: _ScrollRevealScope(
        listenable: _revealTick,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              _revealTick.value++;
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _HeroSection(
                  palette: palette,
                  onNavigate: widget.onNavigate,
                ),
              ),
              SliverToBoxAdapter(
                child: _ConstrainedSection(
                  top: 34,
                  bottom: 36,
                  child: _PlatformFeatureSection(palette: palette),
                ),
              ),
              SliverToBoxAdapter(
                child: _ConstrainedSection(
                  top: 36,
                  bottom: 36,
                  child: _CapabilityFeatureSection(palette: palette),
                ),
              ),
              SliverToBoxAdapter(
                child: _ConstrainedSection(
                  top: 20,
                  bottom: 34,
                  child: _AiSkillSection(palette: palette),
                ),
              ),
              SliverToBoxAdapter(
                child: _ConstrainedSection(
                  top: 20,
                  bottom: 34,
                  child: _ComponentPreviewSection(
                    palette: palette,
                    onNavigate: widget.onNavigate,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _ConstrainedSection(
                  top: 20,
                  bottom: 64,
                  child: _ResourceSection(palette: palette),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollRevealScope extends InheritedWidget {
  const _ScrollRevealScope({required this.listenable, required super.child});

  final Listenable listenable;

  static Listenable? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScrollRevealScope>()
        ?.listenable;
  }

  @override
  bool updateShouldNotify(_ScrollRevealScope oldWidget) {
    return listenable != oldWidget.listenable;
  }
}

class _ViewportFadeIn extends StatefulWidget {
  const _ViewportFadeIn({required this.child});

  final Widget child;

  @override
  State<_ViewportFadeIn> createState() => _ViewportFadeInState();
}

class _ViewportFadeInState extends State<_ViewportFadeIn> {
  static const _threshold = 120.0;
  static const _duration = Duration(milliseconds: 300);

  bool _visible = false;
  Listenable? _revealSignal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachRevealSignal();
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _revealSignal?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _attachRevealSignal() {
    final nextSignal = _ScrollRevealScope.maybeOf(context);
    if (nextSignal == _revealSignal) {
      return;
    }

    _revealSignal?.removeListener(_checkVisibility);
    _revealSignal = nextSignal;
    _revealSignal?.addListener(_checkVisibility);
  }

  void _scheduleVisibilityCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkVisibility();
      }
    });
  }

  void _checkVisibility() {
    if (_visible) {
      return;
    }

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery?.disableAnimations ?? false) {
      setState(() => _visible = true);
      _revealSignal?.removeListener(_checkVisibility);
      _revealSignal = null;
      return;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportHeight = mediaQuery?.size.height ?? 0;

    if (bottom >= -_threshold && top <= viewportHeight + _threshold) {
      setState(() => _visible = true);
      _revealSignal?.removeListener(_checkVisibility);
      _revealSignal = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final visible = _visible || disableAnimations;

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: _duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.035),
        duration: _duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      decoration: BoxDecoration(
        color: palette.heroBackground,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: _ConstrainedSection(
        top: 24,
        bottom: 52,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: math.min(viewportHeight, 760)),
          child: Column(
            children: [
              SizedBox(height: width < 720 ? 42 : 58),
              _HeroIntro(palette: palette, onNavigate: onNavigate),
              SizedBox(height: width < 720 ? 34 : 46),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _HeroVisual(palette: palette),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleStyle = _LandingTypography.heroTitle(palette).copyWith(
      fontSize:
          width < 420
              ? 43
              : width < 720
              ? 50
              : 66,
      height: width < 720 ? 1.02 : 0.98,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Easy UI Design', textAlign: TextAlign.center, style: titleStyle),
        const SizedBox(height: 16),
        Text(
          'Flutter 全平台应用的组件工作台',
          textAlign: TextAlign.center,
          style: _LandingTypography.heroSubtitle(palette),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            '迁移后的组件集中在一个可浏览、可验证、可复制的 Flutter UI kit 里。',
            textAlign: TextAlign.center,
            style: _LandingTypography.body(palette),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate('/overview'),
              icon: const Icon(Icons.widgets_outlined, size: 18),
              label: const Text('浏览组件'),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                shape: const StadiumBorder(),
              ),
            ),
            OutlinedButton.icon(
              onPressed:
                  () => _copyText(
                    context,
                    text: _skillInstallCommand,
                    message: '安装命令已复制',
                  ),
              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
              label: const Text('安装 Skill'),
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textStrong,
                side: BorderSide(color: palette.borderStrong),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.sizeOf(context).width < 720
              ? 390
              : math.max(320, MediaQuery.sizeOf(context).height - 420),
      child: Container(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 720 ? 18 : 26,
        ),
        decoration: BoxDecoration(
          color: palette.previewBackground,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 36,
              offset: const Offset(0, 26),
            ),
          ],
        ),
        child: _ComponentAssetMap(palette: palette),
      ),
    );
  }
}

class _ComponentAssetMap extends StatefulWidget {
  const _ComponentAssetMap({required this.palette});

  final _LandingPalette palette;

  @override
  State<_ComponentAssetMap> createState() => _ComponentAssetMapState();
}

class _ComponentAssetMapState extends State<_ComponentAssetMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      return _buildStage(context, 0.18);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _buildStage(context, _controller.value),
    );
  }

  Widget _buildStage(BuildContext context, double progress) {
    final palette = widget.palette;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.previewBackground,
            palette.primary.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(28),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final nodeWidth = compact ? 126.0 : 168.0;
          final nodeHeight = compact ? 62.0 : 70.0;
          final coreSize = compact ? 120.0 : 164.0;
          final phase = progress * math.pi * 2;
          final pulse = (math.sin(phase) + 1) / 2;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _AssetMapPainter(
                    palette: palette,
                    progress: progress,
                    compact: compact,
                  ),
                ),
              ),
              Positioned(
                width: compact ? 220 : 330,
                height: compact ? 220 : 330,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        palette.surface.withValues(alpha: 0.9),
                        palette.primary.withValues(alpha: 0.1 + pulse * 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              _AssetNode(
                alignment:
                    compact
                        ? const Alignment(-0.88, -0.76)
                        : const Alignment(-0.8, -0.72),
                width: nodeWidth,
                height: nodeHeight,
                icon: Icons.widgets_outlined,
                title: '基础组件',
                description: compact ? 'Button / SVG' : 'Button / Avatar / SVG',
                color: palette.primary,
                palette: palette,
              ),
              _AssetNode(
                alignment:
                    compact
                        ? const Alignment(0.88, -0.76)
                        : const Alignment(0.8, -0.72),
                width: nodeWidth,
                height: nodeHeight,
                icon: Icons.table_chart_outlined,
                title: '数据展示',
                description: compact ? 'Table / Flow' : 'Table / Flow / Card',
                color: palette.blue,
                palette: palette,
              ),
              _AssetNode(
                alignment:
                    compact
                        ? const Alignment(-0.88, 0.4)
                        : const Alignment(-0.84, 0.5),
                width: nodeWidth,
                height: nodeHeight,
                icon: Icons.tune_outlined,
                title: '数据输入',
                description:
                    compact ? 'Form / Select' : 'Form / Select / Picker',
                color: palette.amber,
                palette: palette,
              ),
              _AssetNode(
                alignment:
                    compact
                        ? const Alignment(0.88, 0.4)
                        : const Alignment(0.84, 0.5),
                width: nodeWidth,
                height: nodeHeight,
                icon: Icons.campaign_outlined,
                title: '反馈与 H5',
                description: compact ? 'Dialog / H5' : 'Dialog / Toast / H5',
                color: palette.red,
                palette: palette,
              ),
              Transform.scale(
                scale: 1 + pulse * 0.018,
                child: _AssetMapCore(
                  palette: palette,
                  size: coreSize,
                  compact: compact,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.92),
                child: _AssetPipeline(palette: palette, compact: compact),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AssetMapCore extends StatelessWidget {
  const _AssetMapCore({
    required this.palette,
    required this.size,
    required this.compact,
  });

  final _LandingPalette palette;
  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(compact ? 16 : 22),
      decoration: BoxDecoration(
        color: palette.surface,
        shape: BoxShape.circle,
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Image.asset('assets/images/easy_ui_logo.png', fit: BoxFit.contain),
    );
  }
}

class _AssetNode extends StatelessWidget {
  const _AssetNode({
    required this.alignment,
    required this.width,
    required this.height,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.palette,
  });

  final Alignment alignment;
  final double width;
  final double height;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: 0.94),
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: palette.shadow.withValues(alpha: 0.75),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _LandingTypography.bodySmall(palette).copyWith(
                      color: palette.textStrong,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _LandingTypography.bodySmall(
                      palette,
                    ).copyWith(fontSize: 12, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetPipeline extends StatelessWidget {
  const _AssetPipeline({required this.palette, required this.compact});

  final _LandingPalette palette;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final items = compact ? ['需求', '索引', '页面'] : ['业务需求', '组件索引', 'Flutter 页面'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.9),
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in items.indexed) ...[
            if (entry.$1 != 0) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 10),
                child: Icon(
                  Icons.arrow_forward,
                  size: compact ? 13 : 15,
                  color: palette.textSoft,
                ),
              ),
            ],
            Text(
              entry.$2,
              style: _LandingTypography.bodySmall(palette).copyWith(
                color:
                    entry.$1 == items.length - 1
                        ? palette.primary
                        : palette.textMuted,
                fontWeight:
                    entry.$1 == items.length - 1
                        ? FontWeight.w800
                        : FontWeight.w600,
                fontSize: compact ? 12 : 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetMapPainter extends CustomPainter {
  const _AssetMapPainter({
    required this.palette,
    required this.progress,
    required this.compact,
  });

  final _LandingPalette palette;
  final double progress;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..color = palette.primary.withValues(alpha: 0.2);
    final activePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = palette.primary.withValues(alpha: 0.45);
    final dotPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = palette.primary.withValues(alpha: 0.5);

    final points = <Offset>[
      Offset(size.width * 0.21, size.height * 0.2),
      Offset(size.width * 0.79, size.height * 0.2),
      Offset(size.width * 0.21, size.height * (compact ? 0.64 : 0.68)),
      Offset(size.width * 0.79, size.height * (compact ? 0.64 : 0.68)),
    ];

    for (final point in points) {
      final control = Offset((center.dx + point.dx) / 2, center.dy);
      final path =
          Path()
            ..moveTo(center.dx, center.dy)
            ..quadraticBezierTo(control.dx, control.dy, point.dx, point.dy);
      canvas.drawPath(path, linePaint);
    }

    final orbit = Rect.fromCenter(
      center: center,
      width: size.width * (compact ? 0.56 : 0.42),
      height: size.height * (compact ? 0.46 : 0.52),
    );
    canvas.drawOval(orbit, linePaint);
    canvas.drawArc(
      orbit,
      progress * math.pi * 2,
      math.pi * 0.42,
      false,
      activePaint,
    );

    final angle = progress * math.pi * 2;
    final dot = Offset(
      orbit.center.dx + math.cos(angle) * orbit.width / 2,
      orbit.center.dy + math.sin(angle) * orbit.height / 2,
    );
    canvas.drawCircle(dot, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _AssetMapPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.palette != palette ||
        oldDelegate.compact != compact;
  }
}

class _PlatformFeatureSection extends StatelessWidget {
  const _PlatformFeatureSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final feature = _FeatureData(
      icon: Icons.devices_other,
      color: palette.blue,
      title: '全平台支持',
      description: '一套 Easy UI 组件覆盖移动端、桌面端与 Web，让迁移后的 Flutter 页面保持一致体验。',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '把 Flutter 页面迁移，收进一套工作台。',
          textAlign: TextAlign.center,
          style: _LandingTypography.sectionTitle(palette),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            '跨端支持、组件组合、开放源码和响应式适配，被组织成同一个可以直接验证的 example 流程。',
            textAlign: TextAlign.center,
            style: _LandingTypography.body(palette),
          ),
        ),
        const SizedBox(height: 30),
        _ViewportFadeIn(
          child: _FeatureSpotlight(data: feature, palette: palette),
        ),
      ],
    );
  }
}

class _CapabilityFeatureSection extends StatelessWidget {
  const _CapabilityFeatureSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatureData(
        icon: Icons.widgets_outlined,
        color: palette.amber,
        title: '组件化',
        description: '组件独立存在，可选择使用个体组件。不侵入你原有的项目代码结构。',
      ),
      _FeatureData(
        icon: Icons.code,
        color: palette.green,
        title: '源代码开放',
        description: 'MIT 开源协议，源代码完全公开，允许任何个人和企业使用。',
      ),
      _FeatureData(
        icon: Icons.web_asset_outlined,
        color: palette.red,
        title: '响应式布局',
        description: '根据设备屏幕信息，让视图可以响应式变化。',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '迁移后的页面能力栈',
          textAlign: TextAlign.center,
          style: _LandingTypography.sectionTitle(palette),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            '组件组合、开放源码和响应式适配，构成从迁移到交付的完整页面能力。',
            textAlign: TextAlign.center,
            style: _LandingTypography.body(palette),
          ),
        ),
        const SizedBox(height: 30),
        _ViewportFadeIn(
          child: _FeatureSupportPanel(items: items, palette: palette),
        ),
      ],
    );
  }
}

class _FeatureSpotlight extends StatelessWidget {
  const _FeatureSpotlight({required this.data, required this.palette});

  final _FeatureData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final platforms = [
      _PlatformSupportData(
        name: 'Android',
        group: 'Mobile',
        icon: Icons.android,
        color: palette.green,
      ),
      _PlatformSupportData(
        name: 'iOS',
        group: 'Mobile',
        icon: Icons.phone_iphone,
        color: palette.blue,
      ),
      _PlatformSupportData(
        name: 'macOS',
        group: 'Desktop',
        icon: Icons.desktop_mac,
        color: palette.primary,
      ),
      _PlatformSupportData(
        name: 'Windows',
        group: 'Desktop',
        icon: Icons.desktop_windows,
        color: palette.blue,
      ),
      _PlatformSupportData(
        name: 'Linux',
        group: 'Desktop',
        icon: Icons.terminal,
        color: palette.amber,
      ),
      _PlatformSupportData(
        name: 'Web',
        group: 'Browser',
        icon: Icons.language,
        color: palette.red,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final tight = constraints.maxWidth < 390;

        return Container(
          padding: EdgeInsets.all(compact ? 22 : 30),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border.all(color: data.color.withValues(alpha: 0.18)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: palette.shadow.withValues(alpha: 0.32),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: data.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: data.color.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Icon(data.icon, color: data.color, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CROSS PLATFORM',
                          style: _LandingTypography.sectionEyebrow(palette),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '一套 Flutter 工程，多端交付',
                          style: _LandingTypography.bodySmall(
                            palette,
                          ).copyWith(color: palette.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (!tight)
                    _PlatformCountBadge(
                      count: platforms.length,
                      palette: palette,
                    ),
                ],
              ),
              SizedBox(height: compact ? 24 : 30),
              Text(
                data.title,
                style: _LandingTypography.sectionTitle(palette).copyWith(
                  color: palette.textStrong,
                  fontSize: compact ? 31 : 36,
                ),
              ),
              const SizedBox(height: 12),
              Text(data.description, style: _LandingTypography.body(palette)),
              SizedBox(height: compact ? 22 : 26),
              _PlatformSupportBoard(platforms: platforms, palette: palette),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _PlatformCapabilityPill(
                    icon: Icons.layers_outlined,
                    label: '同一组件 API',
                    palette: palette,
                  ),
                  _PlatformCapabilityPill(
                    icon: Icons.fit_screen_outlined,
                    label: '自适应布局',
                    palette: palette,
                  ),
                  _PlatformCapabilityPill(
                    icon: Icons.verified_outlined,
                    label: 'Example 可验证',
                    palette: palette,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlatformSupportData {
  const _PlatformSupportData({
    required this.name,
    required this.group,
    required this.icon,
    required this.color,
  });

  final String name;
  final String group;
  final IconData icon;
  final Color color;
}

class _PlatformCountBadge extends StatelessWidget {
  const _PlatformCountBadge({required this.count, required this.palette});

  final int count;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.textStrong.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '$count targets',
          style: _LandingTypography.bodySmall(
            palette,
          ).copyWith(color: palette.textStrong, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _PlatformSupportBoard extends StatelessWidget {
  const _PlatformSupportBoard({required this.platforms, required this.palette});

  final List<_PlatformSupportData> platforms;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.previewBackground.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              constraints.maxWidth < 330
                  ? 1
                  : constraints.maxWidth < 540
                  ? 2
                  : 3;
          const gap = 10.0;
          final tileWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: palette.surface.withValues(alpha: 0.86),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: palette.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.device_hub_outlined,
                      color: palette.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Easy UI adaptive component layer',
                        style: _LandingTypography.bodySmall(palette).copyWith(
                          color: palette.textStrong,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    platforms
                        .map(
                          (platform) => SizedBox(
                            width: tileWidth,
                            child: _PlatformTargetTile(
                              data: platform,
                              palette: palette,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlatformTargetTile extends StatelessWidget {
  const _PlatformTargetTile({required this.data, required this.palette});

  final _PlatformSupportData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: palette.surface.withValues(alpha: 0.82),
              shape: BoxShape.circle,
              border: Border.all(color: data.color.withValues(alpha: 0.24)),
            ),
            child: Icon(data.icon, color: data.color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _LandingTypography.bodySmall(palette).copyWith(
                    color: palette.textStrong,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.group,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _LandingTypography.bodySmall(
                    palette,
                  ).copyWith(fontSize: 12, height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformCapabilityPill extends StatelessWidget {
  const _PlatformCapabilityPill({
    required this.icon,
    required this.label,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: palette.primary, size: 16),
            const SizedBox(width: 7),
            Text(label, style: _LandingTypography.bodySmall(palette)),
          ],
        ),
      ),
    );
  }
}

class _AiSkillSection extends StatelessWidget {
  const _AiSkillSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return _ViewportFadeIn(
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            final intro = _AiSkillIntro(palette: palette);
            final install = _AiSkillInstallPanel(palette: palette);

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 24), install],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 9, child: intro),
                const SizedBox(width: 32),
                Expanded(flex: 10, child: install),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AiSkillIntro extends StatelessWidget {
  const _AiSkillIntro({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _SkillStepData('01', '描述需求', palette.blue),
      _SkillStepData('02', '匹配 Easy 组件', palette.green),
      _SkillStepData('03', '生成 Flutter 页面', palette.amber),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI SKILL', style: _LandingTypography.sectionEyebrow(palette)),
        const SizedBox(height: 8),
        Text(
          '用 AI 直接构建 Easy UI 页面',
          style: _LandingTypography.sectionTitle(
            palette,
          ).copyWith(color: palette.textStrong),
        ),
        const SizedBox(height: 12),
        Text(
          'easy-ui-view-builder 内置完整公开组件索引，让 Codex 和 Claude Code 都能从业务需求出发，优先使用真实的 Easy UI 组件和示例模式生成 Flutter 视图。',
          style: _LandingTypography.body(palette),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              steps
                  .map((step) => _SkillStep(data: step, palette: palette))
                  .toList(),
        ),
      ],
    );
  }
}

class _AiSkillInstallPanel extends StatelessWidget {
  const _AiSkillInstallPanel({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    void copyInstallCommand() {
      _copyText(context, text: _skillInstallCommand, message: '安装命令已复制');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: palette.codeBackground,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: copyInstallCommand,
            borderRadius: BorderRadius.circular(18),
            mouseCursor: SystemMouseCursors.click,
            child: Ink(
              decoration: BoxDecoration(
                color: palette.codeBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: palette.borderStrong.withValues(alpha: 0.35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.terminal, color: palette.codeText, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'npx 安装',
                          style: _LandingTypography.contentTitle(
                            palette,
                          ).copyWith(color: palette.codeText),
                        ),
                        const Spacer(),
                        Tooltip(
                          message: '复制安装命令',
                          child: IconButton(
                            onPressed: copyInstallCommand,
                            icon: Icon(
                              Icons.content_copy_outlined,
                              color: palette.codeText,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SelectableText(
                      _skillInstallCommand,
                      style: TextStyle(
                        color: palette.codeText,
                        fontSize: 14,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: palette.codeText.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        '默认安装到 Codex 和 Claude Code。安装后重启对应工具，然后用调用示例开始生成页面。',
                        style: _LandingTypography.bodySmall(
                          palette,
                        ).copyWith(color: palette.codeText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _AiSkillUsageExample(palette: palette),
      ],
    );
  }
}

class _AiSkillUsageExample extends StatefulWidget {
  const _AiSkillUsageExample({required this.palette});

  final _LandingPalette palette;

  @override
  State<_AiSkillUsageExample> createState() => _AiSkillUsageExampleState();
}

class _AiSkillUsageExampleState extends State<_AiSkillUsageExample> {
  static const _aiOutputText = '''
正在匹配 Easy UI 组件...
EasySearchAnchor  处理筛选与关键词搜索
EasyDataTable     承载订单列表
EasyPagination    控制分页状态
EasyDrawer        展示订单详情
EasyStatusIndicator 标记订单状态
生成页面: OrderManagementView''';

  Timer? _typingTimer;
  Timer? _cursorTimer;
  int _visibleCharacters = 0;
  bool _startedTyping = false;
  bool _startedCursorBlink = false;
  bool _cursorVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      _typingTimer?.cancel();
      _cursorTimer?.cancel();
      _visibleCharacters = _aiOutputText.length;
      _cursorVisible = true;
      _startedCursorBlink = false;
      return;
    }

    if (!_startedCursorBlink) {
      _startedCursorBlink = true;
      _cursorTimer = Timer.periodic(const Duration(milliseconds: 520), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _cursorVisible = !_cursorVisible;
        });
      });
    }

    if (!_startedTyping) {
      _startedTyping = true;
      _typingTimer = Timer.periodic(const Duration(milliseconds: 24), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _visibleCharacters = math.min(
            _visibleCharacters + 1,
            _aiOutputText.length,
          );
        });

        if (_visibleCharacters >= _aiOutputText.length) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final typedText = _aiOutputText.substring(0, _visibleCharacters);
    final userTextStyle = TextStyle(
      color: palette.blue,
      fontSize: 13,
      height: 1.55,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
    final terminalTextStyle = TextStyle(
      color: palette.codeText,
      fontSize: 13,
      height: 1.58,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    return Material(
      color: palette.codeBackground,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: palette.codeBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: palette.borderStrong.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: palette.surface.withValues(alpha: 0.07),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: palette.codeText.withValues(alpha: 0.12),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _TerminalDot(color: palette.red),
                  const SizedBox(width: 6),
                  _TerminalDot(color: palette.amber),
                  const SizedBox(width: 6),
                  _TerminalDot(color: palette.green),
                  const Spacer(),
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: palette.amber,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '使用实例',
                    style: _LandingTypography.bodySmall(
                      palette,
                    ).copyWith(color: palette.codeText),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r'$ 帮我用 Easy UI 做一个订单管理页，包含筛选、表格、分页和详情抽屉。',
                    style: userTextStyle,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 154),
                    child: RichText(
                      text: TextSpan(
                        style: terminalTextStyle,
                        children: [
                          TextSpan(text: typedText),
                          TextSpan(
                            text: '|',
                            style: terminalTextStyle.copyWith(
                              color: palette.codeText.withValues(
                                alpha: _cursorVisible ? 1 : 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerminalDot extends StatelessWidget {
  const _TerminalDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox(width: 8, height: 8),
    );
  }
}

class _ComponentPreviewSection extends StatelessWidget {
  const _ComponentPreviewSection({
    required this.palette,
    required this.onNavigate,
  });

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final left = _SectionHeader(
          eyebrow: 'COMPONENT MAP',
          title: '从总览进入，再深入到每个组件',
          description:
              'Easy UI example 保留了组件库工作台的密度：左侧导航负责快速定位，右侧页面承载完整 API、用法和边界状态。',
          palette: palette,
        );
        final right = _CategoryRail(palette: palette, onNavigate: onNavigate);

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 22), right],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 9, child: right),
            const SizedBox(width: 34),
            Expanded(flex: 8, child: left),
          ],
        );
      },
    );
  }
}

class _ResourceSection extends StatelessWidget {
  const _ResourceSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SponsorSection(palette: palette),
        _FooterDivider(palette: palette),
        _FooterCopyright(palette: palette),
      ],
    );
  }
}

class _SponsorSection extends StatefulWidget {
  const _SponsorSection({required this.palette});

  final _LandingPalette palette;

  @override
  State<_SponsorSection> createState() => _SponsorSectionState();
}

class _SponsorSectionState extends State<_SponsorSection> {
  final _sponsorTooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final projects = [
      const _SponsorProjectData(
        name: 'Mxgraph EasyFlowEditor',
        description: '基于 mxGraph 和 Vue 2.0 的流程图编辑器',
        url: 'https://github.com/Jason-chen-coder/Mxgraph-EasyFlowEditor',
        imageAsset: 'assets/images/mxgraph_app_icon.png',
      ),
      const _SponsorProjectData(
        name: 'Flutter EasySpeechRecognition',
        description: 'Flutter 语音识别与录音能力工具',
        url:
            'https://github.com/Jason-chen-coder/Flutter-EasySpeechRecognition',
        imageAsset: 'assets/images/easy_speech_logo.jpg',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Text(
            '合作与赞助',
            textAlign: TextAlign.center,
            style: _LandingTypography.sectionTitle(palette),
          ),
          const SizedBox(height: 54),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final projectCards =
                  projects
                      .map(
                        (project) => _SponsorProjectCard(
                          data: project,
                          palette: palette,
                        ),
                      )
                      .toList();

              if (compact) {
                return Column(
                  children:
                      projectCards
                          .map(
                            (card) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: card,
                            ),
                          )
                          .toList(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: projectCards[0]),
                  const SizedBox(width: 78),
                  Flexible(child: projectCards[1]),
                ],
              );
            },
          ),
          const SizedBox(height: 50),
          Tooltip(
            key: _sponsorTooltipKey,
            message: _sponsorEmail,
            triggerMode: TooltipTriggerMode.manual,
            preferBelow: false,
            showDuration: const Duration(seconds: 4),
            child: OutlinedButton(
              onPressed: () {
                _sponsorTooltipKey.currentState?.ensureTooltipVisible();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textMuted,
                side: BorderSide(color: palette.borderStrong),
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 17,
                ),
                shape: const StadiumBorder(),
                textStyle: _LandingTypography.link(palette),
              ),
              child: const Text('成为赞助商!'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorProjectCard extends StatelessWidget {
  const _SponsorProjectCard({required this.data, required this.palette});

  final _SponsorProjectData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '打开 ${data.name}',
      child: InkWell(
        onTap:
            () => _launchExternal(
              Uri.parse(data.url),
              webOnlyWindowName: '_self',
            ),
        borderRadius: BorderRadius.circular(8),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SponsorProjectIcon(data: data, palette: palette),
              const SizedBox(width: 22),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _LandingTypography.contentTitle(
                        palette,
                      ).copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _LandingTypography.body(palette),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SponsorProjectIcon extends StatelessWidget {
  const _SponsorProjectIcon({required this.data, required this.palette});

  final _SponsorProjectData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    if (data.imageAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          data.imageAsset!,
          width: 82,
          height: 82,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: palette.textStrong,
        shape: BoxShape.circle,
      ),
      child: Icon(data.icon!, color: palette.surface, size: 42),
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  const _FooterCopyright({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Made by',
                style: _LandingTypography.link(
                  palette,
                ).copyWith(color: palette.textStrong),
              ),
              InkWell(
                onTap: () => _launchExternal(Uri.parse(_githubProfileUrl)),
                child: Text(
                  'Jason Chen',
                  style: _LandingTypography.linkStrong(palette),
                ),
              ),
              Text(
                '&',
                style: _LandingTypography.link(
                  palette,
                ).copyWith(color: palette.textStrong),
              ),
              InkWell(
                onTap: () => _launchExternal(Uri.parse(_easyUiRepoUrl)),
                child: Text(
                  'Easy UI',
                  style: _LandingTypography.linkStrong(palette),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Copyright © 2026 Easy UI',
            textAlign: TextAlign.center,
            style: _LandingTypography.link(
              palette,
            ).copyWith(color: palette.textStrong),
          ),
        ],
      ),
    );
  }
}

class _FooterDivider extends StatelessWidget {
  const _FooterDivider({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: palette.border);
  }
}

class _ConstrainedSection extends StatelessWidget {
  const _ConstrainedSection({
    required this.child,
    this.top = 0,
    this.bottom = 0,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 720 ? 22.0 : 40.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: EasyLandingPage._maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.palette,
  });

  final String eyebrow;
  final String title;
  final String description;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: _LandingTypography.sectionEyebrow(palette)),
        const SizedBox(height: 8),
        Text(
          title,
          style: _LandingTypography.sectionTitle(
            palette,
          ).copyWith(color: palette.textStrong),
        ),
        const SizedBox(height: 10),
        Text(description, style: _LandingTypography.body(palette)),
      ],
    );
  }
}

class _FeatureSupportPanel extends StatelessWidget {
  const _FeatureSupportPanel({required this.items, required this.palette});

  final List<_FeatureData> items;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BUILDING BLOCKS',
            style: _LandingTypography.sectionEyebrow(palette),
          ),
          const SizedBox(height: 8),
          Text(
            '三项交付能力',
            style: _LandingTypography.contentTitle(
              palette,
            ).copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            '从组件选择到源码落地，再到不同屏幕的响应式表现，右侧三项承担页面交付的工程闭环。',
            style: _LandingTypography.bodySmall(
              palette,
            ).copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              color: palette.previewBackground.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              children:
                  items.indexed.map((entry) {
                    final index = entry.$1;
                    final item = entry.$2;
                    return _FeatureSupportRow(
                      index: index,
                      data: item,
                      palette: palette,
                      showDivider: index != items.length - 1,
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          _FeatureSupportFooter(palette: palette),
        ],
      ),
    );
  }
}

class _FeatureSupportRow extends StatelessWidget {
  const _FeatureSupportRow({
    required this.index,
    required this.data,
    required this.palette,
    required this.showDivider,
  });

  final int index;
  final _FeatureData data;
  final _LandingPalette palette;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border:
            showDivider
                ? Border(bottom: BorderSide(color: palette.border))
                : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: data.color.withValues(alpha: 0.18)),
              ),
              child: Icon(
                data.icon,
                color: data.color,
                size: 23,
                opticalSize: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '0${index + 1}',
                    style: _LandingTypography.bodySmall(palette).copyWith(
                      color: data.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.title,
                    style: _LandingTypography.contentTitle(palette),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.description,
                    style: _LandingTypography.bodySmall(palette),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSupportFooter extends StatelessWidget {
  const _FeatureSupportFooter({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.textStrong.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.route_outlined, color: palette.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '从组件资产图谱进入，每个能力都能回到 example 中验证。',
                style: _LandingTypography.bodySmall(
                  palette,
                ).copyWith(color: palette.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillStep extends StatelessWidget {
  const _SkillStep({required this.data, required this.palette});

  final _SkillStepData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: data.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.index,
            style: _LandingTypography.bodySmall(
              palette,
            ).copyWith(color: data.color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          Text(
            data.label,
            style: _LandingTypography.bodySmall(
              palette,
            ).copyWith(color: palette.textStrong),
          ),
        ],
      ),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final categories = [
      const _CategoryData('基础组件', '头像、按钮、排版、图片、SVG、主题', '/overview'),
      const _CategoryData('数据展示', '表格、轮播图、空占位、流程图', '/table'),
      const _CategoryData('数据输入', '表单、选择器、日期时间、签名板', '/form'),
      const _CategoryData(
        '反馈与富文本',
        'Dialog、Toast、Popover、Rich Editor',
        '/toast',
      ),
    ];

    return _ViewportFadeIn(
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children:
              categories.indexed.map((entry) {
                final index = entry.$1;
                final data = entry.$2;
                return _CategoryRow(
                  data: data,
                  index: index,
                  palette: palette,
                  onNavigate: onNavigate,
                  showDivider: index != categories.length - 1,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.data,
    required this.index,
    required this.palette,
    required this.onNavigate,
    required this.showDivider,
  });

  final _CategoryData data;
  final int index;
  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = [palette.blue, palette.green, palette.amber, palette.red];
    return InkWell(
      onTap: () => onNavigate(data.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border:
              showDivider
                  ? Border(bottom: BorderSide(color: palette.border))
                  : null,
        ),
        child: Row(
          children: [
            Text(
              '0${index + 1}',
              style: _LandingTypography.contentTitle(
                palette,
              ).copyWith(color: colors[index]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: _LandingTypography.contentTitle(palette),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.description,
                    style: _LandingTypography.bodySmall(
                      palette,
                    ).copyWith(color: palette.textMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 18, color: palette.textSoft),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}

class _SkillStepData {
  const _SkillStepData(this.index, this.label, this.color);

  final String index;
  final String label;
  final Color color;
}

class _SponsorProjectData {
  const _SponsorProjectData({
    required this.name,
    required this.description,
    required this.url,
    this.icon,
    this.imageAsset,
  }) : assert(icon != null || imageAsset != null);

  final String name;
  final String description;
  final String url;
  final IconData? icon;
  final String? imageAsset;
}

class _CategoryData {
  const _CategoryData(this.title, this.description, this.route);

  final String title;
  final String description;
  final String route;
}

class _LandingPalette {
  const _LandingPalette({
    required this.background,
    required this.heroBackground,
    required this.surface,
    required this.footer,
    required this.previewBackground,
    required this.codeBackground,
    required this.textStrong,
    required this.textMuted,
    required this.textSoft,
    required this.codeText,
    required this.primary,
    required this.onPrimary,
    required this.border,
    required this.borderStrong,
    required this.shadow,
    required this.blue,
    required this.green,
    required this.amber,
    required this.red,
  });

  final Color background;
  final Color heroBackground;
  final Color surface;
  final Color footer;
  final Color previewBackground;
  final Color codeBackground;
  final Color textStrong;
  final Color textMuted;
  final Color textSoft;
  final Color codeText;
  final Color primary;
  final Color onPrimary;
  final Color border;
  final Color borderStrong;
  final Color shadow;
  final Color blue;
  final Color green;
  final Color amber;
  final Color red;

  static _LandingPalette resolve(bool isDark) {
    if (isDark) {
      return const _LandingPalette(
        background: Color(0xFF0F1916),
        heroBackground: Color(0xFF111E1A),
        surface: Color(0xFF172620),
        footer: Color(0xFF13211D),
        previewBackground: Color(0xFF10201B),
        codeBackground: Color(0xFF07120F),
        textStrong: Color(0xFFEAF6F1),
        textMuted: Color(0xFFADBCB6),
        textSoft: Color(0xFF7D9088),
        codeText: Color(0xFF9DE7CB),
        primary: Color(0xFF4EE0A5),
        onPrimary: Color(0xFF072016),
        border: Color(0xFF253A33),
        borderStrong: Color(0xFF416257),
        shadow: Color(0x66060B10),
        blue: Color(0xFF7AB7FF),
        green: Color(0xFF4EE0A5),
        amber: Color(0xFFE8B04E),
        red: Color(0xFFFF817A),
      );
    }
    return const _LandingPalette(
      background: Color(0xFFF3F8F5),
      heroBackground: Color(0xFFFAFCF8),
      surface: Color(0xFFFEFFFD),
      footer: Color(0xFFEEF5F1),
      previewBackground: Color(0xFFF0F7F3),
      codeBackground: Color(0xFF10231E),
      textStrong: Color(0xFF10231E),
      textMuted: Color(0xFF52665E),
      textSoft: Color(0xFF84968E),
      codeText: Color(0xFFBDF7DD),
      primary: Color(0xFF0B8F66),
      onPrimary: Color(0xFFF7FFFB),
      border: Color(0xFFD9E8DE),
      borderStrong: Color(0xFFAEC5B8),
      shadow: Color(0x1F10231E),
      blue: Color(0xFF2B77E5),
      green: Color(0xFF0B8F66),
      amber: Color(0xFFC78517),
      red: Color(0xFFD85C5C),
    );
  }
}
