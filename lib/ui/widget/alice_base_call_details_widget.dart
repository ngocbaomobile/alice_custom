import 'dart:convert';

import 'package:alice_lightweight/helper/alice_conversion_helper.dart';
import 'package:alice_lightweight/utils/alice_copy_hook.dart';
import 'package:alice_lightweight/utils/alice_parser.dart';
import 'package:flutter/material.dart';

abstract class AliceBaseCallDetailsWidgetState<T extends StatefulWidget>
    extends State<T> {
  final JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  Widget getListRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(padding: EdgeInsets.only(left: 5)),
        Flexible(
          fit: FlexFit.loose,
          // SelectableText, not a screen-wide SelectionArea: dragging a
          // SelectionArea across a lazily built, scrolling ListView threw
          // "Null check operator used on a null value". Each value is its own
          // selection scope, so long-press + drag copies one field safely.
          child: SelectableText(
            value,
            maxLines: null,
            contextMenuBuilder: _contextMenuWithCopyHook,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 18),
        )
      ],
    );
  }

  /// Default selection toolbar, but Copy also reports the copied text to
  /// [AliceCopyHook.onCopied] (e.g. to mirror it to the developer's computer).
  Widget _contextMenuWithCopyHook(
      BuildContext context, EditableTextState editableTextState) {
    final items = editableTextState.contextMenuButtonItems.map((item) {
      if (item.type != ContextMenuButtonType.copy) return item;
      return item.copyWith(onPressed: () {
        final value = editableTextState.textEditingValue;
        final copied = value.selection.textInside(value.text);
        item.onPressed?.call();
        if (copied.isNotEmpty) AliceCopyHook.onCopied?.call(copied);
      });
    }).toList();
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: items,
    );
  }

  String formatBytes(int bytes) => AliceConversionHelper.formatBytes(bytes);

  String formatDuration(int duration) =>
      AliceConversionHelper.formatTime(duration);

  String formatBody(dynamic body, String contentType) =>
      AliceParser.formatBody(body, contentType);

  String getContentType(Map<String, dynamic> headers) =>
      AliceParser.getContentType(headers);
}
