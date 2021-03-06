import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_log.dart';
import '../../../providers/auth.dart';
import '../../../providers/meal_logs.dart';

import '../../../screens/users/logs_screens/meal_log_detail_screen.dart';
//import '../../../screens/users/add_input/edit_meal_log_screen.dart';

class MealLogItem extends StatelessWidget {
  final String subtitleType;

  MealLogItem(this.subtitleType);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final meal = Provider.of<MealLog>(context, listen: false);
    final time = DateFormat.jm().format(meal.date);
    final authData = Provider.of<Auth>(context, listen: false);
    String subtitleText = '';
    String subtitleText2 = '';
    // final emptyImage =
    //     'https://i1.pngguru.com/preview/658/470/455/krzp-dock-icons-v-1-2-empty-grey-empty-text-png-clipart.jpg';

    if (subtitleType == 'Thoughts') {
      subtitleText = 'Thoughts: ${meal.thoughts}';
    } else if (subtitleType == 'Feelings') {
      subtitleText = 'Overall feeling: ${meal.feelingOverall}';
      final feelingsNumber = meal.feelingsList.length;
      subtitleText2 = 'Feelings:  $feelingsNumber';
    } else if (subtitleType == 'Behaviors') {
      final behaviorsNumber = meal.behaviorsList.length;
      subtitleText = 'Disordered behaviors:  $behaviorsNumber';
    } else {
      if (meal.skip)
        subtitleText = meal.skippingReason;
      else
        subtitleText = meal.mealDescription;
    }
    return Dismissible(
      key: ValueKey(meal.id),
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
              'Do you want to remove the meal log?',
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
          await Provider.of<MealLogs>(context, listen: false)
              .deleteMealLog(meal.id, authData.userId);
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
            backgroundColor: Colors.transparent,
            backgroundImage: (meal.mealPhoto.isNotEmpty) ? NetworkImage(meal.mealPhoto) : null,
            child: (meal.mealPhoto.isNotEmpty)
                ? null
                : Icon(
                    Icons.restaurant,
                    size: 40,
                  ),
          ),
          title: (meal.skip)
              ? Text('SKIP  ${meal.mealType}')
              : Text('$time  ${meal.mealType}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!(subtitleType == 'Feelings')) Text(subtitleText),
              if (subtitleType == 'Feelings' && meal.feelingOverall.isNotEmpty)
                Text(subtitleText),
              if (subtitleType == 'Feelings' && meal.feelingsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(subtitleText2),
                ),
            ],
          ),
          trailing: Consumer<MealLog>(
            builder: (ctx, meal, _) => IconButton(
              icon: Icon(
                meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 30.0,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                meal.toggleFavoriteStatus(
                  authData.userId,
                );
              },
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              MealLogDetailScreen.routeName,
              arguments: meal.id,
            );
          },
        ),
      ),
    );
  }
}
