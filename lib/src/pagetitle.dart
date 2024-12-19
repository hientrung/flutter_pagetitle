import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Updates the application title dynamically based on the currently displayed [PageTitle].
/// Supports nested [PageTitle] widgets, using the title of the most recently built widget.
///
/// This widget listens to changes in the widget tree and updates the application's title
/// accordingly.  It uses a unique ID for each [PageTitle] instance to manage nested titles
/// correctly.  The title of the most recently built [PageTitle] widget is used as the
/// application's title.
///
/// Example:
///
/// ```dart
/// PageTitle(
///   title: 'Home Page',
///   child: Scaffold(
///     appBar: AppBar(title: Text('Home')),
///     body: Center(
///       child: PageTitle(
///         title: 'Product Details',
///         child: Text('Product details'),
///       ),
///     ),
///   ),
/// );
/// ```
/// In this example, the application title will initially be "Home Page". When the inner
/// `PageTitle` widget is built, the title will change to "Product Details".  When the inner
/// `PageTitle` widget is removed from the tree, the title will revert back to "Home Page".
class PageTitle extends StatefulWidget {
  /// The title to display in the application switcher.  This title will be used
  /// as the application's title when this [PageTitle] widget is the most recently
  /// built one in the widget tree.
  final String title;

  /// The child widget.  This can be any widget, including other nested [PageTitle]
  /// widgets.
  final Widget child;

  /// Creates a [PageTitle] widget.
  ///
  /// The [title] argument is required and specifies the title to use for the
  /// application switcher. The [child] argument is also required and specifies the
  /// child widget to display.
  const PageTitle({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<PageTitle> createState() => _PageTitleState();

  /// Retrieves the current title of the application.  This returns the title of
  /// the most recently built [PageTitle] widget in the current context.  Returns
  /// null if no [PageTitle] widget is found in the current context.
  static String? current(BuildContext context) =>
      _PageTitleData.of(context).current;
}

class _PageTitleState extends State<PageTitle> {
  static int idIndex = 0;
  final int id = ++idIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _PageTitleData.of(context).addTitle(id, widget.title);
  }

  @override
  void didUpdateWidget(PageTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _PageTitleData.of(context).updateTitle(id, widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void deactivate() {
    _PageTitleData.of(context).removeTitle(id);
    super.deactivate();
  }
}

class _PageTitleData {
  final List<({int id, String title})> _list = [];

  void addTitle(int id, String title) {
    _list.add((id: id, title: title));
    _updateSystemChrome(title);
  }

  void updateTitle(int id, String newTitle) {
    final i = _list.indexWhere((it) => it.id == id);
    _list[i] = (id: id, title: newTitle);
    if (i == _list.length - 1) _updateSystemChrome(newTitle);
  }

  void removeTitle(int id) {
    _list.removeWhere((it) => it.id == id);
    if (_list.isNotEmpty) _updateSystemChrome(_list.last.title);
  }

  String? get current => _list.lastOrNull?.title;

  void _updateSystemChrome(String title) {
    Timer.run(() {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(label: title),
      );
    });
  }

  static _PageTitleData of(BuildContext context) =>
      SharedAppData.getValue(context, _PageTitleData, () => _PageTitleData());
}
