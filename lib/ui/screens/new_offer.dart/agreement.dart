import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/screens/new_offer.dart/offer_market.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class Agreement extends StatefulWidget {
  const Agreement({super.key});

  @override
  State<Agreement> createState() => _AgreementState();
}

// Define an article class to hold the title and a list of content points
class Article {
  String title;
  List<String> content; // Content is now a list of strings
  Article(this.title, this.content);
}

class _AgreementState extends State<Agreement> {
  // State variable to manage the checkbox status
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    // List of articles with content split into separate points
    List<Article> articles = [
      Article(
        "تمهيد",
        [
          """يوضح أن هذه الاتفاقية تُنظم العلاقة بين منصة "سوق الحفر" (المملوكة لمؤسسة الكون الجديد لتقنية المعلومات) وبين أي مستخدم يعرض منتجًا أو خدمة على المنصة.""",
          """ويعتبر استخدام المنصة قبولاً صريحًا بكافة بنود الاتفاق.""",
        ],
      ),
      Article(
        "اتفاقية الاستخدام",
        [
          """يلتزم المستخدم بعدم نشر أي محتوى يخالف الشريعة أو القوانين أو الآداب العامة.""",
          """يقر المستخدم أن كل ما ينشره من بيانات أو صور أو وصف صحيح ويمثل مسؤوليته الكاملة.""",
          """يُمنع نشر إعلانات وهمية أو مزيفة أو مضللة.""",
          """يحق للإدارة حذف أو تعديل أو إيقاف أي إعلان دون إشعار مسبق في حال مخالفته للشروط.""",
          """يُمنع استخدام بيانات الاتصال لأغراض غير قانونية أو مزعجة.""",
        ],
      ),
      Article(
        "اتفاقية الرسوم والعمولة",
        [
          """يقر المستخدم بأن استخدامه للمنصة قد يخضع لرسوم خدمات مدفوعة (مثل الإعلان المثبت أو الباقات).""",
          """تفرض المنصة نسبة عمولة قدرها 1٪ على كل عملية بيع ناجحة تمت من خلال التواصل عبر المنصة، ويكون البائع هو الملزم بدفعها.""",
          """عند تفعيل بوابة الدفع لاحقًا، تُخصم العمولة تلقائيًا من المبلغ المحوّل.""",
          """تحتفظ المنصة بحق تعديل الرسوم أو العمولة مستقبلاً مع إشعار المستخدمين.""",
        ],
      ),
      Article(
        "الملكية الفكرية",
        [
          """جميع حقوق التصميم والمحتوى والعلامة التجارية الخاصة بالمنصة محفوظة لمؤسسة الكون الجديد.""",
          """لا يحق لأي مستخدم نسخ أو إعادة نشر أو استخدام محتوى المنصة لأغراض تجارية دون إذن خطي.""",
        ],
      ),
      Article(
        "سياسة النشر والحذف",
        [
          """يحق للإدارة حذف أي إعلان يحتوي على إساءة أو خداع أو يثير شكوى من المستخدمين.""",
          """يُمنع نشر أكثر من إعلان لنفس المنتج بهدف التكرار أو التضليل.""",
          """في حال الحذف بسبب مخالفة، لا تُسترد الرسوم المدفوعة.""",
        ],
      ),
      Article(
        "حظر بيع منتجات غير مملوكة",
        [
          """يُمنع منعًا باتًا على المستخدمين عرض أو بيع أي منتجات أو خدمات لا يمتلكون حقوق ملكيتها الكاملة أو ليس لديهم تفويض صريح ببيعها.""",
          """يتحمل المستخدم المسؤولية القانونية الكاملة عن أي انتهاك لحقوق الملكية الفكرية أو حقوق الغير نتيجة لعرض منتجات غير مملوكة.""",
          """تحتفظ إدارة المنصة بحق حذف أي إعلان يخالف هذا البند وإيقاف حساب المستخدم المخالف دون إشعار مسبق أو استرداد لأي رسوم مدفوعة.""",
        ],
      ),
      Article(
        "الإلغاء والاسترجاع",
        [
          """لا يُسمح باسترجاع الرسوم المدفوعة بعد نشر الإعلان إلا في حال خطأ تقني مثبت من المنصة.""",
          """للإدارة الحق في إلغاء أو إيقاف أي حساب ينتهك الشروط دون التزام برد أي رسوم.""",
        ],
      ),
    ];

    // Widget to display each article with its title and a list of content points
    Widget articleWidget(Article article) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1,
            color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
          ),
        ),
        padding: const EdgeInsets.all(16.0), // Add padding inside the container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8), // Space between title and content
            // Iterate through the content list to display each point
            ...article.content.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0), // Space between points
                  child: Text(
                    '• $point', // Add a bullet point for each item
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(title: const Text("اتفاقية الإستخدام")),
      body: Padding(
        padding: Dimensions.bodyPadding.copyWith(bottom: 100),
        child: ListView.separated(
          itemCount: articles.length,
          itemBuilder: (context, index) => articleWidget(articles[index]),
          separatorBuilder: (context, index) => gap(height: 15),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: Dimensions.bodyPadding.copyWith(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  value: _agreedToTerms,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _agreedToTerms = newValue ?? false; // Update the state when checkbox is toggled
                    });
                  },
                  title: Text(
                    "قرأت وفهمت وأوافق على جميع الشروط والسياسات الخاصة باستخدام منصة سوق الحفر",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  controlAffinity: ListTileControlAffinity.leading, // Place checkbox at the start
                  activeColor: Theme.of(context).colorScheme.primary, // Color when checked
                ),
                gap(height: 15),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _agreedToTerms
                        ? () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(builder: (context) => OfferMarket()),
                            );
                          }
                        : null, // If not agreed, onPressed is null, disabling the button
                    child: const Text("التالي"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
