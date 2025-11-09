import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/agreement.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class AddOffer extends StatelessWidget {
  const AddOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        Navigator.of(
                context,
              ).push(CupertinoPageRoute(builder: (context) => Agreement()));
      },
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, Color.fromARGB(255, 0, 38, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              offset: const Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Row(
              children: [
            gap(width: 5),
            const Text(
              "عرض جديد",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
