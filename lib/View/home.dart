import 'package:flutter/material.dart';
import 'package:video_call/View/meeting_option_page.dart';

import 'package:video_call/const/const.dart';

import '../Controller/dyte_api.dart';
import '../Model/meeting_model.dart';

class HomePAGE extends StatefulWidget {
  String title;
   HomePAGE({Key? key,
   required this.title,
   }) : super(key: key);

  @override
  State<HomePAGE> createState() => _HomePAGEState();
}


class _HomePAGEState extends State<HomePAGE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  APIUrl.imageUrl,
                ),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              '  Start a video  call with ease',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 150,
            ),
            MaterialButton(
                minWidth: 300,
                height: 60,
                elevation: 10,
                color: Colors.blue,
                child: const Text(
                  'Group call',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              MeetingOptions(title: '${widget.title}- Group call', mode: Mode.groupCall))));
                }),
            const SizedBox(
              height: 150,
            ),
            MaterialButton(
                minWidth: 300,
                height: 60,
                elevation: 10,
                color: Colors.blue,
                child: const Text(
                  'Custom Call',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              MeetingOptions(title:'${widget.title}- Custom Controlls', mode: Mode.customControls))));
                }),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
