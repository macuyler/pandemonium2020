import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  String id;
  List<dynamic> scores;
  Leaderboard({this.id, this.scores});

  void loadLeaders(dynamic l) async {
    DocumentReference ref;
    if (l is DocumentReference) {
      ref = l;
      this.id = l.id;
    } else if (l is String) {
      dynamic fs = FirebaseFirestore.instance;
      ref = fs.collection('leaderboards').doc(l);
      this.id = l;
    }
    if (ref != null) {
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data();
        this.scores = data['scores'];
        print('${this.scores}');
      }
    }
  }
}
