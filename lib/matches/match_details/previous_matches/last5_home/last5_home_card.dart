import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_home/last5_home_bloc.dart';
import 'package:predictions/matches/matches_provider.dart';
import 'package:predictions/matches/model/match.dart';

class Last5HomeCard extends StatefulWidget {
  final Match match;

  const Last5HomeCard({Key key, @required this.match}) : super(key: key);

  @override
  _Last5HomeCardState createState() => _Last5HomeCardState();
}

class _Last5HomeCardState extends State<Last5HomeCard> {
  Last5HomeBloc _last5Bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchesBloc = MatchesProvider.of(context);
    _last5Bloc = Last5HomeBloc(
      matchesBloc: matchesBloc,
      match: widget.match,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _last5Bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Last 5 home",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Expanded(
          child: Material(
            type: MaterialType.card,
            child: ListView(
              children: <Widget>[
                _buildLast5Home(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLast5Home() {
    return StreamBuilder<List<Match>>(
      stream: _last5Bloc.homeMatches,
      builder: (BuildContext context, AsyncSnapshot<List<Match>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.data.map(_buildLast5RowItem).toList(),
        );
      },
    );
  }

  Widget _buildLast5RowItem(Match match) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            match.homeTeam,
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8.0),
        Column(
          children: <Widget>[
            Text("${match.homeFinalScore}-${match.awayFinalScore}"),
            Text(
                "${match.homeProjectedGoals} proj. ${match.awayProjectedGoals}"),
            Text("${match.homeSpiRating} SPI ${match.awaySpiRating}"),
          ],
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            match.awayTeam,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
