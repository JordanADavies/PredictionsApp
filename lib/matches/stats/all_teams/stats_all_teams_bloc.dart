import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
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

//    final underPerformingTeams = [];
//    final overPerformingTeams = [];
//    _cachedStatsMap.forEach((key, value) {
//      value.forEach((s) {
//        if (s.type == "Less than or Equal Projected" && s.percentage == 100 && s.total > 1) {
//          underPerformingTeams.add(key);
//        } else if (s.type == "More than or Equal Projected" && s.percentage == 100 && s.total > 1) {
//          overPerformingTeams.add(key);
//        }
//      });
//    });
//
//    print("-- Underperforming");
//    underPerformingTeams.forEach((t) => print(t));
//    print("-- Overperforming");
//    overPerformingTeams.forEach((t) => print(t));

    stats.add(_cachedStatsMap);
  }

  static Map<String, List<PredictionStat>> _getStats(Matches matches) {
    final groupedHomeMatches =
        groupBy(matches.thisSeasonsMatches, (m) => m.homeTeam);
    final groupedHomeMatchesStats = groupedHomeMatches
        .map((key, value) => MapEntry("(H) $key", _getLeagueStats(key, value)));

    final groupedAwayMatches =
        groupBy(matches.thisSeasonsMatches, (m) => m.awayTeam);
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
    final end = playedMatches.length > 4 ? 4 : playedMatches.length;
    final last5Matches = playedMatches.sublist(0, end);

    final lessThanProjectedStats =
        _getLessOrEqualThanProjectedStats(team, last5Matches);
    final moreThanProjectedStats =
        _getMoreThanOrEqualProjectedStats(team, last5Matches);

    return [
      lessThanProjectedStats,
      moreThanProjectedStats,
    ]..sort((left, right) => right.percentage.compareTo(left.percentage));
  }

  static PredictionStat _getLessOrEqualThanProjectedStats(
      String team, List<FootballMatch> matches) {
    final lessThanPredicted = matches.where((m) {
      if (team == m.homeTeam) {
        return m.homeFinalScore <= Utils.roundProjectedGoals(m.homeProjectedGoals);
      }

      if (team == m.awayTeam) {
        return m.awayFinalScore <= Utils.roundProjectedGoals(m.awayProjectedGoals);
      }

      return false;
    });

    final percentage = lessThanPredicted.length == 0
        ? 0.0
        : lessThanPredicted.length / matches.length * 100;
    return PredictionStat(
      type: "Less than or Equal Projected",
      percentage: percentage,
      total: matches.length,
      totalCorrect: lessThanPredicted.length,
    );
  }

  static PredictionStat _getMoreThanOrEqualProjectedStats(
      String team, List<FootballMatch> matches) {
    final moreThanPredicted = matches.where((m) {
      if (team == m.homeTeam) {
        return m.homeFinalScore >= Utils.roundProjectedGoals(m.homeProjectedGoals);
      }

      if (team == m.awayTeam) {
        return m.awayFinalScore >= Utils.roundProjectedGoals(m.awayProjectedGoals);
      }

      return false;
    });

    final percentage = moreThanPredicted.length == 0
        ? 0.0
        : moreThanPredicted.length / matches.length * 100;
    return PredictionStat(
      type: "More than or Equal Projected",
      percentage: percentage,
      total: matches.length,
      totalCorrect: moreThanPredicted.length,
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
