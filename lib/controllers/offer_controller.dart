import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/controllers/error_handler.dart';
import '../models/offer_model.dart';

class OfferController {
  final ValueNotifier<List<OfferModel>> latestOffers = ValueNotifier([]);
  final ValueNotifier<List<OfferModel>> forYouOffers = ValueNotifier([]);
  final ValueNotifier<List<OfferModel>> closeToYouOffers = ValueNotifier([]);

  final ValueNotifier<List<OfferModel>> marketOffers = ValueNotifier([]);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ErrorHandler _errorHandler = ErrorHandler();

  final Set<String> _loadedIds = {};

  // Pagination cursors
  DocumentSnapshot? _latestLastDoc;
  DocumentSnapshot? _forYouLastDoc;
  DocumentSnapshot? _closeToYouLastDoc;

  OfferController() {
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: 100 * 1024 * 1024,
    );
  }

  /// Load all offers in 3 categories: latest, for you, close to you
  Future<void> refresh({
    required BuildContext context,
    String? userArea, // example: حي الخالدية
    List<String>? preferredMarkets,
    List<String>? preferredCategories,
    int limit = 10,
  }) async {
    _loadedIds.clear();
    latestOffers.value = [];
    forYouOffers.value = [];
    closeToYouOffers.value = [];
    _latestLastDoc = null;
    _forYouLastDoc = null;
    _closeToYouLastDoc = null;

    try {
      final queryOptions = const GetOptions(source: Source.serverAndCache);

      final latestQuery = firestore
          .collection("offers")
          .orderBy("createdAt", descending: true)
          .limit(limit)
          .get(queryOptions);

      Query<Map<String, dynamic>> forYouBase = firestore.collection("offers");
      if (preferredMarkets != null && preferredMarkets.isNotEmpty) {
        forYouBase = forYouBase.where('market', whereIn: preferredMarkets.length > 10 ? preferredMarkets.sublist(0, 10) : preferredMarkets);
      }
      if (preferredCategories != null && preferredCategories.isNotEmpty) {
        forYouBase = forYouBase.where('tags', arrayContainsAny: preferredCategories.length > 10 ? preferredCategories.sublist(0, 10) : preferredCategories);
      }
      final forYouQuery = forYouBase
          .orderBy("createdAt", descending: true)
          .limit(limit)
          .get(queryOptions);

      Future<QuerySnapshot<Map<String, dynamic>>?> closeToYouQuery = userArea == null
          ? Future.value(null)
          : firestore
              .collection("offers")
              .where("area", isEqualTo: userArea)
              .orderBy("createdAt", descending: true)
              .limit(limit)
              .get(queryOptions);

      final resLatest = await latestQuery;
      final resForYou = await forYouQuery;
      final resClose = await closeToYouQuery;

      latestOffers.value = _mapSnapshot(resLatest);
      forYouOffers.value = _mapSnapshot(resForYou);
      closeToYouOffers.value = resClose == null ? [] : _mapSnapshot(resClose);

      // Set pagination cursors
      _latestLastDoc = resLatest.docs.isNotEmpty ? resLatest.docs.last : null;
      _forYouLastDoc = resForYou.docs.isNotEmpty ? resForYou.docs.last : null;
      _closeToYouLastDoc = (resClose != null && resClose.docs.isNotEmpty)
          ? resClose.docs.last
          : null;

      // Store loaded IDs to prevent duplication logic in UI or future uses
      _loadedIds
        ..addAll(latestOffers.value.map((e) => e.id))
        ..addAll(forYouOffers.value.map((e) => e.id))
        ..addAll(closeToYouOffers.value.map((e) => e.id));
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
    }
  }

  Future<void> incrementOfferViews(String offerId) async {
    final ref = firestore.collection('offers').doc(offerId);
    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap.data()?['views'] ?? 0) as int;
      tx.update(ref, {'views': current + 1});
    });
  }

  Future<void> incrementOfferShares(String offerId) async {
    final ref = firestore.collection('offers').doc(offerId);
    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap.data()?['shares'] ?? 0) as int;
      tx.update(ref, {'shares': current + 1});
    });
  }

  Future<void> loadMoreLatest({int limit = 10}) async {
    if (_latestLastDoc == null) return;
    final snapshot = await firestore
        .collection("offers")
        .orderBy("createdAt", descending: true)
        .startAfterDocument(_latestLastDoc!)
        .limit(limit)
        .get(const GetOptions(source: Source.serverAndCache));
    final more = _mapSnapshot(snapshot);
    if (more.isNotEmpty) {
      latestOffers.value = [...latestOffers.value, ...more];
      _latestLastDoc = snapshot.docs.last;
    }
  }

  Future<void> loadMoreForYou({int limit = 10}) async {
    if (_forYouLastDoc == null) return;
    final snapshot = await firestore
        .collection("offers")
        .where("tags", arrayContains: "forYou")
        .orderBy("createdAt", descending: true)
        .startAfterDocument(_forYouLastDoc!)
        .limit(limit)
        .get(const GetOptions(source: Source.serverAndCache));
    final more = _mapSnapshot(snapshot);
    if (more.isNotEmpty) {
      forYouOffers.value = [...forYouOffers.value, ...more];
      _forYouLastDoc = snapshot.docs.last;
    }
  }

  Future<void> loadMoreCloseToYou({
    required String userArea,
    int limit = 10,
  }) async {
    if (_closeToYouLastDoc == null) return;
    final snapshot = await firestore
        .collection("offers")
        .where("area", isEqualTo: userArea)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(_closeToYouLastDoc!)
        .limit(limit)
        .get(const GetOptions(source: Source.serverAndCache));
    final more = _mapSnapshot(snapshot);
    if (more.isNotEmpty) {
      closeToYouOffers.value = [...closeToYouOffers.value, ...more];
      _closeToYouLastDoc = snapshot.docs.last;
    }
  }

  /// Fetch offers using a custom Firestore query
  Future<void> fetchOffers(Query query, {BuildContext? context}) async {
    try {
      final marketQuery = query
          .orderBy("createdAt", descending: true)
          .limit(10)
          .get(const GetOptions(source: Source.serverAndCache));

      final results = await Future.wait([marketQuery]);

      marketOffers.value = _mapSnapshot(results[0]);
    } catch (e, s) {
      if (context != null) {
        _errorHandler.handleUnknownError(e, s, context);
      } else {
        debugPrint("❌ Error in fetchCustomOffers: $e");
      }
    }
  }

  /// Create a new offer in Firestore
  Future<OfferModel?> createOffer(
    OfferModel offer,
    BuildContext context,
  ) async {
    try {
      final offerDocRef = firestore.collection("offers").doc();
      final offerWithId = offer.copyWith(id: offerDocRef.id);
      await offerDocRef.set(offerWithId.toMap());
      return offerWithId;
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
      return null;
    }
  }

  /// Helper to map Firestore snapshot to OfferModel list
  List<OfferModel> _mapSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => OfferModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
