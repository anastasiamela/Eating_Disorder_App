import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/comments.dart';

import '../widgets/comments_of_logs_list.dart';
import '../widgets/new_comment_for_log.dart';

class CommentsOfLogsScreen extends StatelessWidget {
  static const routeName = '/comments-of-logs';
  @override
  Widget build(BuildContext context) {
    final logId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments of log'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamProvider(
            create: (BuildContext context) => getCommentsList(logId),
            child: CommentsOfLogsList(),
          ),
          NewCommentForLog(logId),
        ],
      ),
    );
  }
}
