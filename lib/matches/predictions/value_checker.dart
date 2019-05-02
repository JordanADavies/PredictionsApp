import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';

class ValueChecker {
  final FootballMatch match;

  ValueChecker({@required this.match});

  String getValue() {
    final checker = WinLoseDrawChecker(match: match);
    switch (checker.getPrediction()) {
      case WinLoseDrawResult.HomeWin:
        {
          return "${(1 / match.homeWinProbability).toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.HomeWinOrDraw:
        {
          final doubleChance =
              1 / (match.homeWinProbability + match.drawProbability);
          return "${doubleChance.toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.Draw:
        {
          return "${(1 / match.drawProbability).toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.AwayWin:
        {
          return "${(1 / match.awayWinProbability).toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.AwayWinOrDraw:
        {
          final doubleChance =
              1 / (match.awayWinProbability + match.drawProbability);
          return "${doubleChance.toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.HomeOrAwayWin:
        {
          final doubleChance =
              1 / (match.homeWinProbability + match.awayWinProbability);
          return "${doubleChance.toStringAsFixed(2)}";
        }
      case WinLoseDrawResult.Unknown:
        {
          return "";
        }
    }

    return "";
  }
}
