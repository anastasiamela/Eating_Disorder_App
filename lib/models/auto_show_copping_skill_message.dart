Map<String, String> autoShowTitleForAddScreen = {
  'restrict': 'When restricted',
  'binge': 'When binged',
  'purge': 'When purged',
  'exerciseGrade': 'Urge to exercise above moderate',
  'Anxious': 'Feeling Anxious',
  'Guilty': 'Feeling Guilty',
  'Angry': 'Feeling Angry',
  'Shame': 'Feeling Shame',
  'Sad': 'Feeling Sad',
  'Intrusive Food Thoughts': 'Having intrusive food thoughts',
  'OverallFeeling': 'Overall feeling under moderate'
};

String getTitle(String input) {
  final result = autoShowTitleForAddScreen[input];
  if (result != null)
    return result;
  else
    return '';
}
