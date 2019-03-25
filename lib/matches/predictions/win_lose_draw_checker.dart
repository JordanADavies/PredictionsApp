import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

enum WinLoseDrawResult { HomeWin, Draw, AwayWin, Unknown }

class WinLoseDrawChecker {
  final FootballMatch match;

  WinLoseDrawChecker({@required this.match});

  WinLoseDrawResult getPrediction() {
    if (match.homeWinProbability > match.drawProbability &&
        match.homeWinProbability > match.awayWinProbability) {
      return WinLoseDrawResult.HomeWin;
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability) {
      return WinLoseDrawResult.Draw;
    }

    if (match.awayWinProbability > match.drawProbability &&
        match.awayWinProbability > match.homeWinProbability) {
      return WinLoseDrawResult.AwayWin;
    }

    return WinLoseDrawResult.Unknown;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore()) {
      return false;
    }

    switch (getPrediction()) {
      case WinLoseDrawResult.HomeWin:
        return match.homeFinalScore > match.awayFinalScore;
      case WinLoseDrawResult.Draw:
        return match.homeFinalScore == match.awayFinalScore;
      case WinLoseDrawResult.AwayWin:
        return match.homeFinalScore < match.awayFinalScore;
      case WinLoseDrawResult.Unknown:
        return false;
    }
  }
}
