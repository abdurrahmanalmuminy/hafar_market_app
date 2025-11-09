import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/more_model.dart';

class MoreTile extends StatelessWidget {
  final MoreItemModel item;
  final bool? isImportant;
  const MoreTile({super.key, required this.item, this.isImportant});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.onTap != null ? 1 : 0.5,
      child: ListTile(
        onTap: item.onTap,
        leading: Icon(
          item.leadingIcon,
          color: isImportant == true ? Colors.red : null,
          size: 20,
        ),
        title: Text(
          item.label,
          style: TextStyle(color: isImportant == true ? Colors.red : null),
        ),
        trailing: Icon(item.trailingIcon, size: 20),
      ),
    );
  }
}
