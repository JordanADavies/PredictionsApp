import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/btts_no_checker.dart';
import 'package:predictions/matches/predictions/btts_yes_checker.dart';
import 'package:predictions/matches/predictions/over_2_checker.dart';
import 'package:predictions/matches/predictions/under_3_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';

class StatsSelectedLeaguesBloc {
  final StreamController<List<PredictionStat>> stats =
      StreamController<List<PredictionStat>>();

  void dispose() {
    stats.close();
  }

  StatsSelectedLeaguesBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_loadStats);
  }

  void _loadStats(Matches matches) async {
    final statsList = await compute(_getLeagueStats, matches);
    stats.add(statsList);
  }

  static List<PredictionStat> _getLeagueStats(Matches matches) {
    final winLoseDrawStats = _getWinLoseDrawStats(matches.winLoseDrawMatches);
    final under3Stats = _getUnder3Stats(matches.under3Matches);
    final over2Stats = _getOver2Stats(matches.over2Matches);
    final bttsNoStats = _getBttsNoStats(matches.bttsNoMatches);
    final bttsYesStats = _getBttsYesStats(matches.bttsYesMatches);
    return [
      winLoseDrawStats,
      under3Stats,
      over2Stats,
      bttsNoStats,
      bttsYesStats,
    ]..sort((left, right) => right.percentage.compareTo(left.percentage));
  }

  static PredictionStat _getWinLoseDrawStats(List<FootballMatch> matches) {
    final predictedMatches =
        matches.where((m) => m.hasFinalScore() && m.isBeforeToday());
    final predictedCorrectly = matches.where((m) {
      final checker = WinLoseDrawChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectly.length} predicted correctly out of ${predictedMatches.length} matches that matched this prediction method.";

    return PredictionStat(
      type: "1X2",
      percentage: percentage,
      summary: summary,
    );
  }

  static PredictionStat _getUnder3Stats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = Under3Checker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = Under3Checker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectly.length} predicted correctly out of ${predictedMatches.length} matches that matched this prediction method.";

    return PredictionStat(
      type: "Under 2.5",
      percentage: percentage,
      summary: summary,
    );
  }

  static PredictionStat _getOver2Stats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = Over2Checker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = Over2Checker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectly.length} predicted correctly out of ${predictedMatches.length} matches that matched this prediction method.";

    return PredictionStat(
      type: "Over 2.5",
      percentage: percentage,
      summary: summary,
    );
  }

  static PredictionStat _getBttsNoStats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = BttsNoChecker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = BttsNoChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectly.length} predicted correctly out of ${predictedMatches.length} matches that matched this prediction method.";

    return PredictionStat(
      type: "BTTS No",
      percentage: percentage,
      summary: summary,
    );
  }

  static PredictionStat _getBttsYesStats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = BttsYesChecker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = BttsYesChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectly.length} predicted correctly out of ${predictedMatches.length} matches that matched this prediction method.";

    return PredictionStat(
      type: "BTTS Yes",
      percentage: percentage,
      summary: summary,
    );
  }
}
