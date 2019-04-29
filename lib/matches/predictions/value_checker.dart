import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

class ValueChecker {
  final FootballMatch match;

  ValueChecker({@required this.match});

  String getValue() {
    if (match.homeWinProbability > match.awayWinProbability &&
        match.homeWinProbability > match.drawProbability) {
      var value = "${(1 / match.homeWinProbability).toStringAsFixed(2)}";
      if (match.homeWinProbability < match.awayWinProbability + match.drawProbability) {
        final doubleChance = 1 / (match.awayWinProbability + match.drawProbability);
        value += " or X2 ${doubleChance.toStringAsFixed(2)}";
      }
      return value;
    }

    if (match.awayWinProbability > match.homeWinProbability &&
        match.awayWinProbability > match.drawProbability) {
      var value = "${(1 / match.awayWinProbability).toStringAsFixed(2)}";
      if (match.awayWinProbability < match.homeWinProbability + match.drawProbability) {
        final doubleChance = 1 / (match.homeWinProbability + match.drawProbability);
        value += " or 1X ${doubleChance.toStringAsFixed(2)}";
      }
      return value;
    }

    if (match.drawProbability > match.homeWinProbability && match.drawProbability > match.awayWinProbability) {
      var value = "${(1 / match.drawProbability).toStringAsFixed(2)}";
      if (match.drawProbability < match.homeWinProbability + match.awayWinProbability) {
        final doubleChance = 1 / (match.homeWinProbability + match.awayWinProbability);
        value += " or 12 ${doubleChance.toStringAsFixed(2)}";
      }
      return value;
    }

    return "";
  }
}
