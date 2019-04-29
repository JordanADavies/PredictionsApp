import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

class Under3Checker {
  final FootballMatch match;

  Under3Checker({@required this.match});

  bool getPrediction() {
    final predictedTotal = match.homeProjectedGoals + match.awayProjectedGoals;
    return predictedTotal < 2;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return highPerformingUnder3Leagues.contains(match.leagueId);
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore < 3;
  }
}
