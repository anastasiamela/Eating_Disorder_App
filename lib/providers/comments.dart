import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String userName;
  final String userPhoto;
  final String comment;
  final DateTime date;

  Comment({
    @required this.userId,
    @required this.userName,
    @required this.userPhoto,
    @required this.comment,
    @required this.date,
  });
}

Stream<List<Comment>> getCommentsList(String logId) {
  return FirebaseFirestore.instance
      .collection('logs')
      .doc(logId)
      .collection('comments')
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapShot) => snapShot.docs
          .map((document) => Comment(
              userId: document.data()['userId'],
              userName: document.data()['userName'],
              userPhoto: document.data()['userPhoto'],
              comment: document.data()['comment'],
              date: DateTime.parse(document.data()['date'])))
          .toList());
}

Future<void> addComment(Comment commentInput, String logId) async {
  try {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(logId)
        .collection('comments')
        .add({
      'userId': commentInput.userId,
      'userName': commentInput.userName,
      'userPhoto': commentInput.userPhoto,
      'comment': commentInput.comment,
      'date': commentInput.date.toIso8601String(),
      'createdAt': Timestamp.fromDate(commentInput.date),
    });
  } catch (error) {
    print(error);
    throw error;
  }
}
