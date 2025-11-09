import 'dart:async';

import 'package:algoliasearch/algoliasearch.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/offer_controller.dart';
import 'package:hafar_market_app/ui/widget/offer.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:uicons/uicons.dart';
// import 'package:hafar_market_app/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  OfferController controller = OfferController();

  late final SearchClient client = SearchClient(
    appId: dotenv.env['ALGOLIA_APP_ID'] ?? '',
    apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? '',
  );

  final _controller = TextEditingController();
  Timer? _debounce;

  List<Hit> hits = [];
  bool loading = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          hits = [];
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => loading = true);

    final hitQuery = SearchForHits(
      indexName: 'offers',
      query: query,
      hitsPerPage: 10,
    );

    try {
      final response = await client.searchForHits(requests: [hitQuery]);

      final [hitResp] = response.toList();

      setState(() {
        hits = hitResp.hits.toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint("Search failed: $e");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    client.dispose();
    super.dispose();
  }

  Widget _buildResults() {
    if (hits.isEmpty) return SizedBox();
    return ListView(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "نتائج البحث",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          subtitle: ListView.separated(
            itemCount: hits.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => gap(height: 10),
            itemBuilder: (context, index) {
              Hit hit = hits[index];
              return SearchResult(
                content: hit['content'] ?? "",
                market: hit["market"],
                picture: hit["pictures"][0],
                price: hit["price"],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        title: SearchBar(
          autoFocus: true,
          leading: Icon(UIcons.regularRounded.search, size: 20),
          hintText: "البحث",
          controller: _controller,
          onChanged: _onSearchChanged,
        ),
      ),
      body: _buildResults(),
    );
  }
}
