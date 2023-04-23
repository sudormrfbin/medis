import 'package:flutter/material.dart';

mixin NavigationPage on Widget {
  String get pageTitle;

  FloatingActionButton? buildFloatingActionButton(BuildContext context);
}
