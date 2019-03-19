import 'package:flutter/material.dart';
import 'package:predictions/matches/match_details/previous_matches/head2head/head2head_bloc.dart';
import 'package:predictions/matches/matches_provider.dart';
import 'package:predictions/matches/model/match.dart';

class Head2HeadCard extends StatefulWidget {
  final Match match;

  const Head2HeadCard({Key key, @required this.match}) : super(key: key);

  @override
  _Head2HeadCardState createState() => _Head2HeadCardState();
}

class _Head2HeadCardState extends State<Head2HeadCard> {
  Head2HeadBloc _head2HeadBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchesBloc = MatchesProvider.of(context);
    _head2HeadBloc = Head2HeadBloc(
      matchesBloc: matchesBloc,
      match: widget.match,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _head2HeadBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Head 2 head",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Expanded(
          child: Material(
            type: MaterialType.card,
            child: _buildHead2Head(),
          ),
        ),
      ],
    );
  }

  Widget _buildHead2Head() {
    return StreamBuilder<List<Match>>(
      stream: _head2HeadBloc.head2HeadMatches,
      builder: (BuildContext context, AsyncSnapshot<List<Match>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.data.map(_buildHead2HeadRowItem).toList(),
        );
      },
    );
  }

  Widget _buildHead2HeadRowItem(Match match) {
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
