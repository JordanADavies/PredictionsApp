import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/all_teams/stats_all_teams_bloc.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';

class StatsAllTeamsPage extends StatefulWidget {
  @override
  _StatsAllTeamsPageState createState() => _StatsAllTeamsPageState();
}

class _StatsAllTeamsPageState extends State<StatsAllTeamsPage> {
  StatsAllTeamsBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsAllTeamsBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildSearchTextField(context),
        Expanded(
          child: StreamBuilder<Map<String, List<PredictionStat>>>(
            stream: _statsBloc.stats.stream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<PredictionStat>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return _buildStatsResults(snapshot.data);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ),
      child: TextField(
        onChanged: _statsBloc.search,
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.all(12.0),
          hintText: "Search...",
          icon: Icon(
            FontAwesomeIcons.search,
            size: 16.0,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
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
