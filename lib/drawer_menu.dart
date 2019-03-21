import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/matches_page.dart';
import 'package:predictions/prediction_tracking/prediction_tracking_bloc.dart';
import 'package:predictions/prediction_tracking/prediction_tracking_page.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
          _buildU3ListItem(context),
          _buildBttsNoListItem(context),
        ],
      ),
    );
  }

  Widget _buildU3ListItem(BuildContext context) {
    return ListTile(
      title: Text("U2.5 Predictions"),
      onTap: () {
        final pageRoute = MaterialPageRoute(
          builder: (context) {
            final matchesBloc = MatchesProvider.of(context);
            final predictionBloc =
                Under3PredictionTrackingBloc(matchesBloc: matchesBloc);
            return PredictionTrackingPage(
              title: "U2.5 Predictions",
              predictionBloc: predictionBloc,
            );
          },
        );
        Navigator.of(context).pushReplacement(pageRoute);
      },
    );
  }

  Widget _buildBttsNoListItem(BuildContext context) {
    return ListTile(
      title: Text("BTTS No Predictions"),
      onTap: () {
        final pageRoute = MaterialPageRoute(
          builder: (context) {
            final matchesBloc = MatchesProvider.of(context);
            final predictionBloc = BothTeamToScoreNoPredictionTrackingBloc(
                matchesBloc: matchesBloc);
            return PredictionTrackingPage(
              title: "BTTS No Predictions",
              predictionBloc: predictionBloc,
            );
          },
        );
        Navigator.of(context).pushReplacement(pageRoute);
      },
    );
  }
}
