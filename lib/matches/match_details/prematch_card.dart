import 'package:flutter/material.dart';
import 'package:predictions/matches/model/football_match.dart';

class PrematchCard extends StatelessWidget {
  final FootballMatch match;

  const PrematchCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Pre match",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Material(
          type: MaterialType.card,
          child: Column(
            children: <Widget>[
              _buildProjectedGoalsCard(),
              _buildRatingCard(),
              _buildImportanceCard(),
              _buildProbabilityCard(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildProjectedGoalsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeProjectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("proj."),
          Expanded(
            child: Text(
              "${match.awayProjectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeSpiRating}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("SPI"),
          Expanded(
            child: Text(
              "${match.awaySpiRating}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportanceCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeImportance}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("imp."),
          Expanded(
            child: Text(
              "${match.awayImportance}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("${match.homeWinProbability}%"),
          Text("${match.drawProbability}%"),
          Text("${match.awayWinProbability}%"),
        ],
      ),
    );
  }
}
