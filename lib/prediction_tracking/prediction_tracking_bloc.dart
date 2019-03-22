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
    matchesBloc.matches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(Matches matches) async {
    final predictionTracking =
        await compute(_performPrediction, matches.winLoseDrawMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final predictedCompletedMatches =
        allMatches.reversed.where((m) => m.hasFinalScore()).toList();
    final predictedCorrectlyCompletedMatches =
        predictedCompletedMatches.where(_predictedResultCorrectly).toList();

    final upcomingPredictedMatches =
        allMatches.where((m) => !m.isBeforeToday()).toList();

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
    matchesBloc.matches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(Matches matches) async {
    final predictionTracking =
        await compute(_performPrediction, matches.under3Matches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final matchFinder = MatchFinder(allMatches: allMatches);

    final predictedCompletedMatches = allMatches.reversed
        .where((m) => m.hasFinalScore() && _under2GoalsExpected(m, matchFinder))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore + m.awayFinalScore < 3)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where(
            (m) => !m.isBeforeToday() && _under2GoalsExpected(m, matchFinder))
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

class Over2PredictionTrackingBloc extends PredictionTrackingBloc {
  Over2PredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(Matches matches) async {
    final predictionTracking =
        await compute(_performPrediction, matches.over2Matches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final matchFinder = MatchFinder(allMatches: allMatches);

    final predictedCompletedMatches = allMatches.reversed
        .where((m) => m.hasFinalScore() && _over3GoalsExpected(m, matchFinder))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore + m.awayFinalScore > 2)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where((m) => !m.isBeforeToday() && _over3GoalsExpected(m, matchFinder))
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

  static bool _over3GoalsExpected(FootballMatch match, MatchFinder finder) {
    return match.homeProjectedGoals + match.awayProjectedGoals > 3;
  }
}

class BothTeamToScoreNoPredictionTrackingBloc extends PredictionTrackingBloc {
  BothTeamToScoreNoPredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(Matches matches) async {
    final predictionTracking =
        await compute(_performPrediction, matches.bttsNoMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final predictedCompletedMatches = allMatches.reversed
        .where((m) => m.hasFinalScore() && _bothTeamsProjectToNotScore(m))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore < 1 || m.awayFinalScore < 1)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where((m) => !m.isBeforeToday() && _bothTeamsProjectToNotScore(m))
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
    return match.homeProjectedGoals < 0.45 || match.awayProjectedGoals < 0.45;
  }
}

class BothTeamToScoreYesPredictionTrackingBloc extends PredictionTrackingBloc {
  BothTeamToScoreYesPredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(Matches matches) async {
    final predictionTracking =
        await compute(_performPrediction, matches.bttsYesMatches);
    _predictionTracking.add(predictionTracking);
  }

  static PredictionTracking _performPrediction(List<FootballMatch> allMatches) {
    final predictedCompletedMatches = allMatches.reversed
        .where((m) => m.hasFinalScore() && _bothTeamsProjectToScore(m))
        .toList();
    final predictedCorrectlyCompletedMatches = predictedCompletedMatches
        .where((m) => m.homeFinalScore >= 1 && m.awayFinalScore >= 1)
        .toList();

    final upcomingPredictedMatches = allMatches
        .where((m) => !m.isBeforeToday() && _bothTeamsProjectToScore(m))
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

  static bool _bothTeamsProjectToScore(FootballMatch match) {
    return match.homeProjectedGoals > 1.45 && match.awayProjectedGoals > 1.45;
  }
}
