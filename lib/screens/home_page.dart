import 'package:flutter/material.dart';
import 'package:Euro_prediction/display/match_display.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: HomeDisplay(display: 'RANK \n#', num: 3),
                ),
                Expanded(
                  child: HomeDisplay(display: 'POINTS \n', num: 366),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: FittedBox(
                child: NextMatchDisplay(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDisplay extends StatelessWidget {
  HomeDisplay({this.display, this.num});
  final String display;
  final int num;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Color(0xFF1D1E33), borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            '$display$num',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 100.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class NextMatchDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MatchDisplay(
      matchNum: 0,
      firstTeam: 'GERMANY',
      secondTeam: 'PORTUGAL',
      firstImg: 'images/GER.webp',
      secondImg: 'images/POR.webp',
      cutOffTime: '4 hrs 52 mins',
      firstButtonName: 'PREDICT NOW',
      secondButtonName: 'NA',
    );
  }
}
