class POTW {
  final String postID;
  final String date;

  POTW({required this.postID, required this.date});

  Map<String, dynamic> toJson() => {
        "postID": postID,
        "date": date,
      };
}
