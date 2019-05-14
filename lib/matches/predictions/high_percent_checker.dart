import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

enum HighPercentResult {
  HomeWin,
  HomeWinOrDraw,
  Draw,
  AwayWinOrDraw,
  AwayWin,
  HomeOrAwayWin,
  Unknown
}

class HighPercentChecker {
  static const THRESHOLD = 0.90;

  final FootballMatch match;

  HighPercentChecker({@required this.match});

  HighPercentResult getPrediction() {
    if (match.homeWinProbability > THRESHOLD) {
      return HighPercentResult.HomeWin;
    }

    if (match.drawProbability > THRESHOLD) {
      return HighPercentResult.Draw;
    }

    if (match.awayWinProbability > THRESHOLD) {
      return HighPercentResult.AwayWin;
    }

    if (match.homeWinProbability + match.drawProbability > THRESHOLD) {
      return HighPercentResult.HomeWinOrDraw;
    }

    if (match.homeWinProbability + match.awayWinProbability > THRESHOLD) {
      return HighPercentResult.HomeOrAwayWin;
    }

    if (match.awayWinProbability + match.drawProbability > THRESHOLD) {
      return HighPercentResult.AwayWinOrDraw;
    }

    return HighPercentResult.Unknown;
  }

  HighPercentResult getPredictionIncludingPerformance() {
    return getPrediction();
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore()) {
      return false;
    }

    switch (getPrediction()) {
      case HighPercentResult.HomeWin:
        return match.homeFinalScore > match.awayFinalScore;
      case HighPercentResult.HomeWinOrDraw:
        return match.homeFinalScore >= match.awayFinalScore;
      case HighPercentResult.Draw:
        return match.homeFinalScore == match.awayFinalScore;
      case HighPercentResult.AwayWin:
        return match.homeFinalScore < match.awayFinalScore;
      case HighPercentResult.AwayWinOrDraw:
        return match.homeFinalScore <= match.awayFinalScore;
      case HighPercentResult.HomeOrAwayWin:
        return match.homeFinalScore != match.awayFinalScore;
      case HighPercentResult.Unknown:
        return false;
    }

    return false;
  }
}
