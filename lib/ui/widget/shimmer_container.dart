import 'package:flutter/material.dart';

Widget shimmerContainer(context, {double? width, double? height}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surface,
      ),
  );
}
