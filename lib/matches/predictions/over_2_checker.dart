import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';

class Over2Checker {
  final FootballMatch match;

  Over2Checker({@required this.match});

  bool getPrediction() {
    final predictedTotal = match.homeProjectedGoals + match.awayProjectedGoals;
    final leagueAverage = goalAverages[match.leagueId];
    return leagueAverage > 3 && predictedTotal > 3;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return overPerformingGoalsTeams.contains("(H) ${match.homeTeam}") ||
        overPerformingGoalsTeams.contains("(A) ${match.awayTeam}");
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore > 2;
  }
}
