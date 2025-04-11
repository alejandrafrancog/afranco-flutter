import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildInfoLines({
    required String line1,
    String? line2,
    String? line3,
  }) {
    final lines = <Widget>[
      Text(line1, style: const TextStyle(fontSize: 16)),
      if (line2 != null) Text(line2, style: const TextStyle(fontSize: 14)),
      if (line3 != null) Text(line3, style: const TextStyle(fontSize: 14)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines,
    );
  }

  static Widget buildBoldFooter(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  static BoxDecoration buildRoundedBorder() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(128),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}