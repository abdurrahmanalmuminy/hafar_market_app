import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';

class EnhancedBadge extends StatelessWidget {
  const EnhancedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.75),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Text(
          "مُعزز",
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
