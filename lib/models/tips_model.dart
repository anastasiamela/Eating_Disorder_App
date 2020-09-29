import 'package:flutter/material.dart';

class TipsModel {
  final String title;
  final String description;
  final String type;

  TipsModel({
    @required this.title,
    @required this.description,
    @required this.type,
  });
}

List<TipsModel> _tips = [
  TipsModel(
    title: 'Eat Breakfast',
    description:
        'There is no better way to start your morning than with a healthy breakfast.',
    type: 'health',
  ),
  TipsModel(
    title: 'Make half your plate fruits and vegetables',
    description:
        'Fruits and veggies add color, flavor and texture plus vitamins, minerals and fiber to your plate.',
    type: 'health',
  ),
  TipsModel(
    title: 'Fix healthy snacks',
    description:
        'Healthy snacks can sustain your energy levelsbetween meals. Whenever possible, make your snacks combination snacks. Choose from 2 or more of the food groups: whole grains, fruits, vegetables, dairy, lean protein or nuts. Try yogurt with fruit or a small portion of nuts with an apple or banana',
    type: 'health',
  ),
  TipsModel(
    title: 'Consult an RD',
    description:
        'Registered dietitians can help you by providing sound, easy-to-follow personalized nutrition advice and put you on the path to eating well.',
    type: 'health',
  ),
  TipsModel(
    title: 'Drink plenty of water',
    description:
        'Our bodies are about 60% water - with muscle mass carrying more than fat tissue! We need to drink water to keep our body systems running smoothly, optimize metabolism, boost energy levels, and promote good digestion, just to name a few.',
    type: 'nutrition',
  ),
  TipsModel(
    title: 'Eat plenty of plants',
    description:
        'These colorful gems provide essential phytonutricients, micronutritients, vitamins, minerals, and enzymes - all of which are just as important for your health as the macronutritients we often hear about (think carbs, proteins and fabs).',
    type: 'nutrition',
  ),
  TipsModel(
    title: 'Eat mindfully',
    description:
        'Limit distractions and take time to experience eating and engage your senses. Up to 30-40% of nutrients may not be properly absorbed if you are distracted while eating. Digestion begins in the brain so by looking at, thinking about and smelling your food, you can help your body benefit from the wonderul nutrients locked away in that meal while enjoying that experience even more.',
    type: 'nutrition',
  )
];

List<TipsModel> get healthTips {
  return _tips.where((tip) => tip.type == 'health' ?? () => null).toList();
}

List<TipsModel> get nutritionTips {
  return _tips.where((tip) => tip.type == 'nutrition' ?? () => null).toList();
}
