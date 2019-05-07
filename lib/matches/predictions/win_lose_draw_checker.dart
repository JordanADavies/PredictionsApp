import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

enum WinLoseDrawResult {
  HomeWin,
  HomeWinOrDraw,
  Draw,
  AwayWinOrDraw,
  AwayWin,
  HomeOrAwayWin,
  Unknown
}

class WinLoseDrawChecker {
  final FootballMatch match;

  WinLoseDrawChecker({@required this.match});

  WinLoseDrawResult getPrediction() {
    if (match.homeWinProbability > match.drawProbability &&
        match.homeWinProbability > match.awayWinProbability) {
      return match.homeWinProbability >= 0.60
          ? WinLoseDrawResult.HomeWin
          : _findMostLikelyResult(match.homeWinProbability);
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability) {
      return match.drawProbability >= 0.60
          ? WinLoseDrawResult.Draw
          : _findMostLikelyResult(match.drawProbability);
    }

    if (match.awayWinProbability > match.drawProbability &&
        match.awayWinProbability > match.homeWinProbability) {
      return match.awayWinProbability >= 0.60
          ? WinLoseDrawResult.AwayWin
          : _findMostLikelyResult(match.awayWinProbability);
    }

    return WinLoseDrawResult.Unknown;
  }

  WinLoseDrawResult _findMostLikelyResult(double highestProbability) {
    if (match.homeWinProbability == highestProbability &&
        match.homeWinProbability + match.drawProbability >= 0.60) {
      return WinLoseDrawResult.HomeWinOrDraw;
    }

    if (match.awayWinProbability == highestProbability &&
        match.awayWinProbability + match.drawProbability >= 0.60) {
      return WinLoseDrawResult.AwayWinOrDraw;
    }

    if (match.drawProbability == highestProbability) {
      return match.drawProbability + match.homeWinProbability >
              match.drawProbability + match.awayWinProbability
          ? WinLoseDrawResult.HomeWinOrDraw
          : WinLoseDrawResult.AwayWinOrDraw;
    }

    return WinLoseDrawResult.Unknown;
  }

  WinLoseDrawResult getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (prediction == WinLoseDrawResult.Unknown) {
      return WinLoseDrawResult.Unknown;
    }

    return highPerformingResultLeagues.contains(match.leagueId)
        ? prediction
        : WinLoseDrawResult.Unknown;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore()) {
      return false;
    }

    switch (getPrediction()) {
      case WinLoseDrawResult.HomeWin:
        return match.homeFinalScore > match.awayFinalScore;
      case WinLoseDrawResult.HomeWinOrDraw:
        return match.homeFinalScore >= match.awayFinalScore;
      case WinLoseDrawResult.Draw:
        return match.homeFinalScore == match.awayFinalScore;
      case WinLoseDrawResult.AwayWin:
        return match.homeFinalScore < match.awayFinalScore;
      case WinLoseDrawResult.AwayWinOrDraw:
        return match.homeFinalScore <= match.awayFinalScore;
      case WinLoseDrawResult.HomeOrAwayWin:
        return match.homeFinalScore != match.awayFinalScore;
      case WinLoseDrawResult.Unknown:
        return false;
    }

    return false;
  }
}
