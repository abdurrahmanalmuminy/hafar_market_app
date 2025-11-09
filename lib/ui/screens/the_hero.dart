import 'package:flutter/material.dart';

void openTheHERO(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("البطل"),
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 320,
                child: ListTile(
                  title: Text(
                    "البطل",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    "البطل، هو بطلك ومساعدك الشخصي وسيتوفر في الإصدارات القادمة من سوق الحفر",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
