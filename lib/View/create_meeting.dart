import 'package:flutter/material.dart';
import 'package:video_call/const/text_field.dart';

import '../Controller/dyte_api.dart';
import '../Model/meeting_model.dart';
import '../const/const.dart';
import 'meet_screen.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({Key? key, required this.mode}) : super(key: key);

  final Mode mode;

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String meetingTitle = "";
  String participantName = "";

  bool isLoading = false;
  bool isErroredState = false;

  final _meetingTitleController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      participantName = _nameController.text.trim();
    });

    _meetingTitleController.addListener(() {
      meetingTitle = _meetingTitleController.text.trim();
    });
  }

  Future<void> _joinRoom(
      context, Meeting meeting, bool isHost, Function setState) async {
    try {
      setState(() {
        isLoading = true;
      });
      //Note usage of mode here
      var authToken = await Api.createUser(isHost,
          widget.mode == Mode.webinar ? true : false, participantName, meeting);
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MeetingPage(
                  roomName: meeting.roomName!,
                  authToken: authToken.toString(),
                  mode: widget.mode,
                )),
      );
    } catch (e) {
      setState(() {
        isErroredState = true;
        isLoading = false;
      });
    }
  }

  Future<void> _showMeetingDialog(Meeting meeting) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Text('Join ${meeting.roomName} as'),
              children: !isErroredState
                  ? !isLoading
                      ? <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              onPressed: () {
                                _joinRoom(context, meeting, true, setState);
                              },
                              child: const Text(
                                'Host',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            onPressed: () {},
                          ),
                          // SimpleDialogOption(
                          //   /* child: const Text('Participant'), */
                          //   child: TextButton(
                          //     style: TextButton.styleFrom(
                          //       primary: Colors.blue,
                          //       textStyle: const TextStyle(
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       _joinRoom(context, meeting, false, setState);
                          //     },
                          //     child: const Text('Participant',
                          //         style: TextStyle(color: Colors.black)),
                          //   ),
                          //   onPressed: () {},
                          // ),
                        ]
                      : <Widget>[
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ]
                  : <Widget>[
                      const Center(
                        child: Text('An error occurred!'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          const SizedBox(
            height: 200,
          ),
          const Text(
            "Enter meeting title",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 21,
            ),
          ),
          TextArea(
            controller: _meetingTitleController,
            description: 'Enter meeting title',
          ),
          const SizedBox(
            height: 40,
          ),
          MaterialButton(
              color: Colors.blue,
              minWidth: MediaQuery.of(context).size.width - 80,
              height: 50,
              elevation: 10,
              onPressed: () async {
                try {
                  var meeting = await Api.createMeeting(meetingTitle);
                  await _showMeetingDialog(meeting);
                } catch (e) {
                  setState(() {
                    isLoading = false;
                    isErroredState = true;
                  });
                }
              },
              child: const Text(
                "Create a meeting",
                style: TextStyle(color: Colors.white, fontSize: 25),
              )),
          isErroredState
              ? const Text(
                  "Meeting could not be created, try again",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }
}
