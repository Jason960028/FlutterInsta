import 'package:flutter/material.dart';

void simpleSnackbar(BuildContext context, String message) { // Changed parameter name s to message for clarity
  // Ensure the context is valid and the widget is still mounted, if applicable
  // (though for a simple utility function, the calling widget should handle this)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      // You can add more properties here, e.g., duration
      // duration: Duration(seconds: 3),
    ),
  );
}