import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/payment/custom_credit_card.dart';
import 'package:moyasar/moyasar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final PaymentConfig paymentConfig;
  late final Function closeDialog;

  @override
  void initState() {
    super.initState();
    paymentConfig = PaymentConfig(
      publishableApiKey: dotenv.env['MOYASAR_PUBLISHABLE_KEY'] ?? '',
      amount: 25758, // SAR 257.58
      description: "عمولة بيع سيارة",
      currency: "SAR",
      metadata: {"commission": "257.58", "item": "سيارة تويوتا كامري 2023"},
      creditCard: CreditCardConfig(saveCard: false, manual: false),
      applePay: ApplePayConfig(
        merchantId: dotenv.env['MOYASAR_APPLE_MERCHANT_ID'] ?? '',
        label: "سيارتك كوم",
        manual: false,
      ),
    );
  }

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          // Payment completed successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم الدفع بنجاح")),
          );
          Navigator.of(context).pop(true);
          break;
        case PaymentStatus.failed:
          // Payment failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل الدفع، يرجى المحاولة مرة أخرى")),
          );
          break;
        case PaymentStatus.initiated:
          // Payment initiated - waiting for 3DS or other verification
          // The 3DS flow is handled in CustomCreditCard widget
          // This status means payment is in progress
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("جارٍ معالجة الدفع...")),
          );
          break;
        case PaymentStatus.authorized:
          // Payment authorized but not yet captured
          // For most cases, this is treated as success
          // The payment will be captured automatically by Moyasar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تفويض الدفع بنجاح")),
          );
          Navigator.of(context).pop(true);
          break;
        case PaymentStatus.captured:
          // Payment captured successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم استلام الدفع بنجاح")),
          );
          Navigator.of(context).pop(true);
          break;
      }
    } else {
      // Handle non-PaymentResponse results
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء معالجة الدفع")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("الدفع")),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ListView(
          children: [
            Platform.isIOS
                ? Column(
                  children: [
                    ApplePay(
                      config: paymentConfig,
                      onPaymentResult: onPaymentResult,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Text("أو")],
                      ),
                    ),
                  ],
                )
                : const SizedBox(),
            CustomCreditCard(
              config: paymentConfig,
              onPaymentResult: onPaymentResult,
              locale: Localization.ar(),
            ),
          ],
        ),
      ),
    );
  }
}
