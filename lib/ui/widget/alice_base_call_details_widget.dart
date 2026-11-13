import 'dart:convert';

import 'package:alice_lightweight/helper/alice_conversion_helper.dart';
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
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 18),
        )
      ],
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
