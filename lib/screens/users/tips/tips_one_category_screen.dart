import 'package:flutter/material.dart';

import '../../../models/tips_model.dart';

class TipsOneCategoryScreen extends StatelessWidget {
  static const routeName = '/tips-one-category-screen';
  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments as String;
    final list = (type == 'health') ? healthTips : nutritionTips;
    return Scaffold(
      appBar: AppBar(
        title:
            (type == 'health') ? Text('Health tips') : Text('Nutrition Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => Column(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        list[i].title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        list[i].description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
