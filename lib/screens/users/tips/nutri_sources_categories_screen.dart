import 'package:flutter/material.dart';

import 'nutri_source_one_category_screen.dart';

import '../../../models/nutri_sources.dart';

class NutriSourcesCategoriesScreen extends StatelessWidget {
  static const routeName = '/nutri-sources-categories-screen';
  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments as String;
    final list = (type == 'vitamins') ? vitamins : minerals;
    return Scaffold(
      appBar: AppBar(
        title:
            (type == 'vitamins') ? Text('Vitamins') : Text('Mineral Sources'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => Card(
            color: Theme.of(context).primaryColor,
            shadowColor: Theme.of(context).primaryColor,
            child: ListTile(
              title: Text(
                list[i].title,
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
                    NutriSourceOneCategoryScreen.routeName,
                    arguments: list[i]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
