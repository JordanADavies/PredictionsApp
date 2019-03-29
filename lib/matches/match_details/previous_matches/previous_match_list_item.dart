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
          Text(match.date),
          SizedBox(height: 4.0),
          _buildScoreRow(context),
          _buildExpectedGoalsRow(),
          _buildProjectGoalsRow(),
          _buildSpiRatingRow(),
          _buildImportanceRow(),
        ],
      ),
    );
  }

  Widget _buildScoreRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            match.homeTeam,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "${match.homeFinalScore}-${match.awayFinalScore}",
          style: Theme.of(context).textTheme.subtitle,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            match.awayTeam,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedGoalsRow() {
    if (match.homeExpectedGoals == null || match.awayExpectedGoals == null) {
      return SizedBox();
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeExpectedGoals}",
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "xG",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awayExpectedGoals}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey),
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
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "proj.",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awayProjectedGoals}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey),
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
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "SPI",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awaySpiRating}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildImportanceRow() {
    if (match.homeImportance == null || match.awayImportance == null) {
      return SizedBox();
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${match.homeImportance}",
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          "imp.",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            "${match.awayImportance}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
