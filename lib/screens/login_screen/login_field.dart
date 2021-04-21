import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

/*class LoginField extends StatelessWidget {


  @override
  Widget build(BuildContext context) => _LoginFieldView(this);
}

class _LoginFieldView extends StatelessWidgetView<LoginField> {
  const _LoginFieldView(LoginField controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextFormField(
      validator: controller.validator,
      obscureText: controller.isPasswordField,
      decoration: InputDecoration(
        hintText: controller.hintText,
        labelText: controller.labelText,
        labelStyle: TextStyle(
          color: theme.colorScheme.primaryVariant,
        ),
        focusColor: Colors.amber,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primaryVariant)
        )
      ),
      autocorrect: false,

      cursorColor: theme.colorScheme.onBackground,
      cursorWidth: 1,
    );
  }
}*/

class LoginField extends StatefulWidget {

  final bool isPasswordField;
  final String hintText;
  final String labelText;
  final void Function(String) onChanged;
  final String Function(String) validator;

  const LoginField({
    Key key,
    this.isPasswordField = false,
    @required this.hintText,
    @required this.labelText,
    @required this.onChanged,
    @required this.validator,
  }) : super(key: key);

  @override
  _LoginFieldController createState() => _LoginFieldController();
}

class _LoginFieldController extends State<LoginField> {
  FocusNode focusNode = FocusNode();
  bool hidePassword;

  @override
  void initState() {
    hidePassword = widget.isPasswordField;
    // rebuild this widget whenever focus is changed
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  void toggleShowPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) => _LoginFieldView(this);
}

class _LoginFieldView extends StatefulWidgetView<LoginField, _LoginFieldController> {
  const _LoginFieldView(_LoginFieldController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color labelColor = controller.focusNode.hasFocus ?
    theme.colorScheme.primaryVariant :
    theme.colorScheme.onSurface;

    return TextFormField(
      focusNode: controller.focusNode,
      validator: widget.validator,
      obscureText: controller.hidePassword,
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: labelColor),
          alignLabelWithHint: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: theme.colorScheme.onSurface),

          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primaryVariant)
          ),

          // if isPasswordField add show/hide button
          suffix: widget.isPasswordField ? InkWell(
            child: Icon(
              controller.hidePassword ? Icons.visibility_off : Icons.visibility,
              color: theme.colorScheme.onSurface,

            ),
            onTap: controller.toggleShowPassword,
          ) : null,
      ),

      autocorrect: false,
      cursorColor: theme.colorScheme.onBackground,
      cursorWidth: 1,


    );
  }
}