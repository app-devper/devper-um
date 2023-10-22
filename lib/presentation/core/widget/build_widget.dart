import 'package:common/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

fieldFocusChange(
  BuildContext context,
  FocusNode currentFocus,
  FocusNode nextFocus,
) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

buildInputDecoration(String labelText, {Widget? suffixIcon}) {
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
    labelStyle: CustomTheme.mainTheme.textTheme.bodyMedium,
    suffixIcon: suffixIcon,
  );
}

buildPasswordField(
  BuildContext context,
  FocusNode focusNode,
  TextEditingController controller,
  String labelText,
  FocusNode nextNode,
) {
  Size size = MediaQuery.of(context).size;
  final state = useState(true);
  return SizedBox(
    width: size.width,
    height: 50,
    child: TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: state.value,
      keyboardType: TextInputType.visiblePassword,
      decoration: buildInputDecoration(
        labelText,
        suffixIcon: IconButton(
          icon: state.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
          color: CustomColor.hintColor,
          onPressed: () {
            state.value = !state.value;
          },
        ),
      ),
      cursorColor: CustomColor.hintColor,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, focusNode, nextNode);
      },
    ),
  );
}

buildTextFormField(
  BuildContext context,
  bool enabled,
  FocusNode focusNode,
  TextEditingController controller,
  String labelText,
  TextInputType textInputType,
  FocusNode nextNode,
) {
  final Size size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width,
    height: 50,
    child: TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      controller: controller,
      keyboardType: textInputType,
      decoration: buildInputDecoration(labelText),
      cursorColor: CustomColor.hintColor,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, focusNode, nextNode);
      },
    ),
  );
}
