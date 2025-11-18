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

  SearchClient? _client;
  bool _algoliaConfigured = false;

  final _controller = TextEditingController();
  Timer? _debounce;

  List<Hit> hits = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeAlgolia();
  }

  void _initializeAlgolia() {
    final appId = dotenv.env['ALGOLIA_APP_ID'] ?? '';
    final apiKey = dotenv.env['ALGOLIA_API_KEY'] ?? '';

    if (appId.isNotEmpty && apiKey.isNotEmpty) {
      _client = SearchClient(appId: appId, apiKey: apiKey);
      _algoliaConfigured = true;
    } else {
      debugPrint('Algolia not configured: Missing ALGOLIA_APP_ID or ALGOLIA_API_KEY in .env');
      _algoliaConfigured = false;
    }
  }

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
    if (!_algoliaConfigured || _client == null) {
      setState(() {
        loading = false;
        hits = [];
      });
      debugPrint("Search failed: Algolia not configured");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('البحث غير متاح حالياً. يرجى التحقق من إعدادات Algolia.'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    final hitQuery = SearchForHits(
      indexName: 'offers',
      query: query,
      hitsPerPage: 10,
    );

    try {
      final response = await _client!.searchForHits(requests: [hitQuery]);

      final [hitResp] = response.toList();

      setState(() {
        hits = hitResp.hits.toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint("Search failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل البحث: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _client?.dispose();
    super.dispose();
  }

  Widget _buildResults() {
    if (!_algoliaConfigured) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey),
              gap(height: 16),
              Text(
                'البحث غير متاح حالياً',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gap(height: 8),
              Text(
                'يرجى التحقق من إعدادات Algolia في ملف .env',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _controller.text.isEmpty
                ? 'ابدأ بالبحث عن العروض'
                : 'لا توجد نتائج',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

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
                market: hit["market"] ?? "",
                picture: (hit["pictures"] as List?)?.isNotEmpty == true
                    ? hit["pictures"][0]
                    : null,
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
