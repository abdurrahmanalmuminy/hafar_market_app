import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class DropDown extends StatelessWidget {
  final String? label;
  final List<String> items;
  final Function(String?)? onChanged;
  const DropDown({
    super.key,
    this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          label: label == null
              ? null
              : Text(label!),
        ),
        items:
            items.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
        iconSize: 20,
        dropdownColor: Theme.of(context).colorScheme.onSecondary,
        icon: Icon(
          UIcons.regularRounded.angle_small_down,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
