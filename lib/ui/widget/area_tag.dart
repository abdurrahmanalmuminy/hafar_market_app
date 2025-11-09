import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:uicons/uicons.dart';

class AreaTag extends StatelessWidget {
  final String area;
  final bool? isAddButton;
  final void Function()? onPressed;
  const AreaTag({
    super.key,
    required this.area,
    this.isAddButton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor:
            isAddButton == true
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
        backgroundColor:
            isAddButton == true
                ? AppColors.primaryColor : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            width: isAddButton == true
                ? 0 : 1,
            color:
                Theme.of(
                  context,
                ).inputDecorationTheme.enabledBorder!.borderSide.color,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      onPressed: onPressed,
      label: Text(area),
      icon:
          isAddButton == true
              ? Icon(UIcons.regularRounded.settings_sliders)
              : null,
    );
  }
}
