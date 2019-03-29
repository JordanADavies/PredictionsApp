import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/prematch_card.dart';
import 'package:predictions/matches/match_details/previous_matches/previous_matches_card.dart';

class MatchDetailsPage extends StatelessWidget {
  final FootballMatch match;

  const MatchDetailsPage({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(match.date),
            Text(
              match.league,
              style:
                  Theme.of(context).textTheme.headline.copyWith(fontSize: 16.0),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            height: 120.0,
          ),
          _buildMatchDetails(context),
        ],
      ),
    );
  }

  Widget _buildMatchDetails(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildScoreCard(context),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: PrematchCard(match: match),
        ),
        PreviousMatchesCard(match: match),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.15),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Column(
          children: <Widget>[
            _buildFinalScores(context),
            SizedBox(height: 4.0),
            _buildExpectedGoals(context),
            SizedBox(height: 16.0),
            _buildTeamNames(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalScores(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeFinalScore ?? "-"}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display3,
          ),
        ),
        Text("FT"),
        Expanded(
          child: Text(
            "${match.awayFinalScore ?? "-"}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display3,
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedGoals(BuildContext context) {
    if (match.homeExpectedGoals == null || match.awayExpectedGoals == null) {
      return SizedBox();
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeExpectedGoals}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text("xG", style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            "${match.awayExpectedGoals}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamNames(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            match.homeTeam,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display2,
          ),
        ),
        Expanded(
          child: Text(
            match.awayTeam,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display2,
          ),
        ),
      ],
    );
  }
}
