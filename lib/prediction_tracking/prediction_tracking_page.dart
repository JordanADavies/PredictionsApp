import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/drawer_menu.dart';
import 'package:predictions/matches/match_details/match_details_page.dart';
import 'package:predictions/prediction_tracking/prediction_tracking_bloc.dart';

class PredictionTrackingPage extends StatefulWidget {
  final String title;
  final PredictionTrackingBloc predictionBloc;

  const PredictionTrackingPage(
      {Key key, @required this.title, @required this.predictionBloc})
      : super(key: key);

  @override
  _PredictionTrackingPageState createState() => _PredictionTrackingPageState();
}

class _PredictionTrackingPageState extends State<PredictionTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.0,
      ),
      drawer: DrawerMenu(),
      body: _buildPredictionTrackingPage(context),
    );
  }

  Widget _buildPredictionTrackingPage(BuildContext context) {
    return StreamBuilder<PredictionTracking>(
      stream: widget.predictionBloc.predictionTracking,
      builder:
          (BuildContext context, AsyncSnapshot<PredictionTracking> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final predictionTracking = snapshot.data;
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                key: PageStorageKey("Predictions"),
                children: predictionTracking.predictedMatches
                    .map((m) => _MatchListItem(
                          match: m,
                          correctlyPredicted: predictionTracking
                              .predictedCorrectlyMatches
                              .contains(m),
                        ))
                    .toList(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Text(
                        "${predictionTracking.percentageCorrect.toStringAsFixed(2)}% correctly predicted."),
                    SizedBox(height: 8.0),
                    Text(predictionTracking.summary),
                  ],
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
        subtitle: Text(match.date),
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
