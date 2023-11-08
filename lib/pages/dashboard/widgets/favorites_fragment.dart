import 'package:flutter/material.dart';

///
/// Created by Auro on 08/11/23 at 9:49 PM
///

class FavoritesFragment extends StatefulWidget {
  const FavoritesFragment({Key? key}) : super(key: key);

  @override
  State<FavoritesFragment> createState() => _FavoritesFragmentState();
}

class _FavoritesFragmentState extends State<FavoritesFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Favorites"),
    );
  }
}
