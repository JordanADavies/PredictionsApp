import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

class BttsNoChecker {
  final FootballMatch match;

  BttsNoChecker({@required this.match});

  bool getPrediction() {
    return match.homeProjectedGoals < 1 || match.awayProjectedGoals < 1;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore < 1 || match.awayFinalScore < 1;
  }
}
