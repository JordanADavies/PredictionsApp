import 'package:predictions/data/model/football_match.dart';

class UndersPrediction {
  List<FootballMatch> predictedMatches;
  List<FootballMatch> predictedAndFinishedMatches;
  List<FootballMatch> predictedCorrectlyMatches;

  UndersPrediction(List<FootballMatch> allMatches) {
    predictedMatches = allMatches.where(_under2Predicted).toList();

    predictedAndFinishedMatches =
        predictedMatches.where((m) => m.hasBeenPlayed()).toList();
    predictedCorrectlyMatches =
        predictedAndFinishedMatches.where(_under3PredictedCorrectly).toList();
  }

  bool _under2Predicted(FootballMatch match) {
    return match.homeProjectedGoals + match.awayProjectedGoals < 2;
  }

  bool _under3PredictedCorrectly(FootballMatch match) {
    return match.homeFinalScore + match.awayFinalScore < 3;
  }
}
