import 'dart:convert';

import 'package:dyte_client/dyte.dart';
import 'package:uuid/uuid.dart';
import 'package:video_call/const/const.dart';
import 'package:http/http.dart' as http;

import '../Model/meeting_model.dart';

class Api {
  static Map<String, String> myheader = {
    "Content-Type": "application/json",
    'Authorization': 'YOUR API KEY',
  };

  // create user
  static Future<String> createUser(
    bool isHost,
    bool isweb,
    String name,
    Meeting meeting,
  ) async {
    Map<String, dynamic> userDetails = {
      'clientSpecificId':const Uuid().v1(), // replace the Uuid().v1() with firbaseuser uid
      'userDetails': <String, String>{
        'name': name,
      },
    };
    if (isweb) {
      userDetails["presetName"] = isHost
          ? "default_webinar_host_preset"
          : "default_webinar_participant_preset";
    } else {
      userDetails["roleName"] = isHost ? "host" : "participant";
    }

    var url = Uri.parse(
        "https://api.cluster.dyte.in/v1/organizations/YOUR ORGANIZATION ID/meetings/${meeting.id}/participant");
    var response =
        await http.post(url, headers: myheader, body: jsonEncode(userDetails));

    var decodedRes = jsonDecode(response.body);
   var  authToken = decodedRes['data']['authResponse']['authToken'];
    return authToken.toString();
  }

  //create  meeting
  static Future<Meeting> createMeeting(String meetingTitle) async {
    var url = Uri.parse(
        "https://api.cluster.dyte.in/v1/organizations/YOUR ORGANIZATION ID/meeting/");
    var response = await http.post(url,
        headers: myheader,
        body: jsonEncode(<String, dynamic>{
          'title': meetingTitle,
          'presetName': 'host',
          'authorization': <String, bool>{'waitingRoom': false, 'closed': false}
        }));

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var data = decodedResponse["data"] as Map;
    var meetingJson = data["meeting"] as Map<String, dynamic>;

    var meeting = Meeting.fromJson(meetingJson);



    return meeting;
  }

// get meeting list
  static Future<List<Meeting>> getMeetings() async {
    var url = Uri.parse(
        "https://api.cluster.dyte.in/v1/organizations/YOUR ORGANIZATION ID/meetings/");
    var response = await http.get(url, headers: myheader);

   
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var data = decodedResponse["data"] as Map;
    var meetingsJson = data["meetings"] as List<dynamic>;
    var meetings = MeetingList.fromJsonList(meetingsJson).meetings!;

    return meetings;
  }
}
