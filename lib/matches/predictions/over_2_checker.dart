import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

class Over2Checker {
  final FootballMatch match;

  Over2Checker({@required this.match});

  bool getPrediction() {
    final predictedTotal = match.homeProjectedGoals + match.awayProjectedGoals;
    return predictedTotal > 3;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return highPerformingOver2Leagues.contains(match.leagueId);
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore > 2;
  }
}
