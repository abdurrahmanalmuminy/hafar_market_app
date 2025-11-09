import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/screens/commission/payment.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class PayCommission extends StatefulWidget {
  const PayCommission({super.key});

  @override
  State<PayCommission> createState() => _PayCommissionState();
}

class _PayCommissionState extends State<PayCommission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("إدفع العمولة")),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "أدخل سعر البيع",
                      hintText: "150.00 ر.س",
                    ),
                  ),
                  gap(height: 10),
                  TextFormField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "مالذي بعته؟",
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
            child: FilledButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(CupertinoPageRoute(builder: (context) => Payment()));
              },
              child: Text("ادفع العمولة 1%"),
            ),
          ),
        ),
      ),
    );
  }
}
