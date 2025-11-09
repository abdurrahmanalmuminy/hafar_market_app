import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';

class AreaSelectionBottomSheet extends StatefulWidget {
  final List<String>? initialSelectedAreas;

  const AreaSelectionBottomSheet({super.key, this.initialSelectedAreas});

  @override
  State<AreaSelectionBottomSheet> createState() =>
      _AreaSelectionBottomSheetState();
}

class _AreaSelectionBottomSheetState extends State<AreaSelectionBottomSheet> {
  // Use the data directly from the immersive
  final Map<String, List<String>> _areasData = {
    "الأحياء السكنية": [
      'اليرموك',
      'الشفاء',
      'الرائد',
      'الفيحاء',
      'الربوة',
      'البلدية',
      'غرناطة',
      'النخيل',
      'المصيف',
      'فليج',
      'الربيع',
      'الخليج',
      'الريان',
      'قرطبة',
      'المحمدية',
      'السليمانية',
      'الوادي',
      'النهضة',
      'التلال',
      'الصفاء',
      'الباطن',
      'النزهة',
      'ابوموسى الاشعري',
    ],
    "الأحياء التجارية": ['الصناعية', 'النايفية', 'الخالدية', 'الواحة'],
    "الأحياء التعليمية": ['الجامعة', 'الإسكان', 'الروضة', 'الفيصلية'],
  };

  final Map<String, bool> _selectedAreas = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected areas map
    _areasData.forEach((category, areas) {
      for (var area in areas) {
        _selectedAreas[area] =
            widget.initialSelectedAreas?.contains(area) ??
            false; // Use initialSelectedAreas
      }
    });
  }

  void clearSelectedAreas() {
    setState(() {
      _selectedAreas.forEach((key, value) {
        _selectedAreas[key] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("حدد الأحياء"),
        actions: [
          IconButton(
            onPressed: clearSelectedAreas,
            icon: Icon(UIcons.regularRounded.trash),
            color: Colors.red,
          ),
          gap(width: 8),
        ],
      ),
      body: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _areasData.length,
          itemBuilder: (context, index) {
            final categoryName = _areasData.keys.elementAt(index);
            final subItems = _areasData[categoryName]!;
            return ListTile(
              title: Text(
                categoryName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    subItems.map((area) {
                      final isSelected = _selectedAreas[area] ?? false;
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(area),
                        value: isSelected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (newValue != null) {
                              _selectedAreas[area] = newValue;
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border(
            top: BorderSide(
              color: Theme.of(context)
                  .inputDecorationTheme
                  .enabledBorder!
                  .borderSide
                  .color,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: Dimensions.bodyPadding.copyWith(top: 10),
            child: SizedBox(
              height: 55,
              child: FilledButton(
                onPressed: () {
                  final selectedList =
                      _selectedAreas.keys
                          .where((key) => _selectedAreas[key] == true)
                          .toList();
                  Navigator.pop(context, selectedList);
                },
                child: const Text("تطبيق"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
