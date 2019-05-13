import 'package:meta/meta.dart';
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
      return awayTeamMoreLikelyToWin()
          ? WinLoseDrawResult.AwayWinOrDraw
          : WinLoseDrawResult.HomeWin;
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability) {
      return WinLoseDrawResult.Draw;
    }

    if (match.awayWinProbability > match.drawProbability &&
        match.awayWinProbability > match.homeWinProbability) {
      return homeTeamMoreLikelyToWin()
          ? WinLoseDrawResult.HomeWinOrDraw
          : WinLoseDrawResult.AwayWin;
    }

    return WinLoseDrawResult.Unknown;
  }

  bool awayTeamMoreLikelyToWin() {
    if ((match.homeImportance >= match.awayImportance &&
            match.homeSpiRating >= match.awaySpiRating) ||
        match.homeSpiRating > match.awaySpiRating + 10) {
      return false;
    }

    return true;
  }

  bool homeTeamMoreLikelyToWin() {
    if ((match.awayImportance >= match.homeImportance &&
            match.awaySpiRating >= match.homeSpiRating) ||
        match.awaySpiRating > match.homeSpiRating + 10) {
      return false;
    }

    return true;
  }

  WinLoseDrawResult getPredictionIncludingPerformance() {
    if ((match.homeImportance < 1.0 && match.awayImportance < 1.0) ||
        match.homeWinProbability > 0.60 ||
        match.drawProbability > 0.60 ||
        match.awayWinProbability > 0.60) {
      return WinLoseDrawResult.Unknown;
    }

    final prediction = getPrediction();
    if (prediction == WinLoseDrawResult.HomeWin ||
        prediction == WinLoseDrawResult.HomeWinOrDraw) {
      return match.homeSpiRating > match.awaySpiRating &&
              match.homeImportance > match.awayImportance
          ? prediction
          : WinLoseDrawResult.Unknown;
    }

    if (prediction == WinLoseDrawResult.AwayWin ||
        prediction == WinLoseDrawResult.AwayWinOrDraw) {
      return match.awaySpiRating > match.homeSpiRating &&
              match.awayImportance > match.homeImportance
          ? prediction
          : WinLoseDrawResult.Unknown;
    }

    return prediction;
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
