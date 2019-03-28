import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/last5_home/last5_home_bloc.dart';
import 'package:predictions/matches/match_details/previous_matches/previous_match_list_item.dart';
import 'package:predictions/data/matches_provider.dart';

class Last5HomeCard extends StatefulWidget {
  final FootballMatch match;

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
                  "Last 5 Home",
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
            child: _buildLast5Home(),
          )
        ],
      ),
    );
  }

  Widget _buildLast5Home() {
    return StreamBuilder<List<FootballMatch>>(
      stream: _last5Bloc.homeMatches,
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
