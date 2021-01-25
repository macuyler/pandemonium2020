import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GameSheet extends StatefulWidget {
  final double height;
  final List<Widget> items;
  final bool disabled;
  GameSheet({Key key, this.height, this.items, this.disabled})
      : super(key: key);

  @override
  _GameSheetState createState() => _GameSheetState();
}

class _GameSheetState extends State<GameSheet> {
  int currentIndex = 0;

  List<Widget> _getItems() {
    return widget.disabled && widget.items.length > 0
        ? [widget.items[0]]
        : widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CarouselSlider(
                options: CarouselOptions(
                    height: widget.height - 40,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    }),
                items: _getItems()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.items.map((item) {
                int index = widget.items.indexOf(item);
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Color.fromRGBO(255, 255, 255, 0.9)
                        : Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                );
              }).toList(),
            )
          ],
        ));
  }
}
