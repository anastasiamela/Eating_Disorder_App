import 'package:flutter/material.dart';

import '../../../models/nutri_sources.dart';

class NutriSourceOneCategoryScreen extends StatelessWidget {
  static const routeName = '/nutri-source-one-category-screen';
  @override
  Widget build(BuildContext context) {
    final source = ModalRoute.of(context).settings.arguments as NutriSource;
    return Scaffold(
      appBar: AppBar(
        title: Text(source.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Benefits:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Text(
                      source.benefits,
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
    );
  }
}
