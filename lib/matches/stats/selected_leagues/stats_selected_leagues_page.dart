import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';
import 'package:predictions/matches/stats/selected_leagues/stats_selected_leagues_bloc.dart';

class StatsSelectedLeaguesPage extends StatefulWidget {
  @override
  _StatsSelectedLeaguesPageState createState() =>
      _StatsSelectedLeaguesPageState();
}

class _StatsSelectedLeaguesPageState extends State<StatsSelectedLeaguesPage> {
  StatsSelectedLeaguesBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsSelectedLeaguesBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PredictionStat>>(
      stream: _statsBloc.stats.stream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PredictionStat>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildStatsResults(snapshot.data);
      },
    );
  }

  Widget _buildStatsResults(List<PredictionStat> stats) {
    return ListView(
      children: stats.map(_buildStatsListItem).toList(),
    );
  }

  Widget _buildStatsListItem(PredictionStat stat) {
    return ListTile(
      contentPadding: EdgeInsets.all(12.0),
      title: Text(
        stat.type,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        ),
      ),
      trailing: Text(
        "${stat.percentage.toStringAsFixed(2)}%",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(stat.summary),
    );
  }
}
