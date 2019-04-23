import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';

class BttsYesChecker {
  final FootballMatch match;

  BttsYesChecker({@required this.match});

  bool getPrediction() {
    final bttsPercentage = bttsPercentages[match.leagueId];
    return bttsPercentage > 55 &&
        match.homeProjectedGoals > 0.8 &&
        match.awayProjectedGoals > 0.8;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return overPerformingGoalsTeams.contains("(H) ${match.homeTeam}") &&
        overPerformingGoalsTeams.contains("(A) ${match.awayTeam}");
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore >= 1 && match.awayFinalScore >= 1;
  }
}
