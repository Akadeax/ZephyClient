import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

class SearchBar extends StatefulWidget {

  final void Function(String) onChanged;
  final String hintText;

  const SearchBar({
    Key key,
    @required this.onChanged,
    @required this.hintText,
  }) : super(key: key);

  @override
  _SearchBarController createState() => _SearchBarController();
}

class _SearchBarController extends State<SearchBar> {
  @override
  Widget build(BuildContext context) => _SearchBarView(this);

  Timer _debounce;

  void onSearchChanged(String query) {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      widget.onChanged.call(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class _SearchBarView extends StatefulWidgetView<SearchBar, _SearchBarController> {
  const _SearchBarView(_SearchBarController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      onChanged: controller.onSearchChanged,
      cursorColor: theme.colorScheme.onSurface,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        hintText: widget.hintText,

        suffixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurface,
        ),
        fillColor: theme.colorScheme.surface,
        hoverColor: theme.colorScheme.surface,
        filled: true,
        border: _border(context),
        enabledBorder: _border(context),
        focusedBorder: _border(context),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide.none,
    );
  }
}