import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/behaviors.dart';
import '../../../providers/auth.dart';

import '../../../screens/users/logs_screens/behavior_log_detail_screen.dart';

class BehaviorLogItem extends StatelessWidget {
  final String subtitleType;

  BehaviorLogItem(this.subtitleType);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final behavior = Provider.of<Behavior>(context, listen: false);
    final behaviorsNumber = behavior.behaviorsListLenght;
    final time = DateFormat.jm().format(behavior.date);
    final authData = Provider.of<Auth>(context, listen: false);
    String subtitleText = '';
    if (subtitleType == 'Thoughts') {
      subtitleText = 'Thoughts: ${behavior.thoughts}';
    } else if (subtitleType == 'Coping Skills') {
      subtitleText = 'Use of coping skill.';
    } 
    else {
      if (behaviorsNumber == 0) {
        subtitleText = 'Disordered behaviors: none';
      } else {
        subtitleText = 'Disordered behaviors:  $behaviorsNumber';
      }
    }
    return Dismissible(
      key: ValueKey(behavior.id),
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
              'Do you want to remove the behavior log?',
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
          await Provider.of<Behaviors>(context, listen: false)
              .deleteBehavior(behavior.id, authData.userId);
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
              Icons.face,
              size: 40,
            ),
            backgroundColor: Colors.transparent,
          ),
          title: Text('$time  Behaviors'),
          subtitle: Text(subtitleText),
          trailing: Consumer<Behavior>(
            builder: (ctx, behavior, _) => IconButton(
              icon: Icon(
                behavior.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 30.0,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                behavior.toggleFavoriteStatus(
                  authData.userId,
                );
              },
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              BehaviorLogDetailScreen.routeName,
              arguments: behavior.id,
            );
          },
        ),
      ),
    );
  }
}
