import 'package:meta/meta.dart';

class PredictionStat {
  final String type;
  final double percentage;
  final int total;
  final int totalCorrect;

  PredictionStat({
    @required this.type,
    @required this.percentage,
    @required this.total,
    @required this.totalCorrect,
  });

  String get summary => "$totalCorrect predicted correctly out of $total matches that matched this prediction method.";

  @override
  String toString() => "$type - ${percentage.toStringAsFixed(2)} - $total - $totalCorrect";
}
