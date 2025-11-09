import 'package:flutter/material.dart';

class ServiceModel {
  final String label;
  final Color color;
  final int index;

  ServiceModel({required this.label, required this.color, required this.index});
}

List<ServiceModel> servicesList = [
  ServiceModel(label: "الأظافر", color: Color(0xFFFF0051), index: 0),
  ServiceModel(label: "الشعر", color: Color(0xFFFF6700), index: 1),
  ServiceModel(label: "الحواجب والرموش", color: Color(0xFFFF4A00), index: 2),
  ServiceModel(label: "إزالة الشعر", color: Color(0xFFFF00F5), index: 3),
  ServiceModel(label: "العناية بالبشرة", color: Color(0xFFFFCC00), index: 4),
  ServiceModel(label: "الحقن والحشو", color: Color(0xFFFF9400), index: 5),
  ServiceModel(label: "مكياج", color: Color(0xFFFF3E00), index: 6),
  ServiceModel(label: "الاستشارة", color: Color(0xFF2900FF), index: 7),
];
