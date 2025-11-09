import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hafar_market_app/controllers/error_handler.dart';
import 'package:hafar_market_app/models/user/user.dart';
import 'package:hafar_market_app/providers/user_provider.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ErrorHandler _errorHandler = ErrorHandler();
  final UserProvider? _userProvider;

  UserController([this._userProvider]);

  Future<UserDTO?> initUser(userId, context) async {
    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();
      if (userDoc.exists) {
        UserDTO user = UserDTO.fromMap(userDoc.data()!);
        await _userProvider?.setUser(user);
        return user;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
      return null;
    }
  }

  Future<UserDTO?> getUser(userId, context) async {
    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();
      if (userDoc.exists) {
        UserDTO user = UserDTO.fromMap(userDoc.data()!);
        return user;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
      return null;
    }
  }

  Future<UserDTO?> createUser(UserDTO user, context) async {
    try {
      final userDoc = _firestore.collection("users").doc(user.userId);
      await userDoc.set(user.toMap());
      return user;
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
      return null;
    }
  }

  Future<void> addToWishlist(String userId, String postId, context) async {
    try {
      final userLikesDoc = _firestore
          .collection("users")
          .doc(userId)
          .collection("wishlist")
          .doc(postId);
      await userLikesDoc.set({'offer': postId, 'addeedAt': Timestamp.now});
    } catch (e, stackTrace) {
      _errorHandler.handleUnknownError(e, stackTrace, context);
    }
  }
}
