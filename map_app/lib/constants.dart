import 'package:flutter/material.dart';

import 'model/place.dart';

Color mBackgroundColor = Color(0xFFFEFEFE);

Color mPrimaryColor = Color(0xFFf36f7c);

Color mSecondaryColor = Color(0xFFfff2f3);

const categoryList = [
  'New',
  'Popular',
  'Most viewed',
  'All places',
];

List<Place> placeList = [
  Place("Rain Forest", "Costa Rica", "assets/images/bg1.png", 240),
  Place("Lake Louise", "Canada", "assets/images/bg2.png", 200),
  Place("Plitivice Lakes", "Canada", "assets/images/bg4.png", 120),
  Place("Dubai", "UAE", "assets/images/bg3.png", 200),
  Place("Rain Forest", "Canada", "assets/images/bg6.png", 240),
  Place("Lotus Temple", "India", "assets/images/bg5.png", 150),
];