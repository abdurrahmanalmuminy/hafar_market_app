import 'package:hafar_market_app/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  UserDTO? _currentUser;

  UserDTO? get currentUser => _currentUser;

  Future<void> setUser(UserDTO user) async {
    _currentUser = user;
    await _saveUserToPreferences(user);
    notifyListeners(); // Notifies all listeners of changes
  }

  Future<void> loadUserFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    final userId = preferences.getString("userId");
    final name = preferences.getString("name");
    final phoneNumber = preferences.getString("phoneNumber");
    final photoUrl = preferences.getString("photoUrl");
    final bio = preferences.getString("bio");

    if (userId != null && name != null) {
      _currentUser = UserDTO(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber!,
        photoUrl: photoUrl!,
        bio: bio!,
      );
      notifyListeners();
    }
  }

  Future<void> clearUserData() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> _saveUserToPreferences(UserDTO user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId);
    await prefs.setString('name', user.name);
    await prefs.setString('phoneNumber', user.phoneNumber);
    await prefs.setString('photoUrl', user.photoUrl ?? "");
    await prefs.setString('bio', user.bio ?? "");
  }
}
