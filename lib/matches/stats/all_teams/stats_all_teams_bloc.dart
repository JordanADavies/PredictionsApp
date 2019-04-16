import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';
import 'package:predictions/util/utils.dart';

class StatsAllTeamsBloc {
  final StreamController<Map<String, List<PredictionStat>>> stats =
      StreamController<Map<String, List<PredictionStat>>>();
  Map<String, List<PredictionStat>> _cachedStatsMap;

  void dispose() {
    stats.close();
  }

  StatsAllTeamsBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_loadStats);
  }

  void _loadStats(Matches matches) async {
    _cachedStatsMap = await compute(_getStats, matches);

//    final asExpectedResultsTeams = [];
//    final underPerformingTeams = [];
//    final overPerformingTeams = [];
//    _cachedStatsMap.forEach((key, value) {
//      value.forEach((s) {
//        if (s.type == "1X2" && s.percentage == 100 && s.total > 1) {
//          asExpectedResultsTeams.add(key);
//        } else if (s.type == "<= Projected" && s.percentage == 100 && s.total > 1) {
//          underPerformingTeams.add(key);
//        } else if (s.type == ">= Projected" && s.percentage == 100 && s.total > 1) {
//          overPerformingTeams.add(key);
//        }
//      });
//    });
//
//    print("-- As expected results");
//    asExpectedResultsTeams.forEach((t) => print(t));
//    print("-- Underperforming goals");
//    underPerformingTeams.forEach((t) => print(t));
//    print("-- Overperforming goals");
//    overPerformingTeams.forEach((t) => print(t));

    stats.add(_cachedStatsMap);
  }

  static Map<String, List<PredictionStat>> _getStats(Matches matches) {
    final groupedHomeMatches = groupBy(matches.allMatches, (m) => m.homeTeam);
    final groupedHomeMatchesStats = groupedHomeMatches
        .map((key, value) => MapEntry("(H) $key", _getLeagueStats(key, value)));

    final groupedAwayMatches = groupBy(matches.allMatches, (m) => m.awayTeam);
    final groupedAwayMatchesStats = groupedAwayMatches
        .map((key, value) => MapEntry("(A) $key", _getLeagueStats(key, value)));

    return Map()
      ..addAll(groupedHomeMatchesStats)
      ..addAll(groupedAwayMatchesStats);
  }

  static List<PredictionStat> _getLeagueStats(
      String team, List<FootballMatch> matches) {
    final playedMatches =
        matches.where((m) => m.hasFinalScore() && m.isBeforeToday()).toList();
    final end = playedMatches.length > 3 ? 3 : playedMatches.length;
    final lastMatches = playedMatches.reversed.toList().sublist(0, end);

    final winLoseDrawStats = _getWinLoseDrawStats(lastMatches);
    final lessThanProjectedStats =
        _getLessOrEqualThanProjectedStats(team, lastMatches);
    final moreThanProjectedStats =
        _getMoreThanOrEqualProjectedStats(team, lastMatches);

    return [
      winLoseDrawStats,
      lessThanProjectedStats,
      moreThanProjectedStats,
    ]..sort((left, right) => right.percentage.compareTo(left.percentage));
  }

  static PredictionStat _getLessOrEqualThanProjectedStats(
      String team, List<FootballMatch> matches) {
    final lessThanPredicted = matches.where((m) {
      if (team == m.homeTeam) {
        return m.homeFinalScore <=
            Utils.roundProjectedGoals(m.homeProjectedGoals);
      }

      if (team == m.awayTeam) {
        return m.awayFinalScore <=
            Utils.roundProjectedGoals(m.awayProjectedGoals);
      }

      return false;
    });

    final percentage = lessThanPredicted.length == 0
        ? 0.0
        : lessThanPredicted.length / matches.length * 100;
    return PredictionStat(
      type: "<= Projected",
      percentage: percentage,
      total: matches.length,
      totalCorrect: lessThanPredicted.length,
    );
  }

  static PredictionStat _getMoreThanOrEqualProjectedStats(
      String team, List<FootballMatch> matches) {
    final moreThanPredicted = matches.where((m) {
      if (team == m.homeTeam) {
        return m.homeFinalScore >=
            Utils.roundProjectedGoals(m.homeProjectedGoals);
      }

      if (team == m.awayTeam) {
        return m.awayFinalScore >=
            Utils.roundProjectedGoals(m.awayProjectedGoals);
      }

      return false;
    });

    final percentage = moreThanPredicted.length == 0
        ? 0.0
        : moreThanPredicted.length / matches.length * 100;
    return PredictionStat(
      type: ">= Projected",
      percentage: percentage,
      total: matches.length,
      totalCorrect: moreThanPredicted.length,
    );
  }

  static PredictionStat _getWinLoseDrawStats(List<FootballMatch> matches) {
    final predictedCorrectly = matches.where((m) {
      final checker = WinLoseDrawChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / matches.length * 100;
    return PredictionStat(
      type: "1X2",
      percentage: percentage,
      total: matches.length,
      totalCorrect: predictedCorrectly.length,
    );
  }

  void search(String searchTerm) {
    final filteredKeys = _cachedStatsMap.keys
        .where((key) => key.toLowerCase().contains(searchTerm.toLowerCase()));
    final filteredResults = Map.fromEntries(
        filteredKeys.map((key) => MapEntry(key, _cachedStatsMap[key])));
    stats.add(filteredResults);
  }
}
