import 'package:flutter/material.dart';

class Decorations {
  static BoxDecoration defaultDecoration(context) => BoxDecoration(
      color: Theme.of(context).colorScheme.onSecondary,
      border: Border.all(
          width: 1,
          color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color),
      borderRadius: BorderRadius.circular(15));
}
