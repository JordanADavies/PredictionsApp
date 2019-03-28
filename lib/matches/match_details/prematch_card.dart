import 'package:flutter/material.dart';
import 'package:predictions/data/model/football_match.dart';

class PrematchCard extends StatelessWidget {
  final FootballMatch match;

  const PrematchCard({Key key, @required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Pre match",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          _buildProjectedGoalsCard(),
          _buildRatingCard(),
          _buildImportanceCard(),
          _buildProbabilityCard(context),
        ],
      ),
    );
  }

  Widget _buildProjectedGoalsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeProjectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("proj."),
          Expanded(
            child: Text(
              "${match.awayProjectedGoals}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeSpiRating}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("SPI"),
          Expanded(
            child: Text(
              "${match.awaySpiRating}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportanceCard() {
    if (match.homeImportance == null || match.awayImportance == null) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              "${match.homeImportance}",
              textAlign: TextAlign.center,
            ),
          ),
          Text("imp."),
          Expanded(
            child: Text(
              "${match.awayImportance}",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityCard(BuildContext context) {
    final homeWin = match.homeWinProbability * 100;
    final draw = match.drawProbability * 100;
    final awayWin = match.awayWinProbability * 100;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: homeWin.toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: Text(
                "${homeWin.toStringAsFixed(0)}%",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: draw.toInt(),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                "${draw.toStringAsFixed(0)}%",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: awayWin.toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF325D79),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Text(
                "${awayWin.toStringAsFixed(0)}%",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
