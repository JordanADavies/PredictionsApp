import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

class Under3Checker {
  final FootballMatch match;

  Under3Checker({@required this.match});

  bool getPrediction() {
    return match.homeProjectedGoals + match.awayProjectedGoals < 2;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore < 3;
  }
}