import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/models/look.dart';
import 'package:getoutfit_stylist/widgets/custom_image.dart';

class LookTile extends StatelessWidget {
  final Look look;

  LookTile(this.look);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: cachedNetworkImage(look.mediaUrl),
      onTap: () => print('Show the look'),
    );
  }
}