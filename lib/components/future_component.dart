import 'package:flutter/material.dart';

class FutureComponent<T> extends StatelessWidget {

  final Future<dynamic> future;

  final Widget Function(T result) resolved;
  final Widget Function(Object error) error;
  final Widget loading;

  const FutureComponent({Key key, @required this.future,
    @required this.resolved,
    @required this.error,
    @required this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done && snapshot.data != null)
            return resolved(snapshot.data);

          if(snapshot.connectionState == ConnectionState.waiting)
            return loading;

          return error(snapshot.error);
        }
    );
  }
}
