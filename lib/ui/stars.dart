import 'package:flutter/material.dart';
import '../globals.dart';

class Stars extends StatelessWidget {
  final int score;
  final int dur;
  final double size;
  Stars({Key key, this.score, this.dur, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool didStar(int star) => this.score >= star * (this.dur / secToStar);
    Widget one = Icon(didStar(oneStar) ? Icons.star : Icons.star_border);
    Widget two = Icon(didStar(twoStar) ? Icons.star : Icons.star_border);
    Widget three = Icon(didStar(threeStar) ? Icons.star : Icons.star_border);
    List<Widget> stars = [one, two, three];
    List<Widget> styledStars = [];
    stars.forEach((star) {
      styledStars.add(IconTheme(
        data: IconThemeData(
          color: Colors.amber,
          size: this.size,
        ),
        child: star,
      ));
    });
    return SizedBox(
      width: 3.5 * this.size,
      height: this.size + 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: styledStars,
      ),
    );
  }
}
