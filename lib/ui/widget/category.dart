import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/ui/widget/card.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return UICard(
      child: Center(
        child: Text(
          category.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
