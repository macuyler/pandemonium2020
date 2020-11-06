import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  List<dynamic> scores;
  Leaderboard({this.scores});

  void loadLeaders(DocumentReference ref) async {
    if (ref != null) {
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data();
        this.scores = data['scores'];
      }
    }
  }
}
