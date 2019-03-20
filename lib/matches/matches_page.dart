import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/drawer_menu.dart';
import 'package:predictions/matches/match_details/match_details_page.dart';

class MatchesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
        elevation: 0.0,
      ),
      drawer: DrawerMenu(),
      body: _buildMatchesPage(context),
    );
  }

  Widget _buildMatchesPage(BuildContext context) {
    final matchesBloc = MatchesProvider.of(context);
    return StreamBuilder<Map<String, Map<String, List<FootballMatch>>>>(
      stream: matchesBloc.groupedMatches,
      initialData: matchesBloc.groupedMatches.value,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Map<String, List<FootballMatch>>>>
              snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        return _buildMatchesList(snapshot.data);
      },
    );
  }

  Widget _buildMatchesList(
      Map<String, Map<String, List<FootballMatch>>> matches) {
    final nearestDateKey =
        getNearestDateKey(matches.keys.toList(), DateTime.now());
    final nearestDateIndex = matches.keys.toList().indexOf(nearestDateKey);

    return PageView.builder(
      controller: PageController(initialPage: nearestDateIndex),
      itemCount: matches.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final dateString = matches.keys.toList()[index];
        final daysMatches = matches[dateString];
        return _MatchesDayList(
          title: dateString,
          matches: daysMatches,
        );
      },
    );
  }

  String getNearestDateKey(List<String> dates, DateTime targetDate) {
    final formatter = DateFormat("yyyy-MM-dd");
    final futureDates = dates.where((dateString) {
      final date = formatter.parse(dateString);
      return date.difference(targetDate).inDays > -1;
    }).toList();

    return futureDates[0];
  }
}

class _MatchesDayList extends StatelessWidget {
  final String title;
  final Map<String, List<FootballMatch>> matches;

  const _MatchesDayList({Key key, @required this.title, @required this.matches})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).secondaryHeaderColor,
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: matches.keys.length,
            itemBuilder: (BuildContext context, int index) {
              final leagueString = matches.keys.toList()[index];
              final leaguesMatches = matches[leagueString];
              return _MatchesLeagueList(
                leagueName: leagueString,
                matches: leaguesMatches,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MatchesLeagueList extends StatelessWidget {
  final String leagueName;
  final List<FootballMatch> matches;

  const _MatchesLeagueList(
      {Key key, @required this.leagueName, @required this.matches})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Text(
            leagueName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children:
              matches.map((match) => _MatchListItem(match: match)).toList(),
        ),
      ],
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
