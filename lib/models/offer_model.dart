import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String userId;
  final String content;
  final List<String> pictures;
  final String market;
  final String category;
  final List<String> tags;
  final Timestamp createdAt;
  final Timestamp? editedAt; // nullable timestamp for last edit
  final double? price;
  final String? area;
  final bool? enhanced;

  OfferModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.pictures,
    required this.market,
    required this.category,
    required this.tags,
    required this.createdAt,
    this.editedAt,
    this.price,
    this.area,
    this.enhanced,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "content": content,
      "pictures": pictures,
      "market": market,
      "category": category,
      "tags": tags,
      "createdAt": createdAt,
      "editedAt": editedAt,
      "price": price,
      "area": area,
      "enhanced": enhanced,
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> json) {
    return OfferModel(
      id: json["id"] ?? '',
      userId: json["userId"] ?? '',
      content: json["content"],
      pictures: List<String>.from(json["pictures"] ?? []),
      market: json["market"],
      category: json["category"],
      tags: List<String>.from(json["tags"] ?? []),
      createdAt: json["createdAt"],
      editedAt: json["editedAt"],
      price: json["price"]?.toDouble(),
      area: json["area"],
      enhanced: json["enhanced"] ?? false,
    );
  }

  OfferModel copyWith({
    String? id,
    String? userId,
    String? content,
    List<String>? pictures,
    String? market,
    String? category,
    List<String>? tags,
    Timestamp? createdAt,
    Timestamp? editedAt,
    double? price,
    String? area,
    bool? enhanced,
  }) {
    return OfferModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      pictures: pictures ?? this.pictures,
      market: market ?? this.market,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      price: price ?? this.price,
      area: area ?? this.area,
      enhanced: enhanced ?? this.enhanced,
    );
  }
}