import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/drawer_menu.dart';
import 'package:predictions/matches/match_details/match_details_page.dart';
import 'package:predictions/prediction_tracking/prediction_tracking_bloc.dart';

class PredictionTrackingPage extends StatefulWidget {
  @override
  _PredictionTrackingPageState createState() => _PredictionTrackingPageState();
}

class _PredictionTrackingPageState extends State<PredictionTrackingPage> {
  PredictionTrackingBloc trackingBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchesBloc = MatchesProvider.of(context);
    trackingBloc = PredictionTrackingBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction tracking"),
        elevation: 0.0,
      ),
      drawer: DrawerMenu(),
      body: _buildPredictionTrackingPage(context),
    );
  }

  Widget _buildPredictionTrackingPage(BuildContext context) {
    return StreamBuilder<PredictionTracking>(
      stream: trackingBloc.trackedMatches,
      builder:
          (BuildContext context, AsyncSnapshot<PredictionTracking> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                key: PageStorageKey("Predictions"),
                children: snapshot.data.matches
                    .map((m) => _MatchListItem(
                          match: m,
                          correctlyPredicted: snapshot
                              .data.correctlyPredictedMatches
                              .contains(m),
                        ))
                    .toList(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${snapshot.data.percentageCorrect.toStringAsFixed(2)}% correct",
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MatchListItem extends StatelessWidget {
  final FootballMatch match;
  final bool correctlyPredicted;

  const _MatchListItem(
      {Key key, @required this.match, @required this.correctlyPredicted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          correctlyPredicted ? Colors.green : Theme.of(context).backgroundColor,
      child: ListTile(
        title: Text("${match.homeTeam} vs ${match.awayTeam}"),
        trailing: _buildTrailing(),
        onTap: () => _showMatchDetails(context),
      ),
    );
  }

  Widget _buildTrailing() {
    return match.hasBeenPlayed()
        ? Text("${match.homeFinalScore}-${match.awayFinalScore}")
        : SizedBox();
  }

  void _showMatchDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MatchDetailsPage(match: match),
      ),
    );
  }
}
