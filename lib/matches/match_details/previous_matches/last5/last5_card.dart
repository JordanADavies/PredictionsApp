import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/previous_matches/last5/last5_bloc.dart';
import 'package:predictions/matches/matches_provider.dart';
import 'package:predictions/matches/model/match.dart';

class Last5Card extends StatefulWidget {
  final Match match;

  const Last5Card({Key key, @required this.match}) : super(key: key);

  @override
  _Last5CardState createState() => _Last5CardState();
}

class _Last5CardState extends State<Last5Card> {
  Last5Bloc _last5Bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchesBloc = MatchesProvider.of(context);
    _last5Bloc = Last5Bloc(
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
            "Last 5",
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
                SizedBox(height: 12.0),
                _buildLast5Away(),
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

  Widget _buildLast5Away() {
    return StreamBuilder<List<Match>>(
      stream: _last5Bloc.awayMatches,
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
}
