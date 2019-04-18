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
        final averageOver2 = _getAverageProjectedGoalsForOver2(values);
        print("O2.5 - ${averageOver2.toStringAsFixed(2)}");

        final averageUnder3 = _getAverageProjectedGoalsForUnder3(values);
        print("U2.5 - ${averageUnder3.toStringAsFixed(2)}");

        final averageGoalScored = _getAverageProjectedGoalsForTeamToScore(
            values);
        print("BTTS - ${averageGoalScored.toStringAsFixed(2)}");

        final averageGoalNotScored =
            _getAverageProjectedGoalsForTeamToNotScore(values);
        print("BTTS No = ${averageGoalNotScored.toStringAsFixed(2)}");
      });
  }

  double _getAverageProjectedGoalsForOver2(List<FootballMatch> matches) {
    final over2Matches =
        matches.where((m) => m.homeFinalScore + m.awayFinalScore > 2);
    List<double> projectedTotal = [];
    over2Matches.forEach(
        (m) => projectedTotal.add(m.homeProjectedGoals + m.awayProjectedGoals));
    return median(projectedTotal);
  }

  double median(List<double> list) {
    list.sort();
    var length = list.length;
    if (length % 2 == 1) {
      return list[(length / 2 + 0.5).toInt()];
    } else {
      return ((list[length ~/ 2] + list[length ~/ 2 + 1]) / 2);
    }
  }

  double _getAverageProjectedGoalsForUnder3(List<FootballMatch> matches) {
    final under3Matches =
        matches.where((m) => m.homeFinalScore + m.awayFinalScore < 3);
    List<double> projectedTotal = [];
    under3Matches.forEach(
        (m) => projectedTotal.add(m.homeProjectedGoals + m.awayProjectedGoals));
    return median(projectedTotal);
  }

  double _getAverageProjectedGoalsForTeamToScore(List<FootballMatch> matches) {
    final homeTeamScoredMatches = matches.where((m) => m.homeFinalScore > 0);
    final awayTeamScoredMatches = matches.where((m) => m.awayFinalScore > 0);
    List<double> projectedTotal = [];
    homeTeamScoredMatches
        .forEach((m) => projectedTotal.add(m.homeProjectedGoals));
    awayTeamScoredMatches
        .forEach((m) => projectedTotal.add(m.awayProjectedGoals));
    return median(projectedTotal);
  }

  double _getAverageProjectedGoalsForTeamToNotScore(
      List<FootballMatch> matches) {
    final homeTeamNotScoredMatches =
        matches.where((m) => m.homeFinalScore == 0);
    final awayTeamNotScoredMatches =
        matches.where((m) => m.awayFinalScore == 0);
    List<double> projectedTotal = [];
    homeTeamNotScoredMatches
        .forEach((m) => projectedTotal.add(m.homeProjectedGoals));
    awayTeamNotScoredMatches
        .forEach((m) => projectedTotal.add(m.awayProjectedGoals));
    return median(projectedTotal);
  }
}
