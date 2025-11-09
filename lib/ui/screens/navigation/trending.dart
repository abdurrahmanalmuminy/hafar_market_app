import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIcons.solidRounded.flame,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              width: 320,
              child: ListTile(
                title: Text(
                  "الترند",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  "الترند هو المحتوى الأكثر رواجاً في حفر الباطن وسيتم إضافته في التحديثات القادمة",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}