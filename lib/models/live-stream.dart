// ignore_for_file: public_member_api_docs, sort_constructors_first
class LiveStream {
  final String title;
  final String image;
  final String uid;
  final String userName;
  final startedAt;
  final int viewers;
  final String channelId;

  LiveStream({
    required this.title,
    required this.image,
    required this.uid,
    required this.userName,
    required this.viewers,
    required this.channelId,
    required this.startedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'uid': uid,
      'userName': userName,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      title: map['title'] as String,
      image: map['image'] as String,
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      viewers: map['viewers'] as int,
      channelId: map['channelId'] as String,
      startedAt: map['startedAt'] as String,
    );
  }
}
