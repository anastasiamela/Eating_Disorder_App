import 'package:flutter/material.dart';

class NutriSource {
  final String title;
  final String benefits;
  final String sources;
  final int requiredIntakeMen;
  final int requiredIntakeWomen;
  final String photoUrl;

  NutriSource({
    @required this.title,
    @required this.benefits,
    @required this.sources,
    @required this.requiredIntakeMen,
    @required this.requiredIntakeWomen,
    @required this.photoUrl,
  });
}

final _vitamins = [
  NutriSource(
      title: 'Vitamin A',
      benefits:
          'Important for eyesight, skin health, the immune system, body and bone growth, and development of cells.',
      sources:
          'Vitamin A can be found in food derived from animals such as liver and fish oil, milk and eggs. In plants vitamin A exists as Beta-Carotene in dark green leafy and orange vegetables.',
      requiredIntakeMen: 900,
      requiredIntakeWomen: 700,
      photoUrl:
          'https://i.pinimg.com/736x/4a/81/65/4a816553c9ff0e406c2b6a44ff256729.jpg')
];

final List<NutriSource> _minerals = [];

List<NutriSource> get vitamins => [..._vitamins];

List<NutriSource> get minerals => [..._minerals];


