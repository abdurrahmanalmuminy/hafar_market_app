import 'package:flutter/material.dart';

class CommercialItem extends StatelessWidget {
  const CommercialItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/commercial_placeholder.png"),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          width: 1,
          color:
              Theme.of(
                context,
              ).inputDecorationTheme.enabledBorder!.borderSide.color,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
