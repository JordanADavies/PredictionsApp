import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';

class PreviousMatchListItem extends StatelessWidget {
  final FootballMatch match;

  const PreviousMatchListItem({Key key, @required this.match})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildScoreRow(),
          _buildProjectGoalsRow(),
          _buildSpiRatingRow(),
          _buildImportanceRow(),
        ],
      ),
    );
  }

  Widget _buildScoreRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            match.homeTeam,
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Text("${match.homeFinalScore}-${match.awayFinalScore}"),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            match.awayTeam,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectGoalsRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeProjectedGoals}",
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Text("proj."),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awayProjectedGoals}",
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildSpiRatingRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeSpiRating}",
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Text("SPI"),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awaySpiRating}",
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildImportanceRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeImportance}",
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Text("imp."),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awayImportance}",
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
