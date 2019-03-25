import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/main.dart';
import 'package:predictions/matches/stats/stats_bloc.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stats"),
          elevation: 0.0,
        ),
        body: _buildStats(),
      ),
    );
  }

  Widget _buildStats() {
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
    return ListView(
      children: stats.keys.map((key) {
        final value = stats[key];
        return Column(
          children: <Widget>[
            Text(key),
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
