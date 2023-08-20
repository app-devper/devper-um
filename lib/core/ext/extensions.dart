import 'package:common/theme.dart';
import 'package:flutter/material.dart';

extension WidgetStream<T> on Stream<T> {
  StreamBuilder<T> toWidget({required T initialData, required Widget Function(T event) widgetBuilder}) {
    return StreamBuilder(
      initialData: initialData,
      stream: this,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return widgetBuilder(snapshot.requireData);
      },
    );
  }
}

extension WidgetStreamLoading<T> on Stream<T> {
  StreamBuilder<T> toWidgetLoading({required Widget Function(T event) widgetBuilder}) {
    return StreamBuilder(
      stream: this,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return widgetBuilder(snapshot.requireData);
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: CustomColor.backgroundMain,
            ),
          );
        }
      },
    );
  }
}
