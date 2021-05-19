import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zefyrka/zefyrka.dart';

import '../testing.dart';

void main() {
  group('$RawEditor', () {
    // TODO restore test
    // testWidgets('allows merging attribute theme data', (tester) async {
    //   var delta = Delta()
    //     ..insert(
    //       'Website',
    //       NotusAttribute.link.fromString('https://github.com').toJson(),
    //     )
    //     ..insert('\n');
    //   var doc = NotusDocument.fromDelta(delta);
    //   var theme = ZefyrThemeData(link: TextStyle(color: Colors.red));
    //   var editor = EditorSandBox(tester: tester, document: doc, theme: theme);
    //   await editor.pumpAndTap();
    //   // await tester.pumpAndSettle();
    //   final p = tester.widget(find.byType(RichText).first) as RichText;
    //   final text = p.text as TextSpan;
    //   expect(text.children!.first.style!.color, Colors.red);
    // });

    testWidgets('collapses selection when unfocused', (tester) async {
      final editor = EditorSandBox(tester: tester);
      await editor.pumpAndTap();
      await editor.updateSelection(base: 0, extent: 3);
      // expect(editor.findSelectionHandle(), findsNWidgets(2));
      await editor.tapHideKeyboardButton();
      // expect(editor.findSelectionHandle(), findsNothing);
      expect(editor.selection, TextSelection.collapsed(offset: 3));
    });

    testWidgets('toggle enabled state', (tester) async {
      final editor = EditorSandBox(tester: tester);
      await editor.pumpAndTap();
      await editor.updateSelection(base: 0, extent: 3);
      await editor.disable();
      final widget = tester.widget(find.byType(ZefyrField)) as ZefyrField;
      expect(widget.readOnly, true);
    });
  });
}
