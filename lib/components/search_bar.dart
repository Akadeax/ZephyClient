import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

class DebouncedTextField extends StatefulWidget {

  final void Function(String) onChanged;
  final String hintText;
  final InputDecoration decoration;
  final TextEditingController controller;
  final double width;

  const DebouncedTextField({
    Key key,
    @required this.onChanged,
    this.hintText,
    this.decoration,
    this.controller,
    this.width,
  }) : super(key: key);

  @override
  _DebouncedTextFieldController createState() => _DebouncedTextFieldController();
}

class _DebouncedTextFieldController extends State<DebouncedTextField> {
  @override
  Widget build(BuildContext context) => _DebouncedTextFieldView(this);

  Timer _debounce;

  void onTextChanged(String query) {
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

class _DebouncedTextFieldView extends StatefulWidgetView<DebouncedTextField, _DebouncedTextFieldController> {
  const _DebouncedTextFieldView(_DebouncedTextFieldController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: widget.width,
      height: 40,
      child: TextField(
        controller: widget.controller,
        onChanged: controller.onTextChanged,
        cursorColor: theme.colorScheme.onSurface,
        style: theme.textTheme.button,
        decoration: widget.decoration ?? InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          hintText: widget.hintText ?? "",

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