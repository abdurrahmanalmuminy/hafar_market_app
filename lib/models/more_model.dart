import 'package:flutter/material.dart';

class MoreItemModel {
  final IconData leadingIcon;
  final String label;
  final IconData? trailingIcon;
  final void Function()? onTap;

  MoreItemModel({
    required this.leadingIcon,
    required this.label,
    this.trailingIcon,
    this.onTap,
  });
}
