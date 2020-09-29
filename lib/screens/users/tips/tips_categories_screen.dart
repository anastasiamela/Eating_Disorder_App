import 'package:flutter/material.dart';

import './tips_one_category_screen.dart';
import 'nutri_sources_categories_screen.dart';

import '../../../widgets/users/app_drawer.dart';

class TipsCategoriesScreen extends StatelessWidget {
  static const routeName = '/tips-categories-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'s Get Educated'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
        child: ListView(
          children: [
            Card(
              color: Theme.of(context).primaryColor,
              shadowColor: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(
                  'Health Tips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[50],
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      TipsOneCategoryScreen.routeName,
                      arguments: 'health');
                },
              ),
            ),
            Divider(),
            Card(
              color: Theme.of(context).primaryColor,
              shadowColor: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(
                  'Nutrition Tips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[50],
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      TipsOneCategoryScreen.routeName,
                      arguments: 'nutrition');
                },
              ),
            ),
            Divider(),
            Card(
              color: Theme.of(context).primaryColor,
              shadowColor: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(
                  'Vitamin Sources',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[50],
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      NutriSourcesCategoriesScreen.routeName,
                      arguments: 'vitamins');
                },
              ),
            ),
            Divider(),
            Card(
              color: Theme.of(context).primaryColor,
              shadowColor: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(
                  'Mineral Sources',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[50],
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      NutriSourcesCategoriesScreen.routeName,
                      arguments: 'minerals');
                },
              ),
            ),
            Divider(),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
