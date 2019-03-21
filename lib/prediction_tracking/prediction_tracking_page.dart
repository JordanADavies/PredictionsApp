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
    return StreamBuilder<List<FootballMatch>>(
      stream: widget.predictionBloc.upcomingMatches,
      builder:
          (BuildContext context, AsyncSnapshot<List<FootballMatch>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          key: PageStorageKey("Predictions"),
          children: snapshot.data.map((m) => _MatchListItem(match: m)).toList(),
        );
      },
    );
  }
}

class _MatchListItem extends StatelessWidget {
  final FootballMatch match;

  const _MatchListItem({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
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
