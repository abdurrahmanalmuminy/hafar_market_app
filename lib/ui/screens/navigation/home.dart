import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/models/market.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';
import 'package:hafar_market_app/ui/screens/notifications.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/commercial_item.dart';
import 'package:hafar_market_app/ui/widget/info_card.dart';
import 'package:hafar_market_app/ui/widget/shimmer_container.dart';
import 'package:hafar_market_app/ui/widget/market.dart';
import 'package:hafar_market_app/ui/widget/offer.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:hafar_market_app/ui/screens/offers_list.dart';
import 'package:provider/provider.dart';
import 'package:uicons/uicons.dart';
// import 'package:hafar_market_app/l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OfferController _offersController = OfferController();

  late Future<List<MarketModel>> futureMarkets;

  @override
  void initState() {
    super.initState();
    futureMarkets = loadMarkets();

    _offersController.refresh(
      context: context,
      userArea: Provider.of<UserProvider>(context, listen: false).currentUser?.bio,
    );
  }

  Future<void> _onPullToRefresh() async {
    await _offersController.refresh(
      context: context,
      userArea: Provider.of<UserProvider>(context, listen: false).currentUser?.bio,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserDTO? currentUser = userProvider.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("مرحباً.."),
              Text(
                currentUser != null ? currentUser.name : "يا هلا",
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Image.asset("assets/branding/hafar_market/logo.png", width: 70),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(UIcons.regularRounded.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => const Notifications()),
              );
            },
            icon: Icon(UIcons.regularRounded.bell),
          ),
          gap(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onPullToRefresh,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        displacement: 100,
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: Dimensions.bodyPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الأحدث في السوق",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const OffersListPage(type: OffersListType.latest),
                          ),
                        );
                      },
                      child: const Text("اعرض المزيد"),
                    ),
                  ],
                ),
              ),
              subtitle: ValueListenableBuilder<List<OfferModel>>(
                valueListenable: _offersController.latestOffers,
                builder: (context, latestOffers, child) {
                  return latestOffers.isEmpty
                      ? Padding(
                        padding: Dimensions.bodyPadding,
                        child: Row(
                          children: [
                            shimmerContainer(
                              context,
                              height: 265,
                              width: 265 * 1.1,
                            ),
                          ],
                        ),
                      )
                      : SizedBox(
                        height: 265,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _offersController.latestOffers.value.length,
                          padding: Dimensions.bodyPadding,
                          separatorBuilder: (context, index) => gap(width: 10),
                          itemBuilder:
                              (context, index) =>
                                  Offer(offer: latestOffers[index]),
                        ),
                      );
                },
              ),
            ),
            gap(height: 16),
            FutureBuilder(
              future: futureMarkets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 157,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No markets available.'));
                } else {
                  var markets = snapshot.data!;
                  return ListTile(
                    contentPadding: Dimensions.bodyPadding,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "وش تدور؟",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const OffersListPage(type: OffersListType.forYou),
                              ),
                            );
                          },
                          child: const Text("استكشف"),
                        ),
                      ],
                    ),
                    subtitle: SizedBox(
                      height: 93,
                      child: Row(
                        children: List.generate(4, (index) {
                          if (index < markets.length) {
                            return Expanded(
                              child: MarketCircle(market: markets[index]),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ),
                    ),
                  );
                }
              },
            ),
            gap(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: Dimensions.bodyPadding.copyWith(bottom: 10),
                child: Text(
                  "أعمال",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              subtitle: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: Dimensions.bodyPadding,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.3,
                ),
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return CommercialItem();
                },
              ),
            ),
            gap(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: Dimensions.bodyPadding.copyWith(bottom: 10),
                child: Text(
                  "قد يعجبك أيضاً",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              subtitle: ValueListenableBuilder<List<OfferModel>>(
                valueListenable: _offersController.forYouOffers,
                builder: (context, forYouOffers, child) {
                  return forYouOffers.isEmpty
                      ? Padding(
                        padding: Dimensions.bodyPadding,
                        child: shimmerContainer(context, height: 200),
                      )
                      : GridView.builder(
                        padding: Dimensions.bodyPadding,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1 / 1.3,
                            ),
                        itemCount: _offersController.forYouOffers.value.length,
                        itemBuilder: (context, index) {
                          return Offer(offer: forYouOffers[index]);
                        },
                      );
                },
              ),
            ),
            gap(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: Dimensions.bodyPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "قريب منك",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const OffersListPage(type: OffersListType.closeToYou),
                          ),
                        );
                      },
                      child: const Text("اعرض المزيد"),
                    ),
                  ],
                ),
              ),
              subtitle: ValueListenableBuilder<List<OfferModel>>(
                valueListenable: _offersController.closeToYouOffers,
                builder: (context, closeToYouOffers, child) {
                  return closeToYouOffers.isEmpty
                      ? Padding(
                        padding: Dimensions.bodyPadding,
                        child: Row(
                          children: [
                            shimmerContainer(context, height: 175, width: 285),
                          ],
                        ),
                      )
                      : SizedBox(
                        height: 145,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _offersController.closeToYouOffers.value.length,
                          padding: Dimensions.bodyPadding,
                          separatorBuilder: (context, index) => gap(width: 10),
                          itemBuilder:
                              (context, index) =>
                                  OfferTile(offer: closeToYouOffers[index]),
                        ),
                      );
                },
              ),
            ),
            gap(height: 16),
            Padding(
              padding: Dimensions.bodyPadding,
              child: InfoCard(
                icon: UIcons.regularRounded.redo,
                title: "نحتاج فزعتك!",
                subtitle:
                    "تو بدينا ومنطلقين بسرعة، لكن عشان نوصل لكل أهل الحفر.. ما نستغني عن فزعتك.",
                buttonLabel: "شارك التطبيق",
              ),
            ),
            gap(height: 100),
          ],
        ),
      ),
    );
  }
}
