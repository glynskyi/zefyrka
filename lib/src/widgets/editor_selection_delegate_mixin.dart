import 'package:flutter/services.dart';
import 'package:zefyrka/notus_format/src/document.dart';

import 'editor.dart';

mixin RawEditorStateSelectionDelegateMixin on EditorState
    implements TextSelectionDelegate {
  @override
  TextEditingValue get textEditingValue {
    return widget.controller.plainTextEditingValue;
  }

  @override
  set textEditingValue(TextEditingValue value) {
    if (value.text == textEditingValue.text) {
      widget.controller
          .updateSelection(value.selection, source: ChangeSource.local);
    } else {
      _setEditingValue(value);
    }
  }

  void _setEditingValue(TextEditingValue value) async {
    if (await _isItCut(value)) {
      widget.controller.replaceText(
        textEditingValue.selection.start,
        textEditingValue.text.length - value.text.length,
        '',
        selection: value.selection,
      );
    } else {
      final value = textEditingValue;
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null) {
        final length =
            textEditingValue.selection.end - textEditingValue.selection.start;
        widget.controller.replaceText(
          value.selection.start,
          length,
          data.text,
          selection: value.selection,
        );
      }
    }
  }

  Future<bool> _isItCut(TextEditingValue value) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);

    return textEditingValue.text.length - value.text.length ==
        data?.text?.length;
  }

  @override
  void bringIntoView(TextPosition position) {
    // TODO: implement bringIntoView
  }

  @override
  void hideToolbar([bool? hideHandles = true]) {
    if (selectionOverlay?.toolbarIsVisible == true) {
      selectionOverlay?.hideToolbar();
    }
  }

  @override
  bool get cutEnabled => widget.toolbarOptions.cut && !widget.readOnly;

  @override
  bool get copyEnabled => widget.toolbarOptions.copy;

  @override
  bool get pasteEnabled => widget.toolbarOptions.paste && !widget.readOnly;

  @override
  bool get selectAllEnabled => widget.toolbarOptions.selectAll;
}
