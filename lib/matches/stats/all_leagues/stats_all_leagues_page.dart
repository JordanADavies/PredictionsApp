import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/all_leagues/stats_all_leagues_bloc.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';

class StatsAllLeaguesPage extends StatefulWidget {
  @override
  _StatsAllLeaguesPageState createState() => _StatsAllLeaguesPageState();
}

class _StatsAllLeaguesPageState extends State<StatsAllLeaguesPage> {
  StatsAllLeaguesBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsAllLeaguesBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<PredictionStat>>>(
      stream: _statsBloc.stats.stream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<PredictionStat>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildStatsResults(snapshot.data);
      },
    );
  }

  Widget _buildStatsResults(Map<String, List<PredictionStat>> stats) {
    final sortedKeys = stats.keys.toList()..sort();
    return ListView(
      children: sortedKeys.map((key) {
        final value = stats[key];
        return Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.white.withOpacity(0.2),
              padding: EdgeInsets.all(8.0),
              child: Text(key),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: value.map(_buildStatsListItem).toList(),
            ),
          ],
        );
      }).toList(),
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
