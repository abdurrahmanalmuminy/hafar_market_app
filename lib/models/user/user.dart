import 'package:cloud_firestore/cloud_firestore.dart';

class UserDTO {
  String userId;
  String name;
  String phoneNumber;
  String? photoUrl;
  String? bio;
  Timestamp? joinedAt;

  UserDTO({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.photoUrl,
    this.bio, // Nullable
    this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "name": name,
      "phoneNumber": phoneNumber,
      "photoUrl": photoUrl,
      "bio": bio,
      "joinedAt": joinedAt,
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      userId: map["userId"] as String,
      name: map["name"] as String,
      phoneNumber: map["phoneNumber"] as String,
      photoUrl: map["photoUrl"] as String?,
      bio: map["bio"] as String?,
      joinedAt: map["joinedAt"] as Timestamp?,
    );
  }

  UserDTO copyWith({
    String? userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    String? bio,
    Timestamp? joinedAt,
  }) {
    return UserDTO(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
