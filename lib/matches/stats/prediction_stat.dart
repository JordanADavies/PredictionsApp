import 'package:meta/meta.dart';

class PredictionStat {
  final String type;
  final double percentage;
  final String summary;

  PredictionStat(
      {@required this.type, @required this.percentage, @required this.summary});

  @override
  String toString() => "$type - ${percentage.toStringAsFixed(2)}";
}