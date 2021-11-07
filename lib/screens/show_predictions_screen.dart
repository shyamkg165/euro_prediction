import 'package:flutter/material.dart';
import 'package:Euro_prediction/display/predictions_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;
List<PredictionsDisplay> predictionsList = [];

class ShowPredictionsScreen extends StatefulWidget {
  ShowPredictionsScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'show_predictions_screen';
  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _ShowPredictionsScreenState createState() => _ShowPredictionsScreenState();
}

class _ShowPredictionsScreenState extends State<ShowPredictionsScreen> {
  @override
  void initState() {
    getPredictions(widget.matchNum);
    super.initState();
  }

  void getPredictions(int matchNumber) async {
    final matchPrediction = await _firestore
        .collection('matchprediction')
        .where("matchnum", isEqualTo: matchNumber)
        .get();

    print ('in getPredictions');
    print (matchNumber);
    predictionsList.clear();
    for (var match in matchPrediction.docs) {
      matchNum = match.data()['matchnum'];
      playerId = match.data()['playerid'];
      matchResult = match.data()['matchresult'];
      manOfMatch = match.data()['manofmatch'];
      bestAttacker = match.data()['bestattacker'];
      bestDefender = match.data()['bestdefender'];

      print(matchNum);
      print(playerId);
      print(matchResult);
      print(manOfMatch);
      print(bestAttacker);
      print(bestDefender);

      final predictionDisplay = PredictionsDisplay(
        playerId: playerId,
        matchNum: matchNum.toString(),
        matchResult: matchResult,
        manOfMatch: manOfMatch,
        bestAttacker: bestAttacker,
        bestDefender: bestDefender,
      );
      predictionsList.add(predictionDisplay);
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    print('size = ' + predictionsList.length.toString());
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
                  for (var prediction in predictionsList)
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

