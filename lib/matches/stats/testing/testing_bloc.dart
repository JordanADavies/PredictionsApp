import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class TestingBloc {
  TestingBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_testStuff);
  }

  void _testStuff(Matches matches) async {
    final grouped = groupBy(matches.allMatches.where((m) => m.hasFinalScore()),
        (m) => "${m.league} -- ${m.leagueId}");

    grouped.keys.toList()
      ..sort()
      ..forEach((k) {
        print(k);

        final values = grouped[k];
        final averagePerGame = _getAverageGoalsPerGame(values);
        print("Average goals per game - ${averagePerGame.toStringAsFixed(2)}");
      });
  }

  double _getAverageGoalsPerGame(List<FootballMatch> matches) {
    List<int> goalsTotal = [];
    matches.forEach((m) => goalsTotal.add(m.homeFinalScore + m.awayFinalScore));
    final average = goalsTotal.reduce((value, element) => value += element) /
        goalsTotal.length;
    return average;
  }
}
