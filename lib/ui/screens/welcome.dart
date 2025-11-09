import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/models/welcome_model.dart';
import 'package:hafar_market_app/ui/screens/auth/login.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Theme.of(context).colorScheme.onSurface == Colors.white
                  ? "assets/branding/hafar_market/logo_text_dark.png"
                  : "assets/branding/hafar_market/logo_text.png",
              width: 100,
            ),
            gap(height: 25),
            CarouselSlider(
              options: CarouselOptions(
                height: 449,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayCurve: Curves.easeInOutCubic,
                pauseAutoPlayInFiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items:
                  welcomeItems.map((welcomeItem) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Image.asset(
                                Theme.of(context).colorScheme.onSurface ==
                                        Colors.white
                                    ? welcomeItem.imageDark
                                    : welcomeItem.image,
                                height: 250,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            gap(height: 25),
                            ListTile(
                              title: Text(
                                welcomeItem.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                welcomeItem.subtitle,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
            ),
            gap(height: 25),
            DotsIndicator(
              dotsCount: 3,
              position: currentIndex.toDouble(),
              decorator: DotsDecorator(
                color: Theme.of(context).dividerTheme.color!,
                activeColor: AppColors.primaryColor,
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
            child: FilledButton(
              onPressed:
                  currentIndex != 2
                      ? null
                      : () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const LogIn(),
                          ),
                        );
                      },
              child: Text("إبدأ الأن"),
            ),
          ),
        ),
      ),
    );
  }
}
