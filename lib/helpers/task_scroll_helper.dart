import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin TaskScrollHelper<T extends StatefulWidget> on State<T> {
  late ScrollController scrollController;
  bool showFab = true;

  void initScrollHelper() {
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void disposeScrollHelper() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!showFab) {
        setState(() {
          showFab = true;
        });
      }
    } else if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (showFab) {
        setState(() {
          showFab = false;
        });
      }
    }
  }
}
