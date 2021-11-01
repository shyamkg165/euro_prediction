import 'package:Euro_prediction/components/rounded_button.dart';
import 'package:Euro_prediction/screens/predictions_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Euro_prediction/display/current_match.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
List<String> playerNameList = [];
final matchResultTextController = TextEditingController();
final manOfMatchTextController = TextEditingController();
final bestAttackerTextController = TextEditingController();
final bestDefenderTextController = TextEditingController();

class MatchPredictScreen extends StatefulWidget {
  MatchPredictScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'match_predict_screen';

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _MatchPredictScreenState createState() => _MatchPredictScreenState();
}

class _MatchPredictScreenState extends State<MatchPredictScreen> {
  final _auth = FirebaseAuth.instance;
  String matchResult;
  String manOfMatch;
  String bestAttacker;
  String bestDefender;

  @override
  void initState() {
    // TODO: implement initState
    playerNameList.clear();
    readPlayerNames(widget.firstTeam);
    readPlayerNames(widget.secondTeam);

    super.initState();
    getCurrentUser();
  }

  void readPlayerNames(String teamName) async {
    final readPlayers =
        await _firestore.collection('Squads/euro2020/' + teamName).get();
    for (var players in readPlayers.docs) {
      print('adding Player' + players.data()['Player'].toString());
      playerNameList.add(players.data()['Player']);
    }

    final currPrediction = _firestore
        .collection('matchprediction')
        .doc(loggedInUser.uid + widget.matchNum.toString());
    await currPrediction.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        if (snapshot.data() != null) {
          matchResult = snapshot.get('matchresult');
          manOfMatch = snapshot.get('manofmatch');
          bestAttacker = snapshot.get('bestattacker');
          bestDefender = snapshot.get('bestdefender');
        }
      });
    });
    setState(() {});
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                child: CurrentMatch(
                    matchNum: widget.matchNum,
                    firstTeam: widget.firstTeam,
                    secondTeam: widget.secondTeam,
                    firstImg: widget.firstImg,
                    secondImg: widget.secondImg),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Match Result',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchResult,
                            items: [widget.firstTeam, widget.secondTeam]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchResult = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Man of the Match',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: manOfMatch,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                manOfMatch = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Best Attacker',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: bestAttacker,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                bestAttacker = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Best Defender',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: bestDefender,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                bestDefender = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 900.0,
              height: 100.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SubmitButton(
                  title: 'SUBMIT',
                  colour: Colors.blue[900],
                  onPressed: () {
                    matchResultTextController.clear();
                    manOfMatchTextController.clear();
                    bestAttackerTextController.clear();
                    bestDefenderTextController.clear();
                    print(matchResult);
                    _firestore
                        .collection('matchprediction')
                        .doc(loggedInUser.uid + widget.matchNum.toString())
                        .set({
                      'matchnum': widget.matchNum,
                      'matchresult': matchResult,
                      'manofmatch': manOfMatch,
                      'bestattacker': bestAttacker,
                      'bestdefender': bestDefender,
                      'playerid': loggedInUser.email
                    }, SetOptions(merge: true)).then((_) {
                      print("Success!");
                    });
                    print('data written to firestore');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PredictionsPage()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
