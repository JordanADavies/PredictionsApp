import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';

class PostmatchCard extends StatelessWidget {
  final FootballMatch match;

  const PostmatchCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!match.hasFinalScore()) {
      return SizedBox();
    }

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Post match",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Material(
          type: MaterialType.card,
          child: Column(
            children: <Widget>[
              _buildFinalScoreCard(),
              _buildExpectedGoalsCard(),
              _buildNonShotExpectedGoalsCard(),
              _buildAdjustedScoreCard(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFinalScoreCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeFinalScore}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("FT"),
          Expanded(
            child: Text(
              "${match.awayFinalScore}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedGoalsCard() {
    if (match.homeExpectedGoals == null || match.awayExpectedGoals == null) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeExpectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("xG"),
          Expanded(
            child: Text(
              "${match.awayExpectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonShotExpectedGoalsCard() {
    if (match.homeNonShotExpectedGoals == null ||
        match.awayNonShotExpectedGoals == null) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeNonShotExpectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("NSxG"),
          Expanded(
            child: Text(
              "${match.awayNonShotExpectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustedScoreCard() {
    if (match.homeAdjustedScore == null || match.awayAdjustedScore == null) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeAdjustedScore}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("adj."),
          Expanded(
            child: Text(
              "${match.awayAdjustedScore}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
