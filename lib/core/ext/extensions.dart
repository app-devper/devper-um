import 'package:common/core/theme/theme.dart';
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

extension WidgetFutureLoading<T> on Future<T> {
  FutureBuilder<T> toWidgetLoading({required Widget Function(T event) widgetBuilder}) {
    return FutureBuilder(
      future: this,
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

extension WidgetErrorLoading<T> on Future<T> {
  FutureBuilder<T> toWidgetErrorLoading({
    required Widget Function() widgetBuilder
  }) {
    return FutureBuilder(
      future: this,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return widgetBuilder();
        } else if (snapshot.hasData) {
          return Container();
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
