import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/widget/card.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? buttonLabel;
  final VoidCallback? onTap;
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.buttonLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UICard(
      child: ListTile(
        shape: RoundedRectangleBorder(),
        leading:
            icon != null
                ? Icon(icon!, size: 25, color: AppColors.primaryColor)
                : null,
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            buttonLabel != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gap(height: 5),
                    OutlinedButton(onPressed: onTap, child: Text(buttonLabel!)),
                  ],
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
