import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafar_market_app/ui/widget/info_card.dart';

void main() {
  testWidgets('InfoCard displays title, subtitle and button', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InfoCard(
            title: 'Hello',
            subtitle: 'World',
            buttonLabel: 'Action',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);

    await tester.tap(find.text('Action'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}


