import 'package:flutter/material.dart';

class UICard extends StatelessWidget {
  final Widget child;
  const UICard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        border: Border.all(
          width: 1,
          color:
              Theme.of(
                context,
              ).inputDecorationTheme.enabledBorder!.borderSide.color,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
