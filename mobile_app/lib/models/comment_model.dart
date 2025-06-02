class Comment {
  final String? id;
  final String productId;
  final String userId;
  final List<String> image;
  final String comment;
  final int rating;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    this.id,
    required this.productId,
    required this.userId,
    required this.image,
    required this.comment,
    required this.rating,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String?,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      image: List<String>.from(json['image'] as List<dynamic>),
      comment: json['comment'] as String,
      rating: json['rating'] as int,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'userId': userId,
      'image': image,
      'comment': comment,
      'rating': rating,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
