import 'package:flutter/material.dart';
import 'package:Euro_prediction/display/current_match.dart';
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
    super.initState();
    print('init state');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        child: ListView(children: widget.predictions),
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
