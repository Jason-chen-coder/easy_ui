import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_ui/easy_ui.dart';

void main() {
  test('exports Easy UI localization metadata', () {
    expect(EasyUiLocalizations.supportedLocales, isNotEmpty);
  });

  testWidgets('EasySvgIcon can preserve original svg colors', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: IconTheme(
          data: const IconThemeData(color: Color(0xff111111)),
          child: EasySvgIcon.string(
            '<svg width="8" height="8" viewBox="0 0 8 8"><rect width="8" height="8" fill="#ff0000"/></svg>',
            inheritIconThemeColor: false,
          ),
        ),
      ),
    );

    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(picture.colorFilter, isNull);
  });
}
