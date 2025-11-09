class SelectionMap {
  String? market;
  String? category;
  List<String>? subCategories;

  SelectionMap({this.market, this.category, this.subCategories});

  factory SelectionMap.fromJson(Map<String, dynamic> json) {
    return SelectionMap(
      market: json['market'] as String?,
      category: json['category'] as String?,
      subCategories: (json['subCategories'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'market': market,
      'category': category,
      'subCategories': subCategories,
    };
  }
}