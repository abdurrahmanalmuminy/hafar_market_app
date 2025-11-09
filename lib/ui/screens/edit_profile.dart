import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = "عبدالرحمن";
    bioController.text =
        "تنطلق الكون الجديد في رحلة ملهمة بتأسيسها في مطلع هذا العام، محملة برؤية جديدة لتشكيل كون رقمي جديد. نحن نؤمن بقوة التكنولوجيا لتحقيق الأحلام.";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("تعديل الملف الشخصي")),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "اسم المستخدم",
                      hintText: "عبدالرحمن حسين",
                    ),
                  ),
                  gap(height: 10),
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "نبذة عنك",
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: Dimensions.bodyPadding,
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: FilledButton(onPressed: () {}, child: Text("حفظ التغييرات")),
          ),
        ),
      ),
    );
  }
}
