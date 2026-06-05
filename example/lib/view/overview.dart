import 'package:easy_ui/easy_ui.dart';
import 'package:example/main.dart';
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

const _overviewAssetByRoute = <String, String>{
  'avatar': 'assets/overview/avatar.svg',
  'button': 'assets/overview/button.svg',
  'typography': 'assets/overview/typography.svg',
  'image': 'assets/overview/image.svg',
  'svg': 'assets/overview/svg.svg',
  'lottieIcon': 'assets/overview/lottieIcon.svg',
  'theme': 'assets/overview/theme.svg',
  'segments': 'assets/overview/segments.svg',
  'switch': 'assets/overview/switch.svg',
  'table': 'assets/overview/table.svg',
  'carousel': 'assets/overview/carousel.svg',
  'empty': 'assets/overview/empty.svg',
  'recordCard': 'assets/overview/recordCard.svg',
  'skeleton': 'assets/overview/skeleton.svg',
  'statusIndicator': 'assets/overview/statusIndicator.svg',
  'infoCard': 'assets/overview/infoCard.svg',
  'flow': 'assets/overview/flow.svg',
  'select': 'assets/overview/select.svg',
  'dropdownTextfield3': 'assets/overview/dropdowntextfield3.svg',
  'form': 'assets/overview/form.svg',
  'i18nFormFiled': 'assets/overview/i18nFormFiled.svg',
  'timePicker': 'assets/overview/timePicker.svg',
  'datePicker': 'assets/overview/datePicker.svg',
  'easySignaturePadDemo': 'assets/overview/easySignaturePadDemo.svg',
  'slider': 'assets/overview/slider.svg',
  'onscreenKeyboard': 'assets/overview/onscreenKeyboard.svg',
  'dialog': 'assets/overview/dialog.svg',
  'popover': 'assets/overview/popover.svg',
  'drawer': 'assets/overview/drawer.svg',
  'toast': 'assets/overview/toast.svg',
  'localNotification': 'assets/overview/localNotification.svg',
  'stepper': 'assets/overview/stepper.svg',
  'tabs': 'assets/overview/tabs.svg',
  'scrollSectionsLayout': 'assets/overview/scrollSectionsLayout.svg',
  'fileDragArea': 'assets/overview/fileDragArea.svg',
  'markdownViewer': 'assets/overview/markdownViewer.svg',
  'pdfViewer': 'assets/overview/pdfViewer.svg',
  'richEditor': 'assets/overview/richEditor.svg',
  'linearProgress': 'assets/overview/linearProgress.svg',
  'marqueeGradient': 'assets/overview/marqueeGradient.svg',
  'longPressCopyable': 'assets/overview/longPressCopyable.svg',
  'colorPicker': 'assets/overview/colorPicker.svg',
  'easyPagination': 'assets/overview/easyPagination.svg',
};

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = treeItems.where((node) => node.title != '组件总览').toList();
    final theme = EasyTheme.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      body: ListView.separated(
        padding: const EdgeInsets.all(40.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategorySection(context, category);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 48);
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, TreeNode category) {
    if (category.children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Row(
          spacing: 12,
          children: [
            Text(
              category.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: EasyTheme.of(context).neutralEE),
                borderRadius: BorderRadius.all(
                  EasyTheme.of(context).cornerSmall,
                ),
              ),
              child: Text(
                '${category.children.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: EasyTheme.of(context).neutral66,
                ),
              ),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children:
                  category.children.map((node) {
                    return _buildComponentCard(context, node);
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildComponentCard(BuildContext context, TreeNode node) {
    final routeName = node.routeName ?? node.children.firstOrNull?.routeName;
    final routeKey = routeName?.replaceAll('/', '');
    final assetPath = routeKey == null ? null : _overviewAssetByRoute[routeKey];

    Widget buildPlaceholder() {
      return Icon(
        Icons.widgets,
        size: 48,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      );
    }

    final easyTheme = EasyTheme.of(context);

    return SizedBox(
      width: 240,
      height: 160,
      child: EasyButton2(
        type: EasyButtonType.text,
        style: EasyButtonStyle.styleFrom(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          fixedSize: const Size(240, 160),
          backgroundColor: easyTheme.cardBackground,
          foregroundColor: easyTheme.onCardBackground,
          overlayColor: easyTheme.secondaryBlue,
          side: BorderSide(color: easyTheme.neutralEE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(easyTheme.cornerSmall),
          ),
        ),
        onPressed: () {
          if (node.routeName != null) {
            navigateToRoute(node.routeName!);
          } else if (node.hasChildren && node.children.isNotEmpty) {
            if (node.children.first.routeName != null) {
              navigateToRoute(node.children.first.routeName!);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                node.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child:
                      assetPath != null
                          ? FutureBuilder(
                            future: DefaultAssetBundle.of(
                              context,
                            ).load(assetPath),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  !snapshot.hasError &&
                                  snapshot.data != null) {
                                return EasySvgIcon.memory(
                                  snapshot.data!.buffer.asUint8List(),
                                  fit: BoxFit.contain,
                                  inheritIconThemeColor: false,
                                );
                              }
                              return buildPlaceholder();
                            },
                          )
                          : buildPlaceholder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
