import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:photo_view/photo_view.dart';

class MillionMartProductPreview extends StatefulWidget {
  var gal;
  MillionMartProductPreview({Key? key, this.gal}) : super(key: key);

  @override
  _MillionMartProductPreviewState createState() =>
      _MillionMartProductPreviewState();
}

class _MillionMartProductPreviewState extends State<MillionMartProductPreview> {
  int curPos = 0;

  List sliderList = [
    "https://smartkit.wrteam.in/smartkit/images/fitness2.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle2.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
    "https://smartkit.wrteam.in/smartkit/images/goggle3.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Hero(
      tag: "",
      child: Stack(
        children: <Widget>[
          PageView.builder(
              itemCount: widget.gal.length,
              controller: PageController(initialPage: 0),
              onPageChanged: (index) {
                setState(() {
                  curPos = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    initialScale: PhotoViewComputedScale.contained * 0.9,
                    minScale: PhotoViewComputedScale.contained * 0.9,
                    imageProvider:
                        CachedNetworkImageProvider(widget.gal[index]['photo']));
              }),
          Padding(
            padding: const EdgeInsets.only(top: 34.0),
            child: Material(
              color: Colors.transparent,
              child: new IconButton(
                icon: new Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
              bottom: 10.0,
              left: 25.0,
              right: 25.0,
              child: SelectedPhoto(
                numberOfDots: widget.gal.length,
                photoIndex: curPos,
              )),
        ],
      ),
    ));
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({required this.numberOfDots, required this.photoIndex});

  Widget _inactivePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4.0)),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}
