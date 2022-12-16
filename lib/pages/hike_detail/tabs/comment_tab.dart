import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mhike/services/auth/auth_service.dart';
import 'package:mhike/services/crud/m_hike_service.dart';
import 'package:mhike/services/crud/model/comment.dart';
import 'package:mhike/services/crud/model/hike.dart';

class CommentTab extends StatefulWidget {
  final Hike hike;
  const CommentTab({super.key, required this.hike});

  @override
  State<CommentTab> createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  late final MHikeService _mHikeService;
  late final TextEditingController _commentController;
  String get email => AuthService.firebase().currentUser!.email;

  double _hikeRating = 0;

  @override
  void initState() {
    _mHikeService = MHikeService();
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future addNewComment() async {
    final user = _mHikeService.getUser(null, email);
    // get form details
    final hikeComment = _commentController.text;
    final dateTime = DateTime.now();

    // create new comment object
    Comment newComment = Comment(
      hikeId: widget.hike.id!,
      userEmail: email,
      hikeRating: _hikeRating,
      hikeComment: hikeComment,
      dateTime: dateTime,
    );
    print(newComment.userEmail);

    // add observation
    _mHikeService.addComment(
      hike: widget.hike,
      newComment: newComment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder(
        stream: _mHikeService.allComments,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allComments = snapshot.data as List<Comment>;
                final hikeComments = allComments
                    .where(
                      (comment) => comment.hikeId == widget.hike.id,
                    )
                    .toList();
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hikeComments.length + 1,
                  separatorBuilder: (context, index) => const Divider(
                    height: 12,
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 59, 87),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    AssetImage('assets/images/pexels3.jpg'),
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Priyank Tejani',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                    height: 4,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 18,
                                    itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFF4C465),
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _hikeRating = rating;
                                      });
                                      _hikeRating = rating;
                                    },
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                    height: 12,
                                  ),
                                  TextField(
                                    controller: _commentController,
                                    keyboardType: TextInputType.text,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white12,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 20,
                                      ),
                                      hintText: 'Comment',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            Divider.createBorderSide(context),
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            Divider.createBorderSide(context),
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            Divider.createBorderSide(context),
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      filled: true,
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      addNewComment();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        56,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      backgroundColor: const Color(0xff282b41),
                                    ),
                                    child: const Text(
                                      'Comment',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    final comment = hikeComments[index - 1];
                    if (comment.hikeId == widget.hike.id) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 59, 87),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(
                                  'assets/images/pexels3.jpg',
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Priyank Tejani',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.transparent,
                                        width: 6,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          
                                          DateFormat('yyyy-MM-dd').format(comment.dateTime),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                    height: 4,
                                  ),
                                  RatingBar.builder(
                                    initialRating: comment.hikeRating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 18,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFF4C465),
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                    height: 4,
                                  ),
                                  Text(
                                    comment.hikeComment,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Comment',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
