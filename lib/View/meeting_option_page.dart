import 'package:flutter/material.dart';
import 'package:video_call/View/join_meeting.dart';
import 'package:video_call/const/const.dart';

import 'create_meeting.dart';

class MeetingOptions extends StatefulWidget {
  const MeetingOptions({Key? key, required this.title, required this.mode})
      : super(key: key);

  final String title;
  final Mode mode;

  @override
  _MeetingOptionsState createState() => _MeetingOptionsState();
}

//This is the base page containing bottom navigation bar for holding creating meeting and join meeting screens
//This, create meeting and join meeting page are same for  three buttons of home page, we distinguish only in particiular actions and that is done by passing the mode enum to subsequent pages
class _MeetingOptionsState extends State<MeetingOptions> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CreateMeeting(mode: widget.mode),
      JoinMeeting(mode: widget.mode),
    ];
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call_sharp),
            label: 'Start Meeting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_front_sharp),
            label: 'Join Meeting',
          ),
        ],
        // backgroundColor: Colors.black,
        // selectedItemColor: Colors.purple,
        // unselectedItemColor: Colors.black,
        iconSize: 30,
        onTap: _onTappedItem,
        elevation: 5,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
