import 'package:flutter/material.dart';
import 'package:hafar_market_app/ui/screens/navigation/account.dart';
import 'package:hafar_market_app/ui/screens/navigation/business.dart';
import 'package:hafar_market_app/ui/screens/navigation/markets.dart';
import 'package:hafar_market_app/ui/screens/navigation/home.dart';
import 'package:hafar_market_app/ui/screens/navigation/trending.dart';
import 'package:hafar_market_app/ui/themes/colors.dart';
import 'package:hafar_market_app/ui/widget/add_offer.dart';
import 'package:uicons/uicons.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  FloatingActionButtonLocation fabLocation =
      FloatingActionButtonLocation.centerFloat;
  Widget addOfferFAB = const AddOffer();


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        fabLocation = FloatingActionButtonLocation.endFloat;
        addOfferFAB = const AddOffer();
      });
    });
  }

  int currentIndex = 0;
  List<Widget> page = [Home(), Trending(), Markets(), Business(), Account()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: IndexedStack(index: currentIndex, children: page),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color:
                    Theme.of(
                      context,
                    ).inputDecorationTheme.enabledBorder!.borderSide.color,
              ),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: currentIndex,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface,
            type: BottomNavigationBarType.fixed,
            iconSize: 22,
            selectedLabelStyle: const TextStyle(fontSize: 13),
            unselectedFontSize: 13,
            onTap: (index) {
              setState(() {
                currentIndex = index;
                fabLocation =
                    index == 0
                        ? FloatingActionButtonLocation.centerFloat
                        : FloatingActionButtonLocation.endFloat;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(UIcons.regularRounded.home),
                activeIcon: Icon(
                  UIcons.solidRounded.home,
                  color: AppColors.primaryColor,
                ),
                label: "الرئيسية",
              ),
              BottomNavigationBarItem(
                icon: Icon(UIcons.regularRounded.flame),
                activeIcon: Icon(
                  UIcons.solidRounded.flame,
                  color: AppColors.primaryColor,
                ),
                label: "الترند",
              ),
              BottomNavigationBarItem(
                icon: Icon(UIcons.regularRounded.apps),
                activeIcon: Icon(
                  UIcons.solidRounded.apps,
                  color: AppColors.primaryColor,
                ),
                label: "الأسواق",
              ),
              BottomNavigationBarItem(
                icon: Icon(UIcons.regularRounded.briefcase),
                activeIcon: Icon(
                  UIcons.solidRounded.briefcase,
                  color: AppColors.primaryColor,
                ),
                label: "أعمال",
              ),
              BottomNavigationBarItem(
                icon: Icon(UIcons.regularRounded.user),
                activeIcon: Icon(
                  UIcons.solidRounded.user,
                  color: AppColors.primaryColor,
                ),
                label: "حسابي",
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: fabLocation,
        floatingActionButton: addOfferFAB,
      ),
    );
  }
}
