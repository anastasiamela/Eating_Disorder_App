import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/comments.dart';
import '../providers/auth.dart';

class NewCommentForLog extends StatefulWidget {
  final logId;
  NewCommentForLog(this.logId);
  @override
  _NewCommentForLogState createState() => _NewCommentForLogState();
}

class _NewCommentForLogState extends State<NewCommentForLog> {
  final _controller = new TextEditingController();
  var _enteredComment = '';

  void _sendComment() async {
    FocusScope.of(context).unfocus();
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final userName = Provider.of<Auth>(context, listen: false).userName;
    final userPhoto = Provider.of<Auth>(context, listen: false).userPhoto;
    final date = DateTime.now();
    final newComment = Comment(
      userName: userName,
      userId: userId,
      userPhoto: userPhoto,
      comment: _enteredComment.trim(),
      date: date,
    );
    await addComment(newComment, widget.logId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Write a comment...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredComment = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredComment.trim().isEmpty ? null : _sendComment,
          )
        ],
      ),
    );
  }
}
