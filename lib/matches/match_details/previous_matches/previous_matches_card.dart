import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/previous_matches/head2head/head2head_card.dart';
import 'package:predictions/matches/match_details/previous_matches/last5/last5_card.dart';
import 'package:predictions/matches/model/match.dart';

class PreviousMatchesCard extends StatelessWidget {
  final Match match;

  const PreviousMatchesCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        children: <Widget>[
          Last5Card(match: match),
          Head2HeadCard(match: match),
        ],
      ),
    );
  }
}
