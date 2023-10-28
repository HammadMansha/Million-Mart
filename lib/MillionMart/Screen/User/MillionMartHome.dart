import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:like_button/like_button.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'MillionMartFavrite.dart';
import 'MillionMartNotification.dart';
import 'MillionMartProfile.dart';
import '../User/MillionMartpHomeTab.dart';

class MillionMartHome extends StatefulWidget {

  @override
  _MillionMartHomeState createState() => _MillionMartHomeState();
}

class _MillionMartHomeState extends State<MillionMartHome> {
  late List<Widget> MillionMartBottomeTab;
  int _curSelected = 0;
  @override
  void initState() {
    super.initState();

    _curSelected = 0;
    MillionMartBottomeTab = [
      MillionMartHomeTab(),
      MillionMartFavrite(
        appbar: false,
      ),
      MillionMartNotification(
          // appbar: false,
          ),
      MillionMartPeofile(
        appbar: false,
      ),
      // MillionMartTreackOrder(
      //   appbar: false,
      // )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        } // currentFocus.dispose();
      },
      child: Scaffold(
        bottomNavigationBar: getBottomBar(),
        body: MillionMartBottomeTab[_curSelected],
      ),
    );
  }

  getBottomBar() {
    return BottomAppBar(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _curSelected,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 0);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.home_outlined,
                      size: 24,
                      color: Color(0x31333333).withOpacity(0.5),
                    );
                  },
                ),
                activeIcon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 0);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.home_sharp,
                      size: 24,
                      color: MillionMartcolor2,
                    );
                  },
                ),
              ),
              BottomNavigationBarItem(
                label: 'Favorite',
                icon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 1);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite_border,
                      size: 24,
                      color: Color(0x31333333).withOpacity(0.5),
                    );
                  },
                ),
                activeIcon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 1);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      size: 24,
                      color: MillionMartcolor2,
                    );
                  },
                ),
              ),
              BottomNavigationBarItem(
                label: 'Notifications',
                icon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 2);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.notifications_none,
                      size: 24,
                      color: Color(0x31333333).withOpacity(0.5),
                    );
                  },
                ),
                activeIcon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 2);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.notifications,
                      size: 24,
                      color: MillionMartcolor2,
                    );
                  },
                ),
              ),
              BottomNavigationBarItem(
                label: 'Track Order',
                icon: LikeButton(
                  size: 24.0,
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 3);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.account_circle_outlined,
                      size: 24,
                      color: Color(0x31333333).withOpacity(0.5),
                    );
                  },
                ),
                activeIcon: LikeButton(
                  onTap: (bool isLiked) {
                    return onNavigationTap(isLiked, 3);
                  },
                  circleColor: CircleColor(
                      start: primaryColor, end: primaryColor.withOpacity(0.1)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: primaryColor,
                    dotSecondaryColor: primaryColor.withOpacity(0.1),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.account_circle,
                      size: 24,
                      color: MillionMartcolor2,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onNavigationTap(bool isLiked, int index) async {
    setState(() {
      _curSelected = index;
    });
    return !isLiked;
  }
}
