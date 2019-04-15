import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/util/utils.dart';

class BttsYesChecker {
  final FootballMatch match;

  BttsYesChecker({@required this.match});

  bool getPrediction() {
    final roundedHomeGoals = Utils.roundProjectedGoals(match.homeProjectedGoals);
    final roundedAwayGoals = Utils.roundProjectedGoals(match.awayProjectedGoals);
    return roundedHomeGoals >= 1 && roundedAwayGoals >= 1;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore >= 1 && match.awayFinalScore >= 1;
  }
}
