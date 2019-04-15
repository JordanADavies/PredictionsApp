class Utils {
  static int roundProjectedGoals(double predictedScore) {
    final decimals = (predictedScore - predictedScore.floor());
    if (decimals > 0.65) {
      return predictedScore.round();
    }

    return predictedScore.floor();
  }
}