import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/thoughts.dart';
import '../../../providers/auth.dart';

import '../../../screens/users/logs_screens/thought_log_detail_screen.dart';

class ThoughtItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final thought = Provider.of<Thought>(context, listen: false);
    final time = DateFormat.jm().format(thought.date);
    final authData = Provider.of<Auth>(context, listen: false);
    return Dismissible(
      key: ValueKey(thought.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the thought?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        try {
          await Provider.of<Thoughts>(context, listen: false)
              .deleteThought(thought.id, authData.userId);
        } catch (error) {
          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                'Deleting failed!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            child: Icon(
              Icons.forum,
              size: 40,
            ), //feedback, lightbulb_outline
            backgroundColor: Colors.transparent,
          ),
          title: Text('$time  Thoughts'),
          subtitle: Text(thought.thought),
          trailing: Consumer<Thought>(
            builder: (ctx, thought, _) => IconButton(
              icon: Icon(
                thought.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 30.0,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                thought.toggleFavoriteStatus(
                  authData.userId,
                );
              },
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ThoughtLogDetailScreen.routeName,
              arguments: thought.id,
            );
          },
        ),
      ),
    );
  }
}
