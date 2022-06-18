import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:notus_format/notus_format.dart';

import 'editor.dart';

mixin RawEditorStateSelectionDelegateMixin on EditorState
    implements TextSelectionDelegate {
  @override
  TextEditingValue get textEditingValue {
    // TODO: --------------------------------------- 暂时是list中的下标为0的元素
    return widget.controller[0].plainTextEditingValue;
  }

  @override
  set textEditingValue(TextEditingValue value) {
    if (value.text == textEditingValue.text) {
      // TODO: --------------------------------------- 暂时是list中的下标为0的元素
      widget.controller[0]
          .updateSelection(value.selection, source: ChangeSource.local);
    } else {
      _setEditingValue(value);
    }
  }

  void _setEditingValue(TextEditingValue value) async {
    if (await _isItCut(value)) {
      // TODO: --------------------------------------- 暂时是list中的下标为0的元素
      widget.controller[0].replaceText(
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
        // TODO: --------------------------------------- 暂时是list中的下标为0的元素
        widget.controller[0].replaceText(
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
