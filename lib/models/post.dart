class Post {
  final String username;
  final String description;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final String postPhotoUrl;
  final String profImageUrl;
  final likes;

  Post({
    required this.username,
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postPhotoUrl,
    required this.profImageUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'description': description,
      'uid': uid,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postPhotoUrl,
      'profileImageUrl': profImageUrl,
      'likes': likes,
    };
  }
}
