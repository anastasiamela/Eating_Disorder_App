import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/comments.dart';
import '../providers/auth.dart';

class CommentsOfLogsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Comment> comments = Provider.of<List<Comment>>(context);
    String myId = Provider.of<Auth>(context).userId;
    return (comments == null || comments.isEmpty)
        ? Center(
            child: Text(
              'There are no comments.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                reverse: true,
                itemCount: comments.length,
                itemBuilder: (_, i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            comments[i].userPhoto,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: (comments[i].userId == myId)
                                ? Theme.of(context).accentColor.withOpacity(0.3)
                                : Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 60,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Row(
                                  children: [
                                    (comments[i].userId == myId)
                                        ? Text(
                                            'Me: ',
                                            style: TextStyle(
                                              color:
                                                  (comments[i].userId == myId)
                                                      ? Colors.black54
                                                      : Colors.white54,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                            '${comments[i].userName}: ',
                                            style: TextStyle(
                                              color:
                                                  (comments[i].userId == myId)
                                                      ? Colors.black54
                                                      : Colors.white54,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16,
                                            ),
                                          ),
                                    Expanded(
                                      child: Text(
                                        comments[i].comment,
                                        style: TextStyle(
                                          color: (comments[i].userId == myId)
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, y')
                                    .add_jm()
                                    .format(comments[i].date),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: (comments[i].userId == myId)
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
  }
}
