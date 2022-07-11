import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class APIUrl {
    static const String bUrl = "https://api.cluster.dyte.in/v1";
    static const String imageUrl = 'https://www.brides.com/thmb/6ixORjDnBtw9GC-FBD4lkEkOc3w=/3800x3800/filters:fill(auto,1)/fwbsquare-d68c53ed39b64c73847b18cb61e34a4a.jpg';
}

enum Mode {
    groupCall,
    webinar,
    customControls,
}

toast(String message){
  Fluttertoast.showToast(msg:message, fontSize: 20,backgroundColor:Colors.black );
}