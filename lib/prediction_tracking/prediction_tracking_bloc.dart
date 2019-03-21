import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class PredictionTracking {
  final List<FootballMatch> upcomingMatches;
  final List<FootballMatch> predictedMatches;
  final List<FootballMatch> predictedCorrectlyMatches;
  final double percentageCorrect;
  final String summary;

  PredictionTracking(
      {this.upcomingMatches,
      this.predictedMatches,
      this.predictedCorrectlyMatches,
      this.percentageCorrect,
      this.summary});
}

abstract class PredictionTrackingBloc {
  StreamController<PredictionTracking> _predictionTracking = StreamController();

  void dispose() {
    _predictionTracking.close();
  }

  Stream<PredictionTracking> get predictionTracking =>
      _predictionTracking.stream;
}

class Under3PredictionTrackingBloc extends PredictionTrackingBloc {
  Under3PredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(List<FootballMatch> allMatches) async {
    final predictionTracking = await compute(_performPrediction, allMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final finishedMatches = allMatches.where((m) => m.hasBeenPlayed()).toList();
    final predictedMatches =
        allMatches.where((m) => _under2Predicted(m, finishedMatches)).toList();

    final predictedCorrectlyMatches = predictedMatches
        .where(
            (m) => m.hasBeenPlayed() && m.homeFinalScore + m.awayFinalScore < 3)
        .toList();

    final upcomingPredictedMatches =
        predictedMatches.where((m) => !m.hasBeenPlayed()).toList();

    final percentageCorrect =
        predictedCorrectlyMatches.length / predictedMatches.length * 100;
    final summary =
        "${predictedCorrectlyMatches.length} correct out of ${predictedMatches.length} that match this prediction method.";

    return PredictionTracking(
      upcomingMatches: upcomingPredictedMatches,
      predictedMatches: predictedMatches,
      predictedCorrectlyMatches: predictedCorrectlyMatches,
      percentageCorrect: percentageCorrect,
      summary: summary,
    );
  }

  static bool _under2Predicted(
      FootballMatch match, List<FootballMatch> finishedMatches) {
    final homeTeamsLastMatchGoals = _findGoalsInLastMatchForHomeTeam(
        match: match, finishedMatches: finishedMatches);
    final awayTeamsLastMatchGoals = _findGoalsInLastMatchForAwayTeam(
        match: match, finishedMatches: finishedMatches);

    return match.homeProjectedGoals + match.awayProjectedGoals < 2 &&
        homeTeamsLastMatchGoals < 2 &&
        awayTeamsLastMatchGoals < 2;
  }

  static int _findGoalsInLastMatchForHomeTeam(
      {FootballMatch match, List<FootballMatch> finishedMatches}) {
    final lastMatch = finishedMatches.lastWhere(
        (m) => m.homeTeam == match.homeTeam && m != match,
        orElse: () => null);

    return lastMatch == null
        ? 99
        : lastMatch.homeFinalScore + lastMatch.awayFinalScore;
  }

  static int _findGoalsInLastMatchForAwayTeam(
      {FootballMatch match, List<FootballMatch> finishedMatches}) {
    final lastMatch = finishedMatches.lastWhere(
        (m) => m.awayTeam == match.awayTeam && m != match,
        orElse: () => null);

    return lastMatch == null
        ? 99
        : lastMatch.homeFinalScore + lastMatch.awayFinalScore;
  }
}
