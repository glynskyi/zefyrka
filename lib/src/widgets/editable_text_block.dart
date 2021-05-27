import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notus_format/notus_format.dart';
import 'package:zefyrka/zefyrka.dart';

import '../rendering/editable_text_block.dart';
import 'cursor.dart';
import 'editable_text_line.dart';
import 'editor.dart';
import 'text_line.dart';
import 'theme.dart';

typedef CheckboxListener = void Function(int documentOffset, bool checked);

class EditableTextBlock extends StatelessWidget {
  final BlockNode node;
  final TextDirection textDirection;
  final VerticalSpacing spacing;
  final CursorController? cursorController;
  final TextSelection selection;
  final Color selectionColor;
  final bool enableInteractiveSelection;
  final bool hasFocus;
  final EdgeInsets? contentPadding;
  final ZefyrEmbedBuilder embedBuilder;
  final CheckboxListener checkboxListener;

  EditableTextBlock({
    Key? key,
    required this.node,
    required this.textDirection,
    required this.spacing,
    required this.cursorController,
    required this.selection,
    required this.selectionColor,
    required this.enableInteractiveSelection,
    required this.hasFocus,
    this.contentPadding,
    required this.embedBuilder,
    required this.checkboxListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final theme = ZefyrTheme.of(context);
    return _EditableBlock(
      node: node,
      textDirection: textDirection,
      padding: spacing,
      contentPadding: contentPadding,
      decoration: _getDecorationForBlock(node, theme) ?? BoxDecoration(),
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    final count = node.children.length;
    final children = <Widget>[];
    var index = 0;
    for (final line in node.children) {
      index++;
      children.add(EditableTextLine(
        node: line as LineNode,
        textDirection: textDirection,
        spacing: _getSpacingForLine(line, index, count, theme),
        leading: _buildLeading(context, line, index, count),
        indentWidth: _getIndentWidth(line),
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
        body: TextLine(
          node: line,
          textDirection: textDirection,
          embedBuilder: embedBuilder,
          textAlign: _buildParagraphAlignment(line),
        ),
        cursorController: cursorController!,
        selection: selection,
        selectionColor: selectionColor,
        enableInteractiveSelection: enableInteractiveSelection,
        hasFocus: hasFocus,
      ));
    }
    return children.toList(growable: false);
  }

  TextAlign _buildParagraphAlignment(LineNode node) {
    final alignment =
        node.style.get(NotusAttribute.alignment as NotusAttributeKey<String>);
    if (alignment == NotusAttribute.alignment.end) {
      return TextAlign.end;
    } else if (alignment == NotusAttribute.alignment.justify) {
      return TextAlign.justify;
    } else if (alignment == NotusAttribute.alignment.center) {
      return TextAlign.center;
    } else {
      return TextAlign.start;
    }
  }

  Widget? _buildLeading(
      BuildContext context, LineNode node, int index, int count) {
    final theme = ZefyrTheme.of(context);
    final block =
        node.style.get(NotusAttribute.block as NotusAttributeKey<String>);
    if (block == NotusAttribute.block.numberList) {
      return _NumberPoint(
        index: index,
        count: count,
        style: theme!.paragraph.style,
        width: 32.0,
        padding: 8.0,
      );
    } else if (block == NotusAttribute.block.bulletList) {
      return _BulletPoint(
        style: theme!.paragraph.style.copyWith(fontWeight: FontWeight.bold),
        width: 32,
      );
    } else if (block == NotusAttribute.block.checkList) {
      return _CheckboxPoint(
        style: theme!.paragraph.style.copyWith(fontWeight: FontWeight.bold),
        width: 32,
        checked: node.style.containsSame(NotusAttribute.checked),
        onChecked: (value) => checkboxListener(node.documentOffset, value),
      );
    } else if (block == NotusAttribute.block.code) {
      return _NumberPoint(
        index: index,
        count: count,
        style: theme!.code.style
            .copyWith(color: theme.code.style.color!.withOpacity(0.4)),
        width: 32.0,
        padding: 16.0,
        withDot: false,
      );
    } else {
      return null;
    }
  }

  double _getIndentWidth(LineNode line) {
    int additionalIndent = 0;
    final indent =
        line.style.get(NotusAttribute.indent as NotusAttributeKey<int>);
    if (indent != null) {
      additionalIndent = indent.value!;
    }
    final block =
        node.style.get(NotusAttribute.block as NotusAttributeKey<String>);
    if (block == NotusAttribute.block.quote) {
      return 16.0 + additionalIndent;
    } else if (block == NotusAttribute.block.code) {
      return 32.0 + additionalIndent;
    } else {
      return 32.0 + additionalIndent;
    }
  }

  VerticalSpacing _getSpacingForLine(
      LineNode node, int index, int count, ZefyrThemeData? theme) {
    final heading =
        node.style.get(NotusAttribute.heading as NotusAttributeKey<int>);

    double? top = 0.0;
    double? bottom = 0.0;

    if (heading == NotusAttribute.heading.level1) {
      top = theme!.heading1.spacing.top;
      bottom = theme.heading1.spacing.bottom;
    } else if (heading == NotusAttribute.heading.level2) {
      top = theme!.heading2.spacing.top;
      bottom = theme.heading2.spacing.bottom;
    } else if (heading == NotusAttribute.heading.level3) {
      top = theme!.heading3.spacing.top;
      bottom = theme.heading3.spacing.bottom;
    } else {
      final block = this
          .node
          .style
          .get(NotusAttribute.block as NotusAttributeKey<String>);
      late var lineSpacing;
      if (block == NotusAttribute.block.quote) {
        lineSpacing = theme!.quote.lineSpacing;
      } else if (block == NotusAttribute.block.numberList ||
          block == NotusAttribute.block.bulletList ||
          block == NotusAttribute.block.checkList) {
        lineSpacing = theme!.lists.lineSpacing;
      } else if (block == NotusAttribute.block.code ||
          block == NotusAttribute.block.code) {
        lineSpacing = theme!.lists.lineSpacing;
      }
      top = lineSpacing.top;
      bottom = lineSpacing.bottom;
    }

    // If this line is the top one in this block we ignore its top spacing
    // because the block itself already has it. Similarly with the last line
    // and its bottom spacing.
    if (index == 1) {
      top = 0.0;
    }

    if (index == count) {
      bottom = 0.0;
    }

    return VerticalSpacing(top: top, bottom: bottom);
  }

  BoxDecoration? _getDecorationForBlock(BlockNode node, ZefyrThemeData? theme) {
    final style =
        node.style.get(NotusAttribute.block as NotusAttributeKey<String>);
    if (style == NotusAttribute.block.quote) {
      return theme!.quote.decoration;
    } else if (style == NotusAttribute.block.code) {
      return theme!.code.decoration;
    }
    return null;
  }
}

class _EditableBlock extends MultiChildRenderObjectWidget {
  final BlockNode node;
  final TextDirection textDirection;
  final VerticalSpacing padding;
  final Decoration decoration;
  final EdgeInsets? contentPadding;

  _EditableBlock({
    Key? key,
    required this.node,
    required this.textDirection,
    this.padding = const VerticalSpacing(),
    this.contentPadding,
    required this.decoration,
    required List<Widget> children,
  }) : super(key: key, children: children);

  EdgeInsets get _padding =>
      EdgeInsets.only(top: padding.top!, bottom: padding.bottom!);

  EdgeInsets get _contentPadding => contentPadding ?? EdgeInsets.zero;

  @override
  RenderEditableTextBlock createRenderObject(BuildContext context) {
    return RenderEditableTextBlock(
      node: node,
      textDirection: textDirection,
      padding: _padding,
      decoration: decoration,
      contentPadding: _contentPadding,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderEditableTextBlock renderObject) {
    renderObject.node = node;
    renderObject.textDirection = textDirection;
    renderObject.padding = _padding;
    renderObject.decoration = decoration;
    renderObject.contentPadding = _contentPadding;
  }
}

class _NumberPoint extends StatelessWidget {
  final int index;
  final int count;
  final TextStyle style;
  final double width;
  final bool withDot;
  final double padding;

  const _NumberPoint({
    Key? key,
    required this.index,
    required this.count,
    required this.style,
    required this.width,
    this.withDot = true,
    this.padding = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: Text(withDot ? '$index.' : '$index', style: style),
      width: width,
      padding: EdgeInsetsDirectional.only(end: padding),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final TextStyle style;
  final double width;

  const _BulletPoint({
    Key? key,
    required this.style,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: Text('•', style: style),
      width: width,
      padding: EdgeInsetsDirectional.only(end: 13.0),
    );
  }
}

class _CheckboxPoint extends StatelessWidget {
  final TextStyle style;
  final double width;
  final bool checked;
  final ValueChanged<bool> onChecked;

  const _CheckboxPoint({
    Key? key,
    required this.style,
    required this.width,
    required this.checked,
    required this.onChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (e) {
            onChecked(!checked);
          },
          child: CustomPaint(
            painter: _CheckboxPainter(checked),
            size: Size(18, 18),
          ),
        ),
      ),
      width: width,
      padding: EdgeInsetsDirectional.only(end: 13.0, top: 2),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  static final _paint = Paint()
    ..color = Color(0xFF2A3038)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  final bool _checked;

  _CheckboxPainter(this._checked);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect =
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(3));
    canvas.drawRRect(rrect, _paint);
    if (_checked == true) {
      final padding = _paint.strokeWidth * 2;
      final p1 = Offset(padding, size.height * 0.5);
      final p2 = Offset(size.width * 0.4, size.height - padding);
      final p3 = Offset(size.width - padding, padding);
      canvas.drawLine(p1, p2, _paint);
      canvas.drawLine(p2, p3, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
