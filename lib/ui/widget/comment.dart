import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';

class Comment extends StatelessWidget {
  const Comment({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.onSecondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color:
              Theme.of(
                context,
              ).inputDecorationTheme.enabledBorder!.borderSide.color,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        "عبدالرحمن",
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(color: AppColors.primaryColor),
      ),
      subtitle: Text(
        "اتمنى انك ترد وتكون واضح بالسوم، تواصلت معك على الواتساب ولا رديت للحين.",
      ),
    );
  }
}
