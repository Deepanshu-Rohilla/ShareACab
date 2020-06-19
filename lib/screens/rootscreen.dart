import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/screens/dashboard.dart';
import 'messages.dart';
import 'profile/userprofile.dart';
import 'notifications/notifications.dart';
import 'requests/myrequests.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  Widget choose;

  // String _appBarTitle = '';
  bool justLoggedin = true;
  bool isHome = true;

  int _selectedPage = 0;
  List<Widget> buildBottomNavBarItems() {
    return [
      Tooltip(
        message: 'Dashboard',
        child: Icon(
          FontAwesomeIcons.home,
          size: 20.0,
          color: Theme.of(context).accentColor,
          //color: Colors.black,
        ),
      ),
      Tooltip(
        message: 'My Requests',
        child: Icon(
          Icons.format_list_bulleted,
          size: 20.0,
          color: Theme.of(context).accentColor,
        ),
      ),
      Tooltip(
        message: 'Messages',
        child: Icon(
          _selectedPage == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline,
          size: 20.0,
          color: Theme.of(context).accentColor,
        ),
      ),
      Tooltip(
        message: 'Notifications',
        child: Icon(
          _selectedPage == 3 ? Icons.notifications : Icons.notifications_none,
          size: 20.0,
          color: Theme.of(context).accentColor,
        ),
      ),
      Tooltip(
        message: 'Profile',
        child: Icon(
          _selectedPage == 4 ? Icons.person : Icons.person_outline,
          size: 20.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    ];
  }

  List<Widget> pagelist = <Widget>[];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: pagelist,
    );
  }

  @override
  void initState() {
    pagelist.add(Dashboard());
    pagelist.add(MyRequests());
    pagelist.add(Messages());
    pagelist.add(Notifications());
    pagelist.add(MyProfile(_auth));
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedPage = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: buildPageView(),
            bottomNavigationBar: CurvedNavigationBar(
              color: Theme.of(context).bottomAppBarColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              index: _selectedPage,
              onTap: (index) {
                bottomTapped(index);
              },
              items: buildBottomNavBarItems(),
            ),
          );
  }
}
