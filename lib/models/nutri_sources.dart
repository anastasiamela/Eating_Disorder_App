import 'package:flutter/material.dart';

class NutriSource {
  final String title;
  final String benefits;
  final List<String> sources;
  final String requiredIntakeMen;
  final String requiredIntakeWomen;
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
    sources: [
      'Vitamin A can be found in food derived from animals such as liver and fish oil, milk and eggs. In plants vitamin A exists as Beta-Carotene in dark green leafy and orange vegetables.'
    ],
    requiredIntakeMen: '900',
    requiredIntakeWomen: '700',
    photo: 'assets/images/vitaminA.jpg',
  ),
  NutriSource(
    title: 'Vitamin B',
    benefits:
        'Vitamin B is well known for helping your body turn the food you eat into energy. But that is not all it does. Vitamin B also helps form red blood cells and is critical for the development and function of those cells. It promotes healthy hair, skin, nails and bones, and it keeps your heart healthy.',
    sources: [
      'These vitamins can be found in meat, bananas, spinach and potatoes.'
    ],
    requiredIntakeMen: '15',
    requiredIntakeWomen: '12',
    photo: 'assets/images/vitaminB.jpg',
  ),
  NutriSource(
    title: 'Vitamin C',
    benefits:
        'This vitamin is important in the development of collagen which is the connective tissue such as bones, skin and tendons. It is also an antioxidant which protects the cells from oxidizing themselves which prevents disease.',
    sources: [
      'Lots of fresh fruit, like oranges and grapefruit, and vegetables such as peppers and broccoli at every meal are important cources of vitamin C.'
    ],
    requiredIntakeMen: '90',
    requiredIntakeWomen: '75',
    photo: 'assets/images/vitaminC.jpg',
  ),
  NutriSource(
    title: 'Vitamin D',
    benefits:
        'Vitamin D has multiple roles in the body. It assists in promoting healthy bones and teeth, supporting immune, brain, and nervous system health, regulating insulin levels and supporting diabetes management, supporting lung function and cardiovascular health and influencing the expression of genes involved in cancer development.',
    sources: [
      'Getting sufficient sunlight is the best way to help the body produce enough vitamin D. There are plentiful food sources of vitamin D: fatty fish, such as salmon, mackerel, and tuna, egg yolks, cheese, beef liver, mushrooms, fortified milk, fortified cereals and juices.'
    ],
    requiredIntakeMen: '15',
    requiredIntakeWomen: '15',
    photo: 'assets/images/vitaminD.jpg',
  ),
  NutriSource(
    title: 'Vitamin E',
    benefits:
        'Vitamin E is an important vitamin required for the proper function of many organs in the body. It is also an antioxidant. This means it helps to slow down processes that damage cells. In other words fights off free radicals which can cause premature aging, cancer heart disease and more.',
    sources: [
      'Sources of vitamin E are whet germ oil, almonds, avocado, sunflower seeds, peanuts and peanut butter, soyabean oil and spinach.'
    ],
    requiredIntakeMen: '15',
    requiredIntakeWomen: '15',
    photo: 'assets/images/vitaminE.jpeg',
  ),
  NutriSource(
    title: 'Vitamin K',
    benefits:
        'Vitamin K is an important factor in bone health and wound healing. Vitamin K is a fat-soluble vitamin that makes proteins for healthy bones and normal blood clotting.',
    sources: [
      'Dietary sources of vitamin K include green leafy vegetables — collards, green leaf lettuce, kale, mustard greens, parsley, romaine lettuce, spinach, Swiss chard and turnip greens — as well as vegetables such as broccoli, Brussels sprouts, cauliflower and cabbage.s'
    ],
    requiredIntakeMen: '15',
    requiredIntakeWomen: '15',
    photo: 'assets/images/vitaminK.jpg',
  ),
];

final List<NutriSource> _minerals = [
  NutriSource(
    benefits:
        'This vital mineral boosts bone health (prevents osteoporosis), relieves arthritis, improves dental health and relieves insomnia, menopause, premenstrual syndrome and cramps. Furthermore, it is important in preventing obesity, colon cancer, acidity, heart diseases and high blood pressure.',
    title: 'Calcium',
    sources: [
      'milk, cheese and other dairy foods',
      'Green leafy vegetables – such as curly kale, okra and spinach',
      'Soya drinks with added calcium',
      'Bread and anything made with fortified flour',
      'Fish where you eat the bones – such as sardines and pilchards'
    ],
    requiredIntakeMen: '700',
    requiredIntakeWomen: '700',
    photo: 'assets/images/calcium.jpg',
  ),
  NutriSource(
    title: 'Fiber',
    benefits:
        'A high fiber diet normalizes bowel movements, helps maintain bowel health, lowers cholesterol levels, helps control blood sugar levels, aids in achieving healthy weight and helps you live longer.',
    sources: [
      'Whole-grain products',
      'Fruits',
      'Vegetables',
      'Beans, peas and other legumes',
      'Nuts and seeds',
    ],
    requiredIntakeMen: '38',
    requiredIntakeWomen: '25',
    photo: 'assets/images/fiber.jpg',
  ),
  NutriSource(
    title: 'Folic Acid',
    benefits:
        'Vitamin B9, also known as folic acid, supports healthy cell division and promotes proper fetal growth and development to reduce the risk of birth defects.',
    sources: [
      'brocolli',
      'brussels sprouts',
      'leafy green vegetables, such as cabbage, kale, spring greens and spinach',
      'legumes, such as beans and peas',
      'citrus fruits, like oranges, grapefruit and lemons',
      'beef liver',
      'bananas',
      'avocado',
      'fortified grains'
    ],
    requiredIntakeMen: '400',
    requiredIntakeWomen: '450',
    photo: 'assets/images/folicAcid.jpg',
  ),
  NutriSource(
    title: 'Iron',
    benefits:
        'Iron makes a wide range of contributions to our health and survival. Though iron is typically linked to hemoglobin – the protein that transports oxygen around the body – it is also vital for energy production, antioxidant defense, DNA production, gene regulation, and the body’s detoxification process.',
    sources: [
      'Liver',
      'Red meat',
      'Beans, such as red kidney beans, edamame beans and chickpeas',
      'Nuts',
      'Dried fruit - such as dried apricots',
      'fortified breakfast cereals',
      'Soy bean flour'
    ],
    requiredIntakeMen: '8.7',
    requiredIntakeWomen: '14.8',
    photo: 'assets/images/iron.jpg',
  ),
  NutriSource(
    title: 'Magnesium',
    benefits:
        'Magnesium is vital for many bodily functions. Getting enough of this mineral can help prevent or treat chronic diseases, including Alzheimer’s disease, type 2 diabetes, cardiovascular disease, and migraine headaches.',
    sources: [
      'Fatty Fish, such as salmon, mackerel and halibut'
          'Green leafy vegetables, such as spinach',
      'Legumes',
      'Nuts and seeds',
      'Whole grains',
      'Tofu',
    ],
    requiredIntakeMen: '400',
    requiredIntakeWomen: '300',
    photo: 'assets/images/magnesium.jpg',
  ),
  NutriSource(
    title: 'Phosphorus',
    benefits:
        'You need phosphorus  to keep your bones strong and healthy, help make energy and move your muscles. In addition, phosphorus helps to build strong teeth, boost brain function, correct sexual weakness and optimize body metabolism.',
    sources: [
      'Meat, such as chicken, pork, turkey, organ meats (liver, brain)',
      'Seafood',
      'Dairy products',
      'Nuts',
      'Whole grains, including wheat, oats and rice',
      'Beans and lentils'
    ],
    requiredIntakeMen: '700',
    requiredIntakeWomen: '700',
    photo: 'assets/images/phosphorus.jpg',
  ),
  NutriSource(
    title: 'Potassium',
    benefits:
        'Potassium is a mineral found in the foods you eat. It’s also an electrolyte. Electrolytes conduct electrical impulses throughout the body. They assist in a range of essential body functions, including: blood pressure, normal water balance, muscle contractions, nerve impulses, digestion, heart rhythm and pH balance.',
    sources: [
      'Fruits, such as apricots, bananas, kiwi, oranges, and pineapples',
      'Vegetables, such as leafy greens, carrots, and potatoes',
      'Lean meats',
      'Whole grains',
      'Beans and nuts'
    ],
    requiredIntakeMen: '4700',
    requiredIntakeWomen: '4700',
    photo: 'assets/images/potassium.jpg',
  ),
  NutriSource(
    title: 'Zinc',
    benefits:
        'It’s required for the functions of over 300 enzymes and involved in many important processes in your body. It metabolizes nutrients, maintains your immune system and grows and repairs body tissues. Your body doesn’t store zinc, so you need to eat enough every day to ensure you’re meeting your daily requirements.',
    sources: [
      'Meat (red meat is a particularly great source)',
      'Shelfish',
      'Legumes, like hickpeas, lentils and beans',
      'Nuts and seeds',
      'Dairy foods',
      'Eggs',
      'Whole grains, like wheat, quinoa, rice and oats',
      'dark chocolate',
    ],
    requiredIntakeMen: '11',
    requiredIntakeWomen: '8',
    photo: 'assets/images/zinc.jpg',
  ),
];

List<NutriSource> get vitamins => [..._vitamins];

List<NutriSource> get minerals => [..._minerals];
