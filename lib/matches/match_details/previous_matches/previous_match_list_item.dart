import 'package:flutter/material.dart';
import 'package:predictions/matches/model/football_match.dart';

class PreviousMatchListItem extends StatelessWidget {
  final FootballMatch match;

  const PreviousMatchListItem({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            match.homeTeam,
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Column(
          children: <Widget>[
            Text("${match.homeFinalScore}-${match.awayFinalScore}"),
            Text(
                "${match.homeProjectedGoals} proj. ${match.awayProjectedGoals}"),
            Text("${match.homeSpiRating} SPI ${match.awaySpiRating}"),
          ],
        ),
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
}
