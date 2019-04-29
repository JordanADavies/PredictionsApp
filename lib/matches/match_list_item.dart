import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/match_details_page.dart';
import 'package:predictions/matches/predictions/over_2_checker.dart';
import 'package:predictions/matches/predictions/under_3_checker.dart';
import 'package:predictions/matches/predictions/value_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';

class MatchListItem extends StatelessWidget {
  final FootballMatch match;

  const MatchListItem({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 12.0,
      ),
      child: Material(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(0.15),
        child: ListTile(
          title: Text("${match.homeTeam} vs ${match.awayTeam}"),
          subtitle: _buildSubtitle(context),
          trailing: _buildTrailing(),
          onTap: () => _showMatchDetails(context),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    return match.hasFinalScore()
        ? Text("${match.homeFinalScore}-${match.awayFinalScore}")
        : Opacity(child: Text("0-0"), opacity: 0);
  }

  Widget _buildSubtitle(BuildContext context) {
    final matchesBloc = MatchesProvider.of(context);
    return StreamBuilder<Matches>(
      stream: matchesBloc.matches,
      initialData: matchesBloc.matches.value,
      builder: (BuildContext context, AsyncSnapshot<Matches> snapshot) {
        return Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 28.0),
              _buildWinLoseDraw(),
              SizedBox(width: 28.0),
              Opacity(
                opacity: snapshot.data?.under3Matches?.contains(match) ?? false
                    ? 1.0
                    : 0.2,
                child: _buildUnder3(),
              ),
              SizedBox(width: 28.0),
              Opacity(
                opacity: snapshot.data?.over2Matches?.contains(match) ?? false
                    ? 1.0
                    : 0.2,
                child: _buildOver2(),
              ),
              SizedBox(width: 28.0),
              _buildValue(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWinLoseDraw() {
    final checker = WinLoseDrawChecker(match: match);
    final text = {
      WinLoseDrawResult.HomeWin: "1",
      WinLoseDrawResult.Draw: "X",
      WinLoseDrawResult.AwayWin: "2",
      WinLoseDrawResult.Unknown: "?"
    }[checker.getPrediction()];

    return Column(
      children: <Widget>[
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: checker.isPredictionCorrect()
                ? Colors.green
                : match.hasFinalScore() ? Colors.red : Color(0xFF325D79),
          ),
          child: Center(
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Text("1X2"),
      ],
    );
  }

  Widget _buildUnder3() {
    final checker = Under3Checker(match: match);
    final icon = checker.getPrediction()
        ? FontAwesomeIcons.solidCheckCircle
        : FontAwesomeIcons.solidTimesCircle;

    final finishedColor = checker.getPrediction() && match.hasFinalScore()
        ? Colors.red
        : Color(0xFF325D79);
    final color = checker.isPredictionCorrect() ? Colors.green : finishedColor;

    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        SizedBox(height: 4.0),
        Text("U2.5"),
      ],
    );
  }

  Widget _buildOver2() {
    final checker = Over2Checker(match: match);
    final icon = checker.getPrediction()
        ? FontAwesomeIcons.solidCheckCircle
        : FontAwesomeIcons.solidTimesCircle;

    final finishedColor = checker.getPrediction() && match.hasFinalScore()
        ? Colors.red
        : Color(0xFF325D79);
    final color = checker.isPredictionCorrect() ? Colors.green : finishedColor;

    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        SizedBox(height: 4.0),
        Text("O2.5"),
      ],
    );
  }

  Widget _buildValue() {
    final checker = ValueChecker(match: match);
    final value =  checker.getValue();

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey[400],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 8.0),
              child: Text(
                value,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Text("Value"),
      ],
    );
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
