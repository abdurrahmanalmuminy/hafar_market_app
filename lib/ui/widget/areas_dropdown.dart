import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class DropDown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?)? onChanged;
  const DropDown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      items:
          items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            );
          }).toList(),
      iconSize: 20,
      dropdownColor: Theme.of(context).colorScheme.onSecondary,
      icon: Icon(
        UIcons.regularRounded.angle_small_down,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onChanged: onChanged,
    );
  }
}
