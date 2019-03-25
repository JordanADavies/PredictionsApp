import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

class Over2Checker {
  final FootballMatch match;

  Over2Checker({@required this.match});

  bool getPrediction() {
    return match.homeProjectedGoals + match.awayProjectedGoals > 3;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore > 2;
  }
}