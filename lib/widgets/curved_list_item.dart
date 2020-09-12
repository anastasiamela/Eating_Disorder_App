import 'package:flutter/material.dart';

class CurvedListItem extends StatelessWidget {
  CurvedListItem({
    this.title,
    this.color,
    this.nextColor,
    this.icon,
  });

  final String title;
  final Color color;
  final Color nextColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      color: nextColor,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
            bottomRight: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
        padding: const EdgeInsets.only(
          right: 20,
          top: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  icon,
                  color: Colors.teal[900],
                  size: 30,
                ),
                SizedBox(
                  width: 70,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.teal[900],
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.teal[900],
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
