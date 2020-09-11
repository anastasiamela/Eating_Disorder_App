import 'package:flutter/cupertino.dart';

class BehaviorMessagesModel {
  final String behaviorTitleForAdd;
  final String behaviorExplaining;
  final String behaviorTitleForOverview;

  BehaviorMessagesModel(
      {@required this.behaviorTitleForAdd,
      this.behaviorExplaining = '',
      @required this.behaviorTitleForOverview});
}

Map<String, BehaviorMessagesModel> myBehaviorMessages = {
  'restrict': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you restrict?',
      behaviorExplaining: 'limit the amount of food',
      behaviorTitleForOverview: ''),
  'binge': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you binge?',
      behaviorExplaining: 'eat an unusually large amount of food and experience loss of control',
      behaviorTitleForOverview: ''),
  'purge': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you purge by making yourself sick?',
      behaviorTitleForOverview: ''),
  'chewAndSpit': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you chew and spit?',
      behaviorTitleForOverview: ''),
  'swallowAndRegurgitate': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you swallow and regurtitate?',
      behaviorTitleForOverview: ''),
  'hideFood': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you hide your food?',
      behaviorTitleForOverview: ''),
  'eatInSecret': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you eat in secret?',
      behaviorTitleForOverview: ''),
  'countCalories': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you count calories?',
      behaviorTitleForOverview: ''),
  'useLaxatives': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you use laxatives since your last log?',
      behaviorTitleForOverview: ''),
  'useDietPills': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you use diet pills since your last log?',
      behaviorTitleForOverview: ''),
  'drinkAlcohol': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you drink alcohol since your last log?',
      behaviorTitleForOverview: ''),
  'weigh': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you weigh yourself?',
      behaviorTitleForOverview: ''),
  'bodyCheck': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you check your body since your last log?',
      behaviorTitleForOverview: ''),
  'exercise': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Have you exercised since your last log?',
      behaviorTitleForOverview: ''),
};

String getBehaviorMessageAddTitle(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorTitleForAdd;
  else
    return '';
}

String getBehaviorMessageOverviewTitle(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorTitleForOverview;
  else
    return '';
}

String getBehaviorMessageExplaining(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorExplaining;
  else
    return '';
}
