import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/ui/screens/offer_page.dart';

class DynamicLinksService {
  final FirebaseDynamicLinks _links = FirebaseDynamicLinks.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<NavigatorState> navigatorKey;

  DynamicLinksService({required this.navigatorKey});

  Future<void> init() async {
    try {
      // Handle initial link if app was opened from a dynamic link
      final PendingDynamicLinkData? initialData = await _links.getInitialLink();
      if (initialData?.link != null) {
        // Delay handling until navigator is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleLink(initialData!.link);
        });
      }

      // Foreground/background link stream
      _links.onLink.listen((data) {
        final Uri link = data.link;
        _handleLink(link);
      });
    } catch (e) {
      debugPrint('Error initializing DynamicLinksService: $e');
      // Don't rethrow - allow app to continue without dynamic links
    }
  }

  Future<void> _handleLink(Uri link) async {
    try {
      // Wait for navigator to be ready
      if (navigatorKey.currentState == null) {
        debugPrint('Navigator not ready yet, skipping link handling');
        return;
      }

      // Expecting format: https://<host>/offer/<offerId>
      final segments = link.pathSegments;
      if (segments.isNotEmpty && segments.first == 'offer' && segments.length >= 2) {
        final offerId = segments[1];
        final doc = await _firestore.collection('offers').doc(offerId).get();
        if (doc.exists) {
          final offer = OfferModel.fromMap(doc.data() as Map<String, dynamic>);
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => OfferPage(offer: offer)),
          );
        } else {
          debugPrint('Offer not found: $offerId');
        }
      }
    } catch (e) {
      debugPrint('Error handling dynamic link: $e');
    }
  }

  Future<Uri> buildOfferLink(String offerId) async {
    final String domain = dotenv.env['DYNAMIC_LINK_DOMAIN'] ?? '';
    final String appLinkHost = dotenv.env['APP_LINK_HOST'] ?? 'https://hafarmarket.app';
    final String deepLink = '$appLinkHost/offer/$offerId';

    final DynamicLinkParameters params = DynamicLinkParameters(
      link: Uri.parse(deepLink),
      uriPrefix: 'https://$domain',
      androidParameters: const AndroidParameters(packageName: 'com.newuniverse.hafarmarket'),
      iosParameters: const IOSParameters(bundleId: 'com.newuniverse.hafarmarket'),
      navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: true),
    );

    final ShortDynamicLink shortLink = await _links.buildShortLink(params);
    return shortLink.shortUrl;
  }
}



