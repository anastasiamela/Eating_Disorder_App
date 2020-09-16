import 'package:flutter/cupertino.dart';

class BehaviorMessagesModel {
  final String behaviorTitleForAdd;
  final String behaviorExplaining;
  final String behaviorTitleForOverview;
  final String behaviorLongExplaining;

  BehaviorMessagesModel(
      {@required this.behaviorTitleForAdd,
      this.behaviorExplaining = '',
      @required this.behaviorTitleForOverview,
      this.behaviorLongExplaining = ''});
}

Map<String, BehaviorMessagesModel> myBehaviorMessages = {
  'restrict': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you restrict?',
    behaviorExplaining: 'limit the amount of food',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Restricting involves limiting food intake or starving yourself. This may include eating as little as possible or nothing, allowing only a certain number of calories per day, or only certain safe foods.',
  ),
  'binge': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you binge?',
    behaviorExplaining:
        'eat an unusually large amount of food and experience loss of control',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Binging involves eating large quantities of food in a short period of time. A binge can consist of almost anything and is often accompanied by a sense of lost control.',
  ),
  'purge': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you purge by making yourself sick?',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Purging by making yourself sick involves force vomiting to get rid of the food you have eaten that feels as thought it was too much.',
  ),
  'chewAndSpit': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you chew and spit?',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Chewing food and spitting it out instead of swalloing. Can invoke a sense of waste and guilt, and is similar to food deprivation.',
  ),
  'swallowAndRegurgitate': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you swallow and regurtitate?',
    behaviorTitleForOverview: '',
  ),
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
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Laxatives taken to eliminate or undo food that you have eaten by stimulating the bowel, or diuretics/ water pills taken to rid the body of water. Both are dangerous and ineefective means of managing weight.',
  ),
  'useDietPills': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you use diet pills since your last log?',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Diet pills range from over the counter appetite supressants to caffeine pills, to prescribed medications. May have been taken to supress apetite or manage weight.',
  ),
  'drinkAlcohol': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you drink alcohol since your last log?',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Did you drink any type or any amount of alcohol since your last log?',
  ),
  'weigh': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you weigh yourself?',
      behaviorTitleForOverview: ''),
  'bodyAvoid': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you avoid your body since your last log?',
      behaviorTitleForOverview: ''),
  'bodyCheck': BehaviorMessagesModel(
      behaviorTitleForAdd: 'Did you check your body since your last log?',
      behaviorTitleForOverview: ''),
  'exercise': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Have you exercised since your last log?',
    behaviorTitleForOverview: '',
    behaviorLongExplaining:
        'Exercise includes everything from walking to moderate or vigorous physical activities.',
  ),
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
