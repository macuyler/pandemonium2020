import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  String id;
  List<dynamic> scores;
  Leaderboard({this.id, this.scores});

  dynamic listener;

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
    if (listener != null) listener.cancel();
    if (ref != null) {
      listener = ref.collection('scores').snapshots().listen((snap) {
        print('Setting Scores...');
        this.scores = snap.docs
            .map((doc) => {'name': doc.id, 'score': doc.data()['score']})
            .toList();
      });
    }
  }
}
