import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/head2head/head2head_card.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_away/last5_away_card.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_home/last5_home_card.dart';

class PreviousMatchesCard extends StatelessWidget {
  final FootballMatch match;

  const PreviousMatchesCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: PageView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 12.0,
              ),
              child: Last5HomeCard(match: match),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 12.0,
              ),
              child: Last5AwayCard(match: match),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 12.0,
              ),
              child: Head2HeadCard(match: match),
            ),
          ],
        ),
      ),
    );
  }
}
