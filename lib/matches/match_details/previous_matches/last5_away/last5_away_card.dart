import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_away/last5_away_bloc.dart';
import 'package:predictions/matches/match_details/previous_matches/previous_match_list_item.dart';
import 'package:predictions/data/matches_provider.dart';

class Last5AwayCard extends StatefulWidget {
  final FootballMatch match;

  const Last5AwayCard({Key key, @required this.match}) : super(key: key);

  @override
  _Last5AwayCardState createState() => _Last5AwayCardState();
}

class _Last5AwayCardState extends State<Last5AwayCard> {
  Last5AwayBloc _last5Bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchesBloc = MatchesProvider.of(context);
    _last5Bloc = Last5AwayBloc(
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Icon(
                  FontAwesomeIcons.caretLeft,
                  color:
                  Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
                ),
                SizedBox(width: 20.0),
                Text(
                  "Last 5 Away",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
                SizedBox(width: 20.0),
                Icon(
                  FontAwesomeIcons.caretRight,
                  color:
                  Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: _buildLast5Away(),
          )
        ],
      ),
    );
  }

  Widget _buildLast5Away() {
    return StreamBuilder<List<FootballMatch>>(
      stream: _last5Bloc.awayMatches,
      builder:
          (BuildContext context, AsyncSnapshot<List<FootballMatch>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data
              .map((m) => PreviousMatchListItem(match: m))
              .toList(),
        );
      },
    );
  }
}
