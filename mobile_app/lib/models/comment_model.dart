class Comment {
  final String? id;
  final String productId;
  final String userId;
  final List<String> images;
  final String comment;
  final int rating;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    this.id,
    required this.productId,
    required this.userId,
    required this.images,
    required this.comment,
    required this.rating,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id']?.toString(),
      productId: json['productId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      images:
          json['images'] != null
              ? List<String>.from(json['images'] as List<dynamic>)
              : [],
      comment: json['comment']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'userId': userId,
      'images': images,
      'comment': comment,
      'rating': rating,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
