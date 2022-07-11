import 'package:dyte_client/dyte.dart';
import 'package:dyte_client/dyteMeeting.dart';
import 'package:dyte_client/dyteParticipant.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';

class MeetingPage extends StatefulWidget {
  final String roomName;
  final String authToken;
  final Mode mode;

  const MeetingPage({
    Key? key,
    @required required this.roomName,
    @required required this.authToken,
    @required required this.mode,
  }) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Row(
        children: <Widget>[
          SizedBox(
            width: width,
            height: height,
            child: DyteMeeting(
              roomName: widget.roomName,
              authToken: widget.authToken,
              onInit: (DyteMeetingHandler meeting) async {
                if (widget.mode == Mode.customControls) {
                  meeting.updateUIConfig({
                    'logo':
                        'https://www.nicepng.com/png/detail/136-1368540_video-call-icon-video-call-icon-png.png',
                    'colors': {
                      'primary': '#2160FD',
                      'secondary': '#262626',
                      'textPrimary': '#EEEEEE',
                      'videoBackground': '#1A1A1A'
                    },
                    'dimensions': {'mode': 'fillParent'},
                    'controlBar': true,
                    'controlBarElements': {
                      'fullscreen': true,
                      'share': true,
                      'screenShare': true,
                      'layout': true,
                      'chat': true,
                      'polls': true,
                      'participants': true,
                      'plugins': true
                    },
                    'header': true,
                    'headerElements': {
                      'logo': true,
                      'title': true,
                      'participantCount': true,
                      'clock': true
                    }
                  });
                }
                meeting.events.on('meetingConnected', this, (ev, cont) {
                  toast('Meeting Connected');
                });

                meeting.events.on('meetingJoin', this, (ev, cont) {
                  toast('Joined Sucessfully');
                });

                meeting.events.on('meetingDisconnected', this, (ev, cont) {
                  toast('Disconnected');
                });

                meeting.events.on('meetingEnd', this, (ev, cont) {
                  Navigator.of(context).pop();
                  toast('Meeting Ended');
                });

                meeting.events.on('participantJoin', this, (ev, cont) {
                  DyteParticipant p = ev.eventData as DyteParticipant;
                  toast("Participant ${p.name} joined");
                });
                meeting.events.on('participantLeave', this, (ev, cont) {
                  DyteParticipant p = ev.eventData as DyteParticipant;
                  toast("Participant ${p.name} left");
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
