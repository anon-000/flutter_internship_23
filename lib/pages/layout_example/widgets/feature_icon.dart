import 'package:flutter/material.dart';

///
/// Created by Auro on 14/10/23 at 10:40 PM
///

class FeatureIcon extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const FeatureIcon(
      {Key? key, this.title = '', this.description = '', this.icon = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            icon,
            // height: 50,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
