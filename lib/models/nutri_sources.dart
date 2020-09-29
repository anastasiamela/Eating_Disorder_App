import 'package:flutter/material.dart';

class NutriSource {
  final String title;
  final String benefits;
  final String sources;
  final int requiredIntakeMen;
  final int requiredIntakeWomen;
  final String photo;

  NutriSource({
    @required this.title,
    @required this.benefits,
    @required this.sources,
    @required this.requiredIntakeMen,
    @required this.requiredIntakeWomen,
    @required this.photo,
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
    photo: 'assets/images/vitaminA.jpg',
  ),
  NutriSource(
    title: 'Vitamin B',
    benefits:
        'Vitamin B is well known for helping your body turn the food you eat into energy. But that is not all it does. Vitamin B also helps form red blood cells and is critical for the development and function of those cells. It promotes healthy hair, skin, nails and bones, and it keeps your heart healthy.',
    sources:
        'These vitamins can be found in meat, bananas, spinach and potatoes.',
    requiredIntakeMen: 15,
    requiredIntakeWomen: 12,
    photo: 'assets/images/vitaminB.jpg',
  ),
  NutriSource(
    title: 'Vitamin C',
    benefits:
        'This vitamin is important in the development of collagen which is the connective tissue such as bones, skin and tendons. It is also an antioxidant which protects the cells from oxidizing themselves which prevents disease.',
    sources:
        'Lots of fresh fruit, like oranges and grapefruit, and vegetables such as peppers and broccoli at every meal are important cources of vitamin C.',
    requiredIntakeMen: 90,
    requiredIntakeWomen: 75,
    photo: 'assets/images/vitaminC.jpg',
  ),
  NutriSource(
    title: 'Vitamin D',
    benefits:
        'Vitamin D has multiple roles in the body. It assists in promoting healthy bones and teeth, supporting immune, brain, and nervous system health, regulating insulin levels and supporting diabetes management, supporting lung function and cardiovascular health and influencing the expression of genes involved in cancer development.',
    sources:
        'Getting sufficient sunlight is the best way to help the body produce enough vitamin D. There are plentiful food sources of vitamin D: fatty fish, such as salmon, mackerel, and tuna, egg yolks, cheese, beef liver, mushrooms, fortified milk, fortified cereals and juices.',
    requiredIntakeMen: 15,
    requiredIntakeWomen: 15,
    photo: 'assets/images/vitaminD.jpg',
  ),
  NutriSource(
    title: 'Vitamin E',
    benefits:
        'Vitamin E is an important vitamin required for the proper function of many organs in the body. It is also an antioxidant. This means it helps to slow down processes that damage cells. In other words fights off free radicals which can cause premature aging, cancer heart disease and more.',
    sources:
        'Sources of vitamin E are whet germ oil, almonds, avocado, sunflower seeds, peanuts and peanut butter, soyabean oil and spinach.',
    requiredIntakeMen: 15,
    requiredIntakeWomen: 15,
    photo: 'assets/images/vitaminE.jpeg',
  ),
  NutriSource(
    title: 'Vitamin K',
    benefits:
        'Vitamin K is an important factor in bone health and wound healing. Vitamin K is a fat-soluble vitamin that makes proteins for healthy bones and normal blood clotting.',
    sources:
        'Dietary sources of vitamin K include green leafy vegetables — collards, green leaf lettuce, kale, mustard greens, parsley, romaine lettuce, spinach, Swiss chard and turnip greens — as well as vegetables such as broccoli, Brussels sprouts, cauliflower and cabbage.s',
    requiredIntakeMen: 15,
    requiredIntakeWomen: 15,
    photo: 'assets/images/vitaminK.jpg',
  ),
];

final List<NutriSource> _minerals = [];

List<NutriSource> get vitamins => [..._vitamins];

List<NutriSource> get minerals => [..._minerals];
