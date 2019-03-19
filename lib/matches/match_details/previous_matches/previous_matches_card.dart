import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/previous_matches/head2head/head2head_card.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_away/last5_away_card.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_home/last5_home_card.dart';
import 'package:predictions/matches/model/football_match.dart';

class PreviousMatchesCard extends StatelessWidget {
  final FootballMatch match;

  const PreviousMatchesCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        children: <Widget>[
          Last5HomeCard(match: match),
          Last5AwayCard(match: match),
          Head2HeadCard(match: match),
        ],
      ),
    );
  }
}
