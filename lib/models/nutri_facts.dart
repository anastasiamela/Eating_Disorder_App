import 'package:flutter/material.dart';

class NutriFacts {
  final String title;
  final String description;

  NutriFacts({
    @required this.title,
    @required this.description,
  });
}

Map<int, NutriFacts> myNutriFacts = {
  0: NutriFacts(
    title: 'Tip',
    description:
        'hebderhyfbuirefbrhbreyfvgrhdvbchedbcbdhgvchsdg ccucwgecvef ciycbecbsuibkc hdhhfcjfj rew',
  ),
  1: NutriFacts(
    title: 'Tip 1',
    description:
        'hebderhyfbuidm;kmc     ekdcmeekd refbrhbreyfvgrhdvbchedbcbdhgvchsdg ccucwgecvef ciycbecbsuibkc hdhhfcjfj rew',
  )
};

String getTitleOfFact(int input) {
  final result = myNutriFacts[input];
  if (result != null)
    return result.title;
  else
    return '';
}

String getDescriptionOfFact(int input) {
  final result = myNutriFacts[input];
  if (result != null)
    return result.description;
  else
    return '';
}
