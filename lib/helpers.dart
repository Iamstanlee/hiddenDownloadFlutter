import 'package:flutter/material.dart';

/// Navigate to a new route by passing a route widget
Future<dynamic> push(
  context,
  Widget widget,
) async {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}
