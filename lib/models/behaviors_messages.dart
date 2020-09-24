import 'package:flutter/material.dart';

class BehaviorMessagesModel {
  final String behaviorTitleForAdd;
  final String behaviorExplaining;
  final String behaviorTitleForOverview;
  final String behaviorTitleForSettings;
  final String behaviorLongExplaining;

  BehaviorMessagesModel(
      {@required this.behaviorTitleForAdd,
      this.behaviorExplaining = '',
      @required this.behaviorTitleForOverview,
      @required this.behaviorTitleForSettings,
      this.behaviorLongExplaining = ''});
}

Map<String, BehaviorMessagesModel> myBehaviorMessages = {
  'restrict': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you restrict?',
    behaviorExplaining: 'limit the amount of food',
    behaviorTitleForOverview: 'Restricted.',
    behaviorTitleForSettings: 'Restricted',
    behaviorLongExplaining:
        'Restricting involves limiting food intake or starving yourself. This may include eating as little as possible or nothing, allowing only a certain number of calories per day, or only certain safe foods.',
  ),
  'binge': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you binge?',
    behaviorExplaining:
        'eat an unusually large amount of food and experience loss of control',
    behaviorTitleForOverview: 'Binged.',
    behaviorTitleForSettings: 'Binged',
    behaviorLongExplaining:
        'Binging involves eating large quantities of food in a short period of time. A binge can consist of almost anything and is often accompanied by a sense of lost control.',
  ),
  'purge': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you purge by making yourself sick?',
    behaviorTitleForOverview: 'Purged.',
    behaviorTitleForSettings: 'Purged',
    behaviorLongExplaining:
        'Purging by making yourself sick involves force vomiting to get rid of the food you have eaten that feels as thought it was too much.',
  ),
  'chewAndSpit': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you chew and spit?',
    behaviorTitleForOverview: 'Chewed and spat.',
    behaviorTitleForSettings: 'Chew and Spit',
    behaviorLongExplaining:
        'Chewing food and spitting it out instead of swalloing. Can invoke a sense of waste and guilt, and is similar to food deprivation.',
  ),
  'swallowAndRegurgitate': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you swallow and regurtitate?',
    behaviorTitleForOverview: 'Swallowed and regurgitated.',
    behaviorTitleForSettings: 'Swallow and Regurgitate',
  ),
  'hideFood': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you hide your food?',
    behaviorTitleForOverview: 'Hid food.',
    behaviorTitleForSettings: 'Food Hiding',
  ),
  'eatInSecret': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you eat in secret?',
    behaviorTitleForOverview: 'Ate in secret.',
    behaviorTitleForSettings: 'Eat in Secret',
  ),
  'countCalories': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you count calories?',
    behaviorTitleForOverview: 'Counted calories.',
    behaviorTitleForSettings: 'Count Calories',
  ),
  'useLaxatives': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you use laxatives since your last log?',
    behaviorTitleForOverview: 'Used laxatives.',
    behaviorTitleForSettings: 'Laxatives',
    behaviorLongExplaining:
        'Laxatives taken to eliminate or undo food that you have eaten by stimulating the bowel, or diuretics/ water pills taken to rid the body of water. Both are dangerous and ineefective means of managing weight.',
  ),
  'useDietPills': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you use diet pills since your last log?',
    behaviorTitleForOverview: 'Used diet pills.',
    behaviorTitleForSettings: 'Diet Pills',
    behaviorLongExplaining:
        'Diet pills range from over the counter appetite supressants to caffeine pills, to prescribed medications. May have been taken to supress apetite or manage weight.',
  ),
  'drinkAlcohol': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you drink alcohol since your last log?',
    behaviorTitleForOverview: 'Drank alcohol.',
    behaviorTitleForSettings: 'Drinking Alcohol',
    behaviorLongExplaining:
        'Did you drink any type or any amount of alcohol since your last log?',
  ),
  'weigh': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you weigh yourself?',
    behaviorTitleForOverview: 'Weighed myself.',
    behaviorTitleForSettings: 'Weigh Yourself',
  ),
  'bodyAvoid': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you avoid your body since your last log?',
    behaviorTitleForOverview: 'Avoided my body.',
    behaviorTitleForSettings: 'Body Avoiding',
  ),
  'bodyCheck': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Did you check your body since your last log?',
    behaviorTitleForOverview: 'Checked my body.',
    behaviorTitleForSettings: 'Body Checking',
  ),
  'exercise': BehaviorMessagesModel(
    behaviorTitleForAdd: 'Have you exercised since your last log?',
    behaviorTitleForOverview: 'Exercised.',
    behaviorTitleForSettings: 'Exercise',
    behaviorLongExplaining:
        'Exercise includes everything from walking to moderate or vigorous physical activities.',
  ),
};

String getBehaviorTitleForOverview(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorTitleForOverview;
  else
    return '';
}

String getBehaviorMessageAddTitle(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorTitleForAdd;
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

String getBehaviorTitleForSettings(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorTitleForSettings;
  else
    return '';
}

String getBehaviorLongExplaining(String input) {
  final result = myBehaviorMessages[input];
  if (result != null)
    return result.behaviorLongExplaining;
  else
    return '';
}
