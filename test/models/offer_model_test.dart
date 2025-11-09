import 'package:flutter_test/flutter_test.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('OfferModel', () {
    test('toMap and fromMap roundtrip', () {
      final now = Timestamp.now();
      final offer = OfferModel(
        id: 'abc',
        userId: 'user1',
        content: 'Great item',
        pictures: ['https://example.com/a.jpg'],
        market: 'سيارات',
        category: 'Toyota',
        tags: ['cars', 'toyota'],
        createdAt: now,
        price: 123.45,
        area: 'الخليج',
        enhanced: true,
      );

      final map = offer.toMap();
      final again = OfferModel.fromMap(map);

      expect(again.id, offer.id);
      expect(again.userId, offer.userId);
      expect(again.content, offer.content);
      expect(again.pictures, offer.pictures);
      expect(again.market, offer.market);
      expect(again.category, offer.category);
      expect(again.tags, offer.tags);
      expect(again.createdAt.seconds, offer.createdAt.seconds);
      expect(again.price, offer.price);
      expect(again.area, offer.area);
      expect(again.enhanced, offer.enhanced);
    });

    test('copyWith overrides fields', () {
      final offer = OfferModel(
        id: '1',
        userId: 'u',
        content: 'c',
        pictures: [],
        market: 'm',
        category: 'cat',
        tags: [],
        createdAt: Timestamp.now(),
      );

      final updated = offer.copyWith(content: 'new', price: 10.0);
      expect(updated.content, 'new');
      expect(updated.price, 10.0);
      expect(updated.userId, offer.userId);
    });
  });
}


