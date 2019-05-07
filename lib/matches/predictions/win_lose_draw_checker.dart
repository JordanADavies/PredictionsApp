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
      return match.homeWinProbability >
              match.drawProbability + match.awayWinProbability
          ? WinLoseDrawResult.HomeWin
          : WinLoseDrawResult.AwayWinOrDraw;
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability) {
      return match.drawProbability >
              match.homeWinProbability + match.awayWinProbability
          ? WinLoseDrawResult.Draw
          : WinLoseDrawResult.HomeOrAwayWin;
    }

    if (match.awayWinProbability > match.drawProbability &&
        match.awayWinProbability > match.homeWinProbability) {
      return match.awayWinProbability >
              match.drawProbability + match.homeWinProbability
          ? WinLoseDrawResult.AwayWin
          : WinLoseDrawResult.HomeWinOrDraw;
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
