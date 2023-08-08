import 'package:common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:um/core/widget/obscure_state.dart';

InputDecoration buildInputDecoration(String labelText, {Widget? suffixIcon}) {
  return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: CustomColor.textFieldBackground,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: CustomColor.textFieldBackground,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: CustomColor.textFieldBackground,
        ),
      ),
      focusColor: CustomColor.hintColor,
      hoverColor: CustomColor.textFieldBackground,
      fillColor: CustomColor.textFieldBackground,
      filled: true,
      labelText: labelText,
      labelStyle: CustomTheme.mainTheme.textTheme.bodyText2,
      suffixIcon: suffixIcon);
}

extension WidgetStream<T> on Stream<T> {
  StreamBuilder<T> toWidget({required T initialData, required Widget Function(T event) widgetBuilder}) {
    return StreamBuilder(
        initialData: initialData,
        stream: this,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          return widgetBuilder(snapshot.requireData);
        });
  }
}

extension WidgetStreamLoading<T> on Stream<T> {
  StreamBuilder<T> toWidgetLoading({required Widget Function(T event) widgetBuilder}) {
    return StreamBuilder(
      stream: this,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
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

Provider<ObscureState> toObscure<T>({required Widget Function(ObscureState state) widgetBuilder}) {
  return Provider<ObscureState>(
    create: (context) => ObscureState(),
    child: Consumer<ObscureState>(builder: (context, state, child) => widgetBuilder(state)),
  );
}
