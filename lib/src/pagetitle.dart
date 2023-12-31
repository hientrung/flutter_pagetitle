import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///The widget used to update application title when it created, disposed, or rebuild
///
///Can be used with multiple/nested PageTitle and the latest one used to update application title
///
/// [title] and [child] are required arguments.
class PageTitle extends StatefulWidget {
  /// A one-line description of this app for use in the window manager.
  final String title;

  /// A color that the window manager should use to identify this app. Must be
  /// an opaque color (i.e. color.alpha must be 255 (0xFF)), and must not be
  /// null.
  final Color color;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  const PageTitle({
    super.key,
    required this.title,
    this.color = Colors.black,
    required this.child,
  });

  @override
  State<PageTitle> createState() => _PageTitleState();

  ///Get current title of application
  static String? current(BuildContext context) =>
      SharedAppData.getValue(context, _PageTitleData, () => _PageTitleData())
          .list
          .lastOrNull
          ?.title;
}

class _PageTitleState extends State<PageTitle> {
  late final _PageTitleModel model;

  @override
  void initState() {
    super.initState();
    model = _PageTitleModel(widget.title, widget.color);
  }

  @override
  void didUpdateWidget(covariant PageTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.title = widget.title;
    model.color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    data.list.add(model); //it's Set so just added once
    _maybeUpdate();
    return widget.child;
  }

  @override
  void dispose() {
    _maybeUpdate();
    data.list.remove(model);
    super.dispose();
  }

  late final data =
      SharedAppData.getValue(context, _PageTitleData, () => _PageTitleData());

  void _maybeUpdate() {
    if (data.updating || data.list.last != model) return;
    data.updating = true;
    //wait Router saved history or it completed changes
    Timer.run(() {
      data.updating = false;
      final m = data.list.lastOrNull;
      if (m != null) {
        SystemChrome.setApplicationSwitcherDescription(
            ApplicationSwitcherDescription(
          label: m.title,
          primaryColor: m.color.value,
        ));
      }
    });
  }
}

class _PageTitleModel {
  String title;
  Color color;
  _PageTitleModel(this.title, this.color);
}

class _PageTitleData {
  final list = <_PageTitleModel>{};
  bool updating = false;
}
