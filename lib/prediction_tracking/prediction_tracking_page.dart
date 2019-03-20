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
  String filterType = FilterType.WinLoseDraw;

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
      body: Column(
        children: <Widget>[
          _buildFilter(),
          Expanded(child: _buildPredictionTrackingPage(context)),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final filters = FilterType.values;
    return Wrap(
      spacing: 8.0,
      children: filters.map(_buildFilterChip).toList(),
    );
  }

  Widget _buildFilterChip(String filter) {
    return ChoiceChip(
      selected: filterType == filter,
      label: Text(filter),
      onSelected: (bool selected) {
        if (selected) {
          trackingBloc.trackingType.add(filter);
        }

        setState(() {
          filterType = selected ? filter : null;
        });
      },
    );
  }

  Widget _buildPredictionTrackingPage(BuildContext context) {
    return StreamBuilder<List<FootballMatch>>(
      stream: trackingBloc.trackedMatches,
      builder:
          (BuildContext context, AsyncSnapshot<List<FootballMatch>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children:
                    snapshot.data.map((m) => _MatchListItem(match: m)).toList(),
              ),
            ),
            _buildTrackingTotals(),
          ],
        );
      },
    );
  }

  Widget _buildTrackingTotals() {
    return StreamBuilder<String>(
      stream: trackingBloc.trackedTotals,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final text = snapshot.connectionState == ConnectionState.waiting
            ? "..."
            : snapshot.data;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: Theme.of(context).textTheme.subhead),
          ),
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
