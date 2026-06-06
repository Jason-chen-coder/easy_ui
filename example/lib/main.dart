import 'package:easy_ui/easy_ui.dart';
import 'package:example/view/easy_file_drag_area_demo.dart';
import 'package:example/view/easy_signature_pad_example.dart';
import 'package:example/view/button/easy_button_example.dart';
import 'package:example/view/data_entry/onscreen_keyboard.dart';
import 'package:example/view/other/easy_radial_progress_indicator_demo.dart';
import 'package:example/view/pagination/easy_pagination_example.dart';
import 'package:example/view/base/easy_lottie_icon.dart';
import 'package:example/view/base/avatar.dart';
import 'package:example/view/base/image.dart';
import 'package:example/view/base/segments.dart';
import 'package:example/view/base/switch.dart';
import 'package:example/view/base/svg_icon.dart';
import 'package:example/view/navigation/step_indicator.dart';
import 'package:example/view/other/long_press_copyable.dart';
import 'package:example/view/base/theme.dart';
import 'package:example/view/base/typography_paragraph.dart';
import 'package:example/view/data_display/carousel_demo.dart';
import 'package:example/view/data_display/data_table.dart';
import 'package:example/view/data_display/empty_view.dart';
import 'package:example/view/data_display/flow.dart';
import 'package:example/view/data_display/info_card.dart';
import 'package:example/view/data_display/record_card.dart';
import 'package:example/view/data_display/skeleton.dart';
import 'package:example/view/data_display/status_indicator.dart';
import 'package:example/view/data_entry/drop_down/drop_down1.dart';
import 'package:example/view/data_entry/drop_down/drop_down2.dart';
import 'package:example/view/data_entry/drop_down/pagination_select.dart';
import 'package:example/view/data_entry/drop_down/select.dart';
import 'package:example/view/data_entry/form.dart';
import 'package:example/view/data_entry/i18n_form_filed_demo.dart';
import 'package:example/view/data_entry/mode_date_picker.dart';
import 'package:example/view/data_entry/time_picker.dart';
import 'package:example/view/data_entry/tool_tip.dart';
import 'package:example/view/feedback/dialog.dart';
import 'package:example/view/feedback/drawer.dart';
import 'package:example/view/feedback/local_notification.dart';
import 'package:example/view/feedback/popover.dart';
import 'package:example/view/feedback/toast.dart';
import 'package:example/view/h5/h5_proxy_demo.dart';
import 'package:example/view/home/easy_landing_page.dart';
import 'package:example/view/layout/easy_scroll_sections_layout.dart';
import 'package:example/view/navigation/easy_stepper.dart';
import 'package:example/view/navigation/tabs.dart';
import 'package:example/view/other/easy_color_picker_demo.dart';
import 'package:example/view/other/easy_markdown_demo.dart';
import 'package:example/view/other/easy_pdf_viewer_demo.dart';
import 'package:example/view/other/easy_rich_editor_demo.dart';
import 'package:example/view/other/linear_progress_indicator.dart';
import 'package:example/view/other/marquee_gradient_bar.dart';
import 'package:example/view/data_entry/slider_demo.dart';
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

import 'view/overview.dart';

part 'menu.dart';

// 全局导航服务类
class NavigationService {
  static NavigationService? _instance;

  static NavigationService get instance => _instance ??= NavigationService._();

  NavigationService._();

  Function(String)? _navigateToRoute;

  // 注册导航回调
  void registerNavigationCallback(Function(String) callback) {
    _navigateToRoute = callback;
  }

  // 全局切换tab方法
  void navigateToRoute(String routeName) {
    _navigateToRoute?.call(routeName);
  }
}

// 全局快捷方法
void navigateToRoute(String routeName) {
  NavigationService.instance.navigateToRoute(routeName);
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale _locale = const Locale('zh');
  bool _showWorkspace = false;
  String _workspaceInitialRoute = '/overview';

  void _onLocaleChanged(Locale locale) {
    if (_locale == locale) return;
    setState(() {
      _locale = locale;
    });
  }

  ThemeMode _themeMode = ThemeMode.system;
  void _onThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _openWorkspace(String routeName) {
    setState(() {
      _workspaceInitialRoute = routeName;
      _showWorkspace = true;
    });
  }

  void _openLanding() {
    setState(() {
      _showWorkspace = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyToastWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: easyBuildMaterialTheme(brightness: Brightness.light),
        darkTheme: easyBuildMaterialTheme(brightness: Brightness.dark),
        themeMode: _themeMode,
        home:
            _showWorkspace
                ? HomePage(
                  key: ValueKey(_workspaceInitialRoute),
                  initialRoute: _workspaceInitialRoute,
                  currentLocale: _locale,
                  currentThemeMode: _themeMode,
                  onLocaleChanged: _onLocaleChanged,
                  onThemeModeChanged: _onThemeModeChanged,
                  onOpenLanding: _openLanding,
                )
                : EasyLandingPage(onNavigate: _openWorkspace),
        locale: _locale,
        supportedLocales: EasyUiLocalizations.supportedLocales,
        localizationsDelegates: EasyUiLocalizations.localizationsDelegates,
        builder: EasyOnscreenKeyboard.builder(
          width: (context) => MediaQuery.sizeOf(context).width / 2,
          builder: (context, child) {
            return EasyTheme(
              data: EasyThemeData(brightness: Theme.of(context).brightness),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.initialRoute,
    required this.currentLocale,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    this.onOpenLanding,
  });

  final String initialRoute;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback? onOpenLanding;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _searchController = TextEditingController();

  String? _selectedRoute;
  List<TreeNode> _filteredTreeItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredTreeItems = treeItems;
    _searchController.addListener(_onSearchChanged);

    _selectedRoute = _resolveInitialRoute();

    // 注册全局导航回调
    NavigationService.instance.registerNavigationCallback(
      _navigateToRouteInternal,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 搜索变化时的回调
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredTreeItems = treeItems;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredTreeItems = _filterTreeItems(treeItems, query);
    });
  }

  // 递归过滤树节点
  List<TreeNode> _filterTreeItems(List<TreeNode> nodes, String query) {
    final List<TreeNode> result = [];

    for (final node in nodes) {
      // 检查当前节点是否匹配
      final bool matches = node.title.toLowerCase().contains(query);

      // 递归检查子节点
      final List<TreeNode> filteredChildren =
          node.hasChildren ? _filterTreeItems(node.children, query) : [];

      // 如果当前节点或子节点匹配，则保留该节点
      if (matches || filteredChildren.isNotEmpty) {
        result.add(
          TreeNode(
            title: node.title,
            routeName: node.routeName,
            builder: node.builder,
            children: filteredChildren,
            isExpanded: true, // 搜索时展开所有匹配的节点
          ),
        );
      }
    }

    return result;
  }

  // 内部导航方法
  void _navigateToRouteInternal(String routeName) {
    final node = _findNodeByRoute(routeName);
    if (node != null && node.builder != null) {
      _navigatorKey.currentState?.pushReplacementNamed(routeName);
      setState(() => _selectedRoute = routeName);
    }
  }

  // 递归构建扁平化的列表用于显示
  List<({TreeNode node, int level})> _buildFlatList() {
    List<({TreeNode node, int level})> flatList = [];

    void buildRecursive(List<TreeNode> nodes, int level) {
      for (final node in nodes) {
        flatList.add((node: node, level: level));
        if (node.isExpanded && node.hasChildren) {
          buildRecursive(node.children, level + 1);
        }
      }
    }

    buildRecursive(_filteredTreeItems, 0);
    return flatList;
  }

  String? _resolveInitialRoute() {
    final initialNode = _findNodeByRoute(widget.initialRoute);
    if (initialNode?.builder != null) return widget.initialRoute;
    return _findFirstLeafNode()?.routeName;
  }

  // 查找第一个叶子节点作为初始路由
  TreeNode? _findFirstLeafNode() {
    TreeNode? findRecursive(List<TreeNode> nodes) {
      for (final node in nodes) {
        if (node.isLeaf) {
          return node;
        } else if (node.hasChildren) {
          final result = findRecursive(node.children);
          if (result != null) return result;
        }
      }
      return null;
    }

    return findRecursive(treeItems);
  }

  // 根据路由名称查找节点
  TreeNode? _findNodeByRoute(String routeName) {
    TreeNode? findRecursive(List<TreeNode> nodes) {
      for (final node in nodes) {
        if (node.routeName == routeName) {
          return node;
        } else if (node.hasChildren) {
          final result = findRecursive(node.children);
          if (result != null) return result;
        }
      }
      return null;
    }

    return findRecursive(treeItems);
  }

  void _onNodeTap(TreeNode node) {
    if (node.hasChildren) {
      setState(() => node.isExpanded = !node.isExpanded);
    } else if (node.routeName != null && node.builder != null) {
      _navigatorKey.currentState?.pushReplacementNamed(node.routeName!);
      setState(() => _selectedRoute = node.routeName);
    }
  }

  Future<void> _showLocaleDropdown(BuildContext context) async {
    final current = widget.currentLocale;
    final easyTheme = EasyTheme.of(context);

    await showEasyDropdown<Locale>(
      context: context,
      width: 148,
      backgroundColor: easyTheme.background,
      itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      items: [
        _dropdownItem(
          value: const Locale('zh'),
          label: '中文',
          selected: current.languageCode == 'zh',
        ),
        _dropdownItem(
          value: const Locale('en'),
          label: 'English',
          selected: current.languageCode == 'en',
        ),
      ],
      onSelected: widget.onLocaleChanged,
    );
  }

  Future<void> _showThemeModeDropdown(BuildContext context) async {
    final current = widget.currentThemeMode;
    final easyTheme = EasyTheme.of(context);

    await showEasyDropdown<ThemeMode>(
      context: context,
      width: 150,
      backgroundColor: easyTheme.background,
      itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      items: [
        _dropdownItem(
          value: ThemeMode.system,
          label: '跟随系统',
          selected: current == ThemeMode.system,
        ),
        _dropdownItem(
          value: ThemeMode.light,
          label: '亮色',
          selected: current == ThemeMode.light,
        ),
        _dropdownItem(
          value: ThemeMode.dark,
          label: '暗色',
          selected: current == ThemeMode.dark,
        ),
      ],
      onSelected: widget.onThemeModeChanged,
    );
  }

  EasyDropdownIconItem<T> _dropdownItem<T>({
    required T value,
    required String label,
    required bool selected,
  }) {
    final easyTheme = EasyTheme.of(context);

    return EasyDropdownIconItem<T>(
      value: value,
      icon:
          selected
              ? Icon(Icons.check, size: 16, color: easyTheme.secondaryBlue)
              : const SizedBox(width: 16, height: 16),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: selected ? easyTheme.secondaryBlue : easyTheme.neutral66,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildLocaleSwitcher(ThemeData theme) {
    final current = widget.currentLocale;
    final String label = current.languageCode == 'zh' ? '中文' : 'English';
    return _ShellDropdownButton(
      tooltip: 'Language',
      icon: Icons.translate,
      label: label,
      onPressed: _showLocaleDropdown,
    );
  }

  Widget _buildThemeModeSwitcher(ThemeData theme) {
    final current = widget.currentThemeMode;
    final String label = switch (current) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '亮色',
      ThemeMode.dark => '暗色',
    };

    return _ShellDropdownButton(
      tooltip: 'Theme Mode',
      icon: Icons.brightness_6,
      label: label,
      onPressed: _showThemeModeDropdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flatList = _buildFlatList();
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          _buildSideBar(theme, flatList),
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              initialRoute: _selectedRoute ?? '/placeholder',
              onGenerateInitialRoutes: (navigatorState, initialRoute) {
                final node = _findNodeByRoute(initialRoute);
                if (node == null || node.builder == null) {
                  return [
                    MaterialPageRoute(
                      builder:
                          (context) => const EasyEmptyView(
                            title: '页面不存在',
                            text: '没有找到对应的组件示例',
                          ),
                    ),
                  ];
                } else {
                  _selectedRoute = initialRoute;
                  return [MaterialPageRoute(builder: node.builder!)];
                }
              },
              onGenerateRoute: (settings) {
                final node = _findNodeByRoute(settings.name ?? '');
                if (node == null || node.builder == null) {
                  return MaterialPageRoute(
                    builder:
                        (context) => const EasyEmptyView(
                          title: '页面不存在',
                          text: '没有找到对应的组件示例',
                        ),
                  );
                } else {
                  return MaterialPageRoute(builder: node.builder!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildSideBar(
    ThemeData theme,
    List<({int level, TreeNode node})> list,
  ) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: EasyTextFormField(
              controller: _searchController,
              decorationLayoutDelegate: null,
              placeholder: '搜索组件...',
              height: 40,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: EasyTheme.of(context).neutral99,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Easy UI 组件库',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.onOpenLanding != null)
                      _ShellIconButton(
                        tooltip: '返回首页',
                        icon: Icons.home_outlined,
                        onPressed: widget.onOpenLanding,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildLocaleSwitcher(theme),
                    const SizedBox(width: 8),
                    _buildThemeModeSwitcher(theme),
                  ],
                ),
              ],
            ),
          ),
          if (_isSearching && _filteredTreeItems.isEmpty)
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: EasyEmptyView(text: '没有找到匹配的组件'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = list[index];
                  final node = item.node;
                  final level = item.level;
                  final selected = _selectedRoute == node.routeName;

                  return _SideBarTreeItem(
                    key: ValueKey(node.routeName ?? node.title),
                    title: node.title,
                    level: level,
                    selected: selected,
                    expanded: node.isExpanded,
                    hasChildren: node.hasChildren,
                    onPressed: () => _onNodeTap(node),
                  );
                },
                itemCount: list.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShellDropdownButton extends StatelessWidget {
  const _ShellDropdownButton({
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final String label;
  final ValueChanged<BuildContext> onPressed;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return Builder(
      builder: (buttonContext) {
        return EasyButton2(
          tooltip: tooltip,
          type: EasyButtonType.outline,
          size: EasyButtonSize.small,
          style: EasyButtonStyle.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            minimumSize: Size.zero,
            backgroundColor: easyTheme.background,
            foregroundColor: easyTheme.neutral66,
            side: BorderSide(color: easyTheme.neutralEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(easyTheme.cornerSmall),
            ),
          ),
          onPressed: () => onPressed(buttonContext),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        );
      },
    );
  }
}

class _ShellIconButton extends StatelessWidget {
  const _ShellIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return EasyButton2(
      tooltip: tooltip,
      type: EasyButtonType.iconDefault,
      size: EasyButtonSize.small,
      style: EasyButtonStyle.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        fixedSize: const Size.square(32),
        foregroundColor: easyTheme.neutral66,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 18),
    );
  }
}

class _SideBarTreeItem extends StatelessWidget {
  const _SideBarTreeItem({
    super.key,
    required this.title,
    required this.level,
    required this.selected,
    required this.expanded,
    required this.hasChildren,
    required this.onPressed,
  });

  final String title;
  final int level;
  final bool selected;
  final bool expanded;
  final bool hasChildren;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final Color foregroundColor =
        selected
            ? easyTheme.secondaryBlue
            : hasChildren
            ? easyTheme.neutral33
            : easyTheme.neutral66;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      child: SizedBox(
        width: double.infinity,
        height: 34,
        child: EasyButton2(
          type: EasyButtonType.text,
          style: EasyButtonStyle.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 8.0 + (level * 16.0), right: 8.0),
            minimumSize: Size.zero,
            backgroundColor:
                selected
                    ? easyTheme.secondaryBlue.withValues(alpha: 0.1)
                    : Colors.transparent,
            foregroundColor: foregroundColor,
            overlayColor: easyTheme.secondaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(easyTheme.cornerSmall),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              SizedBox(
                width: 16,
                child:
                    hasChildren
                        ? Icon(
                          expanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          size: 16,
                          color: easyTheme.neutral99,
                        )
                        : Icon(
                          Icons.circle,
                          size: 6,
                          color: easyTheme.neutral99.withValues(alpha: 0.6),
                        ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: hasChildren ? FontWeight.w600 : FontWeight.w400,
                    fontSize: hasChildren ? 14 : 13,
                    color: foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
