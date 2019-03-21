import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/match_finder.dart';

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

class WinLoseDrawPredictionTrackingBloc extends PredictionTrackingBloc {
  WinLoseDrawPredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(List<FootballMatch> allMatches) async {
    final predictionTracking = await compute(_performPrediction, allMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final predictedCompletedMatches =
    allMatches.where((m) => m.hasBeenPlayed()).toList();
    final predictedCorrectlyCompletedMatches =
    predictedCompletedMatches.where(_predictedResultCorrectly).toList();

    final upcomingPredictedMatches =
    allMatches.where((m) => !m.hasBeenPlayed()).toList();

    final percentageCorrect = predictedCorrectlyCompletedMatches.length /
        predictedCompletedMatches.length *
        100;
    final summary =
        "${predictedCorrectlyCompletedMatches.length} correct out of ${predictedCompletedMatches.length} that match this prediction method.";

    return PredictionTracking(
      upcomingMatches: upcomingPredictedMatches,
      predictedMatches: predictedCompletedMatches,
      predictedCorrectlyMatches: predictedCorrectlyCompletedMatches,
      percentageCorrect: percentageCorrect,
      summary: summary,
    );
  }

  static bool _predictedResultCorrectly(FootballMatch match) {
    if (match.homeWinProbability > match.drawProbability &&
        match.homeWinProbability > match.awayWinProbability) {
      return match.homeFinalScore > match.awayFinalScore;
    }

    if (match.awayWinProbability > match.drawProbability &&
        match.awayWinProbability > match.homeWinProbability) {
      return match.awayFinalScore > match.homeFinalScore;
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability) {
      return match.homeFinalScore == match.awayFinalScore;
    }

    return false;
  }
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
    final matchFinder = MatchFinder(allMatches: allMatches);

    final predictedCompletedMatches = allMatches
        .where((m) => m.hasBeenPlayed() && _under2GoalsExpected(m, matchFinder))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore + m.awayFinalScore < 3)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where(
            (m) => !m.hasBeenPlayed() && _under2GoalsExpected(m, matchFinder))
        .toList();

    final percentageCorrect = predictedCorrectlyCompletedMatches.length /
        predictedCompletedMatches.length *
        100;
    final summary =
        "${predictedCorrectlyCompletedMatches.length} correct out of ${predictedCompletedMatches.length} that match this prediction method.";

    return PredictionTracking(
      upcomingMatches: upcomingPredictedMatches,
      predictedMatches: predictedCompletedMatches,
      predictedCorrectlyMatches: predictedCorrectlyCompletedMatches,
      percentageCorrect: percentageCorrect,
      summary: summary,
    );
  }

  static bool _under2GoalsExpected(FootballMatch match, MatchFinder finder) {
    return match.homeProjectedGoals + match.awayProjectedGoals < 2;
  }
}

class BothTeamToScoreNoPredictionTrackingBloc extends PredictionTrackingBloc {
  BothTeamToScoreNoPredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(List<FootballMatch> allMatches) async {
    final predictionTracking = await compute(_performPrediction, allMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final predictedCompletedMatches = allMatches
        .where((m) => m.hasBeenPlayed() && _bothTeamsProjectToNotScore(m))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore < 1 || m.awayFinalScore < 1)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where((m) => !m.hasBeenPlayed() && _bothTeamsProjectToNotScore(m))
        .toList();

    final percentageCorrect = predictedCorrectlyCompletedMatches.length /
        predictedCompletedMatches.length *
        100;
    final summary =
        "${predictedCorrectlyCompletedMatches.length} correct out of ${predictedCompletedMatches.length} that match this prediction method.";

    return PredictionTracking(
      upcomingMatches: upcomingPredictedMatches,
      predictedMatches: predictedCompletedMatches,
      predictedCorrectlyMatches: predictedCorrectlyCompletedMatches,
      percentageCorrect: percentageCorrect,
      summary: summary,
    );
  }

  static bool _bothTeamsProjectToNotScore(FootballMatch match) {
    return match.homeProjectedGoals < 0.4 || match.awayProjectedGoals < 0.4;
  }
}
