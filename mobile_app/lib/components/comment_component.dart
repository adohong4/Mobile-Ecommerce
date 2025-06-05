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
  bool _isLoadingComments = false;
  String? _commentError;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    if (!mounted) return;

    setState(() {
      _isLoadingComments = true;
      _commentError = null;
    });

    try {
      final result = await CommentService().getCommentsByProduct(
        widget.productId,
      );

      if (mounted) {
        setState(() {
          productComments = result['success'] ? result['comments'] : [];
          _commentError = result['success'] ? null : result['message'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _commentError = 'Lỗi khi tải bình luận';
        });
      }
      debugPrint('Error loading comments: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
        });
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Do not display if no comments, still loading, or error occurred
    if (_isLoadingComments ||
        _commentError != null ||
        productComments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bình luận sản phẩm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
                      Text(
                        comment.userId ?? 'Người dùng',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 4),
                  Text(comment.comment),
                  const SizedBox(height: 2),
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
