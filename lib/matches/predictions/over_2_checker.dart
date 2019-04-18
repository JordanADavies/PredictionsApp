import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

class Over2Checker {
  final FootballMatch match;

  Over2Checker({@required this.match});

  bool getPrediction() {
    final predictedTotal = match.homeProjectedGoals + match.awayProjectedGoals;
    final leagueAverage = over2Averages[match.leagueId] + 0.25;
    return predictedTotal > leagueAverage;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore > 2;
  }
}
