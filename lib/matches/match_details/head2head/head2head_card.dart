import 'package:flutter/material.dart';
import 'package:predictions/matches/model/match.dart';

class Head2HeadCard extends StatefulWidget {
  final Match match;

  const Head2HeadCard({Key key, @required this.match}) : super(key: key);

  @override
  _Head2HeadCardState createState() => _Head2HeadCardState();
}

class _Head2HeadCardState extends State<Head2HeadCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Head 2 head",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
      ],
    );
  }
}
