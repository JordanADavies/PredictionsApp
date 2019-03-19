import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/head2head/head2head_card.dart';
import 'package:predictions/matches/match_details/last5/last5_card.dart';
import 'package:predictions/matches/match_details/postmatch_card.dart';
import 'package:predictions/matches/match_details/prematch_card.dart';
import 'package:predictions/matches/model/match.dart';

class MatchDetailsPage extends StatelessWidget {
  final Match match;

  const MatchDetailsPage({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Details"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildMatchCard(context),
            PostmatchCard(match: match),
            PrematchCard(match: match),
            Last5Card(match: match),
            Head2HeadCard(match: match),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Theme.of(context).secondaryHeaderColor,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Text(
                match.homeTeam,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              "vs",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                match.awayTeam,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}
