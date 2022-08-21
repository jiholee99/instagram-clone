class Comment {
  final String username;
  final String uid;
  final String comment;
  final String commentId;
  final DateTime datePublished;
  final likes;

  Comment({
    required this.username,
    required this.uid,
    required this.comment,
    required this.commentId,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'comment': comment,
      'commentId': commentId,
      'datePublished': datePublished,
      'likes': likes,
    };
  }
}
