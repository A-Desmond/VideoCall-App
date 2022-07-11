import 'package:flutter/material.dart';

import '../Controller/dyte_api.dart';
import '../Model/meeting_model.dart';
import '../const/const.dart';
import '../const/text_field.dart';
import 'meeting_page.dart';

class JoinMeeting extends StatefulWidget {
  const JoinMeeting({Key? key, required this.mode}) : super(key: key);

  final Mode mode;

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  int meetingCount = 0;
  List<Meeting> meetings = [];
  List<Meeting> filteredMeetings = [];

  bool isLoading = true;
  bool isErroredState = false;
  bool isSearching = false;

  String participantName = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void _initializePage() async {
    setState(() {
      isLoading = true;
    });
    try {
      meetings = await Api.getMeetings();
      meetingCount = meetings.length;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isErroredState = true;
      });
    }
  }

  void _handleSearchChange() {
    var searchTerm = _searchController.text.trim();
    if (searchTerm == "") {
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredMeetings = [];
      });
      for (var i = 0; i < meetings.length; i++) {
        var meeting = meetings[i];
        if (meeting.title!.toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredMeetings.add(meeting);
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
    _nameController.addListener(() {
      participantName = _nameController.text.trim();
    });
    _searchController.addListener(_handleSearchChange);
  }

  Future<void> _joinRoom(
      context, Meeting meeting, bool isHost, Function setState) async {
    try {
      setState(() {
        isLoading = true;
      });

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
                  authToken: authToken,
                  mode: widget.mode,
                )),
      );
    } catch (e) {
      setState(() {
        isErroredState = true;
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
                          // SimpleDialogOption(

                          //   child: TextButton(
                          //     style: TextButton.styleFrom(
                          //       primary: Colors.blue,
                          //       textStyle: const TextStyle(
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       _joinRoom(
                          //         context,
                          //         meeting,
                          //         true,
                          //         setState,
                          //       );
                          //     },
                          //     child: const Text(
                          //       'Host',
                          //       style: TextStyle(color: Colors.black),
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          // ),
                          SimpleDialogOption(
                            /* child: const Text('Participant'), */
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                _joinRoom(context, meeting, false, setState);
                              },
                              child: const Text(
                                'Join now',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            onPressed: () {},
                          ),
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
    return !isLoading
        ? !isErroredState
            ? Column(
                children: <Widget>[
                  TextArea(
                    controller: _searchController,
                    description: 'Search',
                  ),
                  Expanded(
                    child: meetingCount > 0
                        ? isSearching
                            ? ListView.builder(
                                itemCount: filteredMeetings.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await _showMeetingDialog(
                                        filteredMeetings[index],
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                          "${filteredMeetings[index].title}",
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                              scrollDirection: Axis.vertical,
                                itemCount: meetingCount,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await _showMeetingDialog(
                                        meetings[index],
                                      );
                                    },
                                    child: Center(
                                      child: ListTile(
                                        title: Text("${meetings[index].title}",
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  );
                                },
                              )
                        : const Text('No meetings created'),
                  )
                ],
              )
            : const Text(
                "An error occurred please try again",
                style: TextStyle(color: Colors.white),
              )
        : const CircularProgressIndicator();
  }
}
