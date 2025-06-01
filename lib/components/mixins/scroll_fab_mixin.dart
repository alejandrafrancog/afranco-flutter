import 'package:flutter/material.dart';

mixin ScrollFabMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  bool showFab = true;
  double lastScrollOffset = 0;

  void initializeScrollListener() {
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    final currentOffset = scrollController.position.pixels;

    if (currentOffset > lastScrollOffset + 20) {
      if (showFab && mounted) setState(() => showFab = false);
    } else if (currentOffset < lastScrollOffset - 20) {
      if (!showFab && mounted) setState(() => showFab = true);
    }

    lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
