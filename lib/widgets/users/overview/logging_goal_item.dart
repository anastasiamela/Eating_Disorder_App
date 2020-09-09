import 'package:flutter/material.dart';

class LoggingGoalItem extends StatelessWidget {
  final DateTime date;
  final int mainMeals;
  final int snacks;
  final int settingsMainMeals;
  final int settingsSnacks;

  LoggingGoalItem(
      {this.date,
      this.mainMeals,
      this.snacks,
      this.settingsMainMeals,
      this.settingsSnacks});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              //width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                border: Border.all(
                  color: Theme.of(context).accentColor,
                ),
                //borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${date.day}. ${date.month}. ${date.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          _buildRow(mainMeals, settingsMainMeals, 'Main meals', context),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          _buildRow(snacks, settingsSnacks, 'Snacks', context),
        ],
      ),
    );
  }

  Widget _buildRow(
      int myNumber, int settingsNumber, String title, BuildContext ctx) {
    return Container(
      //width: 120,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            Row(
              children: <Widget>[
                if (myNumber >= settingsNumber)
                  for (var i = 0; i < settingsNumber; i++)
                    Icon(
                      Icons.star,
                      color: Theme.of(ctx).accentColor,
                    ),
                if (myNumber > settingsNumber)
                  Text(
                    '+ ${myNumber - settingsNumber}',
                    style: TextStyle(
                      color: Colors.red[900],
                    ),
                  ),
                if (myNumber < settingsNumber)
                  for (var i = 0; i < settingsNumber; i++)
                    (i >= myNumber)
                        ? Icon(
                            Icons.star_border,
                            color: Theme.of(ctx).accentColor,
                          )
                        : Icon(
                            Icons.star,
                            color: Theme.of(ctx).accentColor,
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
