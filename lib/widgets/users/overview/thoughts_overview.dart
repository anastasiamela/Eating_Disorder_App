import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../providers/thoughts.dart';

import './thought_item.dart';

class ThoughtsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thoughtsData = Provider.of<Thoughts>(context);
    List<Thought> thoughts = thoughtsData.thoughts;
    return (thoughts.isEmpty)
        ? Center(
            child: Text(
              'There are no thoughts!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          )
        : StickyGroupedListView<Thought, DateTime>(
            elements: thoughts,
            groupBy: (Thought obj) => DateTime(
              obj.date.year,
              obj.date.month,
              obj.date.day,
            ),
            groupSeparatorBuilder: (Thought obj) => Container(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${obj.date.day}. ${obj.date.month}. ${obj.date.year}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (_, Thought thought) => ChangeNotifierProvider.value(
              value: thought,
              child: ThoughtItem(),
            ),
            order: StickyGroupedListOrder.DESC,
          );
  }
}
