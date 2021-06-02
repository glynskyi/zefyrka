import 'package:flutter/services.dart';
import 'package:zefyrka/src/services/clipboard_controller.dart';
import 'package:zefyrka/src/widgets/controller.dart';

class SimpleClipboardController implements ClipboardController {
  @override
  void copy(ZefyrController controller, String plainText) async {
    if (!controller.selection.isCollapsed) {
      // ignore: unawaited_futures
      Clipboard.setData(
          ClipboardData(text: controller.selection.textInside(plainText)));
    }
  }

  @override
  TextEditingValue? cut(ZefyrController controller, String plainText) {
    if (!controller.selection.isCollapsed) {
      final data = controller.selection.textInside(plainText);
      // ignore: unawaited_futures
      Clipboard.setData(ClipboardData(text: data));

      controller.replaceText(
        controller.selection.start,
        data.length,
        '',
        selection: TextSelection.collapsed(offset: controller.selection.start),
      );

      return TextEditingValue(
        text: controller.selection.textBefore(plainText) +
            controller.selection.textAfter(plainText),
        selection: TextSelection.collapsed(offset: controller.selection.start),
      );
    }
  }

  @override
  Future<void> paste(
      ZefyrController controller, TextEditingValue textEditingValue) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      final length = controller.selection.end - controller.selection.start;
      controller.replaceText(
        controller.selection.start,
        length,
        data.text,
        selection: TextSelection.collapsed(
            offset: controller.selection.start + data.text!.length),
      );
    }
  }
}
