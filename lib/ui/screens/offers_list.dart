import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/ui/themes/dimentions.dart';
import 'package:hafar_market_app/ui/widget/offer.dart';

enum OffersListType { latest, forYou, closeToYou }

class OffersListPage extends StatefulWidget {
  const OffersListPage({super.key, required this.type, this.userArea});

  final OffersListType type;
  final String? userArea;

  @override
  State<OffersListPage> createState() => _OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> {
  final OfferController _controller = OfferController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _init();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _init() async {
    await _controller.refresh(context: context, userArea: widget.userArea, limit: 12);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      switch (widget.type) {
        case OffersListType.latest:
          _controller.loadMoreLatest(limit: 12);
          break;
        case OffersListType.forYou:
          _controller.loadMoreForYou(limit: 12);
          break;
        case OffersListType.closeToYou:
          if (widget.userArea != null) {
            _controller.loadMoreCloseToYou(userArea: widget.userArea!, limit: 12);
          }
          break;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List> listenable;
    String title;
    switch (widget.type) {
      case OffersListType.latest:
        listenable = _controller.latestOffers;
        title = "الأحدث في السوق";
        break;
      case OffersListType.forYou:
        listenable = _controller.forYouOffers;
        title = "قد يعجبك أيضاً";
        break;
      case OffersListType.closeToYou:
        listenable = _controller.closeToYouOffers;
        title = "قريب منك";
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: Dimensions.bodyPadding,
        child: ValueListenableBuilder<List>(
          valueListenable: listenable,
          builder: (context, offers, _) {
            if (offers.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 1.3,
              ),
              itemCount: offers.length,
              itemBuilder: (context, index) => Offer(offer: offers[index]),
            );
          },
        ),
      ),
    );
  }
}


