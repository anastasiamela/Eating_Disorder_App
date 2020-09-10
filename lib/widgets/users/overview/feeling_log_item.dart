import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/feelings.dart';
import '../../../providers/auth.dart';

class FeelingLogItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final feeling = Provider.of<Feeling>(context, listen: false);
    final time = DateFormat.jm().format(feeling.date);
    List<String> moodsEmojis;
    final authData = Provider.of<Auth>(context, listen: false);
    return Dismissible(
      key: ValueKey(feeling.id),
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
              'Do you want to remove the feeling log?',
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
          await Provider.of<Feelings>(context, listen: false)
              .deleteFeeling(feeling.id, authData.userId);
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
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          child: Icon(
            Icons.face,
            size: 40,
          ), //feedback, lightbulb_outline
          backgroundColor: Colors.transparent,
        ),
        title: Text('$time  Feelings'),
        subtitle: Text(feeling.thoughts),
        trailing: Consumer<Feeling>(
          builder: (ctx, feeling, _) => IconButton(
            icon: Icon(
              feeling.isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 30.0,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              feeling.toggleFavoriteStatus(
                authData.userId,
              );
            },
          ),
        ),
      ),
    );
  }
}
