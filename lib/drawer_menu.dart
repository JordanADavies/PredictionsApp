import 'package:flutter/material.dart';
import 'package:predictions/matches/matches_page.dart';
import 'package:predictions/prediction_tracking/prediction_tracking_page.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: SizedBox(),
          ),
          ListTile(
            title: Text("Matches"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MatchesPage()));
            },
          ),
          ListTile(
            title: Text("Prediction tracking"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PredictionTrackingPage()));
            },
          ),
        ],
      ),
    );
  }
}
