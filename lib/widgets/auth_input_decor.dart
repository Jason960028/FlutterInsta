import 'package:flutter/material.dart';

import '../constants/common_size.dart';

InputDecoration _textinputDecor(String hint) {
  return InputDecoration(
      hintText: hint,
      enabledBorder: _activeInputBorder(Colors.grey),
      errorBorder: _activeInputBorder(Colors.redAccent),
      focusedBorder: _activeInputBorder(Colors.grey),
      focusedErrorBorder: _activeInputBorder(Colors.redAccent),
      filled: true,
      fillColor: Colors.grey[100]
  );
}

OutlineInputBorder _activeInputBorder(Color color) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(common_s_gap)
  );
}