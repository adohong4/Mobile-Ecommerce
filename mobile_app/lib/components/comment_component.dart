import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/comment_model.dart';
import 'package:mobile_app/services/comment_service.dart';

class CommentComponent extends StatefulWidget {
  final String productId;

  const CommentComponent({super.key, required this.productId});

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  List<Comment> productComments = [];
  Map<String, int> ratingStats = {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
  double averageRating = 0.0;
  bool _isLoading = false;
  String? _commentError;
  Map<String, Map<String, dynamic>> userInfo = {}; // Cache thông tin người dùng

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _commentError = null;
    });

    try {
      final result = await CommentService().getRatingStatsAndComments(
        widget.productId,
      );

      if (mounted) {
        setState(() {
          if (result['success']) {
            productComments = result['comments'] ?? [];
            ratingStats = Map<String, int>.from(
              result['ratingStats'] ?? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
            );
            averageRating = result['averageRating']?.toDouble() ?? 0.0;

            // Lấy thông tin người dùng
            _fetchUserInfo();
          } else {
            productComments = [];
            ratingStats = {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
            averageRating = 0.0;
            _commentError = result['message'] ?? 'Không lấy được thông tin';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _commentError = 'Lỗi khi tải bình luận: $e';
          ratingStats = {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
          averageRating = 0.0;
        });
      }
      debugPrint('Error loading comments: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserInfo() async {
    for (var comment in productComments) {
      if (!userInfo.containsKey(comment.userId)) {
        final result = await CommentService().getUserById(comment.userId);
        if (result['success'] && mounted) {
          setState(() {
            userInfo[comment.userId] = {
              'fullName':
                  result['user']['fullName'] ?? 'Người dùng chưa xác định',
              'profilePic': result['user']['profilePic'] ?? '',
            };
          });
        } else {
          userInfo[comment.userId] = {
            'fullName': 'Người dùng chưa xác định',
            'profilePic': '',
          };
        }
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_commentError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          _commentError!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (productComments.isEmpty &&
        ratingStats.values.every((count) => count == 0)) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          'Chưa có bình luận nào cho sản phẩm này',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final totalRatings = ratingStats.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );
    final maxBarWidth = MediaQuery.of(context).size.width * 0.4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đánh giá và nhận xét của người mua hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating.floor()
                              ? Icons.star
                              : index < averageRating
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '($totalRatings đánh giá)',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rating = 5 - index;
                    final count = ratingStats[rating.toString()] ?? 0;
                    final fillWidth =
                        totalRatings > 0
                            ? (count / totalRatings) * maxBarWidth
                            : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text(
                              '$rating',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            children: [
                              Container(
                                width: maxBarWidth,
                                height: 8,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                width: fillWidth,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            count > 0 ? '($count)' : '(0)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...productComments.map(
            (comment) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Ảnh đại diện bo tròn
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            userInfo[comment.userId]?['profilePic'] != null &&
                                    userInfo[comment.userId]!['profilePic']!
                                        .isNotEmpty
                                ? NetworkImage(
                                  userInfo[comment.userId]!['profilePic']!,
                                )
                                : AssetImage('user.png') as ImageProvider,
                        backgroundColor: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      // Tên người dùng
                      Text(
                        userInfo[comment.userId]?['fullName'] ??
                            'Người dùng chưa xác định',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Ngôi sao
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < comment.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(comment.comment, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(comment.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
