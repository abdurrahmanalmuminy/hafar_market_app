import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/trend_model.dart';
import 'package:hafar_market_app/ui/widget/trending_card.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("الترند"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          TrendingCard(
            trend: TrendModel(
              pictures: [
                'https://www.rowadalaamal.com/wp-content/uploads/2024/08/مشروع-مصنع-حلويات-1.jpg'
              ],
              title: 'افتتاح معمل شوكولا',
              subtitle:
                  'معمل جديد للشوكولا والحلويات يفتتح أبوابه في حفر الباطن، يقدم أجود أنواع الشوكولا والحلويات الشرقية والغربية',
              content:
                  'نحن سعداء بالإعلان عن افتتاح معمل شوكولا جديد في حفر الباطن. يقدم المعمل أجود أنواع الشوكولا والحلويات الشرقية والغربية المصنوعة بأيدي خبراء محترفين. نستخدم أجود أنواع المكونات الطبيعية لضمان جودة عالية ومذاق رائع. المعمل مجهز بأحدث التقنيات والمعدات لضمان إنتاج منتجات عالية الجودة تلبي جميع الأذواق. نرحب بكم لزيارتنا وتجربة منتجاتنا المميزة.',
            ),
          ),
        ],
      ),
    );
  }
}