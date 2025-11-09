import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uicons/uicons.dart';

class MarketModel {
  final String label;
  final IconData icon;
  final List<CategoryModel> categories;

  MarketModel({
    required this.label,
    required this.icon,
    required this.categories,
  });

  factory MarketModel.fromJson(String label, Map<String, dynamic> json) {
    return MarketModel(
      label: label,
      icon: getMarketIconForLabel(label),
      categories: _parseCategoryMap(json),
    );
  }

  static List<CategoryModel> _parseCategoryMap(Map<String, dynamic> map) {
    return map.entries.map((entry) {
      if (entry.value is Map<String, dynamic>) {
        // Recursive call for nested categories
        return CategoryModel(
          name: entry.key,
          children: _parseCategoryMap(entry.value as Map<String, dynamic>),
        );
      } else if (entry.value is List) {
        // List of sub-items (e.g., car models)
        return CategoryModel(
          name: entry.key,
          subItems:
              (entry.value as List)
                  .cast<String>()
                  .toList(), // Ensure it's a List<String>
        );
      } else {
        // Handle the case where a category has a single value (if applicable in your data)
        return CategoryModel(
          name: entry.key,
          // subItems: [entry.value.toString()], //  Consider if you need this.
        );
      }
    }).toList();
  }
}

class CategoryModel {
  final String name;
  final List<String>? subItems;
  final List<CategoryModel>? children;

  CategoryModel({required this.name, this.subItems, this.children});
}

Future<List<MarketModel>> loadMarkets() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/markets.json',
  );
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  return jsonData.entries
      .map(
        (entry) => MarketModel.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        ),
      )
      .toList();
}


  IconData getMarketIconForLabel(String label) {
    switch (label) {
      case 'سيارات':
        return UIcons.regularRounded.car;
      case 'عقار':
        return UIcons.regularRounded.building;
      case 'أجهزة':
        return UIcons.regularRounded.laptop;
      case 'حيوانات':
        return UIcons.regularRounded.paw;
      case 'أثاث':
        return UIcons.regularRounded.chair_office;
      case 'خدمات':
        return UIcons.regularRounded.headset;
      case 'وظائف':
        return UIcons.regularRounded.briefcase;
      case 'أزياء':
        return UIcons.regularRounded.gamepad;
      case 'طعام':
        return UIcons.regularRounded.hamburger;
      case 'برمجة':
        return UIcons.regularRounded.square_terminal;
      case 'تصميم':
        return UIcons.regularRounded.magic_wand;
      case 'نوادر':
        return UIcons.regularRounded.gem;
      case 'فنون':
        return UIcons.regularRounded.palette;
      case 'رحلات':
        return UIcons.regularRounded.camping;
      case 'كل الأسواق':
        return UIcons.regularRounded.apps;
      default:
        return UIcons.regularRounded.search;
    }
  }