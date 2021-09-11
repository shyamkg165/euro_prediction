import 'package:Euro_prediction/display/match_display.dart';
import 'package:flutter/material.dart';
//import 'package:Euro_prediction/display/current_match.dart';
import 'package:Euro_prediction/display/predictions_display.dart';

int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;

class ShowPredictionsScreen extends StatefulWidget {
  ShowPredictionsScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg,
      @required this.predictions});

  static const String id = 'show_predictions_screen';
  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;
  final List<PredictionsDisplay> predictions;
  @override
  _ShowPredictionsScreenState createState() => _ShowPredictionsScreenState();
}

class _ShowPredictionsScreenState extends State<ShowPredictionsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    print('init state');
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('size = ' + predictions.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        //child: ListView(children: widget.predictions),
        child: Column(
          children: <Widget>[
            Container(
              child: Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(
                      children: [
                        Text('Player', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text('MatchNum', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text('Result', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [Text('MOM', style: TextStyle(fontSize: 20.0))],
                    ),
                    Column(
                      children: [
                        Text('Best Fwd', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text('Best Defender', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ]),
                  for (var prediction in widget.predictions)
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text(prediction.playerId,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchNum,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchResult,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.manOfMatch,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.bestAttacker,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.bestDefender,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*Column(
children: <Widget>[
CurrentMatch(
matchNum: widget.matchNum,
firstTeam: widget.firstTeam,
secondTeam: widget.secondTeam,
firstImg: widget.firstImg,
secondImg: widget.secondImg),
Container(
child: ListView(children: widget.predictions),
        ],
              ),
),*/
