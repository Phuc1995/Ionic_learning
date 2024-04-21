//
// import 'dart:async';
//
// import 'package:agora_rtc_engine/rtc_channel.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:agora_rtm/agora_rtm.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:glive_idol/models/live_message.dart';
// import 'package:glive_idol/models/live_room.dart';
// import 'package:glive_idol/models/response/profile_response.dart';
// import 'package:glive_idol/utils/firebase/firebase_storage.dart';
// import 'package:glive_idol/utils/routes/routes.dart';
// import 'package:glive_idol/widgets/heart_anim.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:math' as math;
//
// import 'package:wakelock/wakelock.dart';
//
// // ignore: must_be_immutable
// class AgoraLiveScreen extends StatefulWidget {
//   ProfileResponse? profile;
//
//   AgoraLiveScreen({
//     Key? key,
//     this.profile,
//   }) : super(key: key);
//
//   _AgoraLiveScreenState createState() => _AgoraLiveScreenState();
// }
//
// class _AgoraLiveScreenState extends State<AgoraLiveScreen> {
//   int? remoteUid;
//   // String channelName;
//   List<LiveRoom> userList = [];
//
//   bool _isLogin = true;
//   bool _isInChannel = true;
//   int userNo = 0;
//   var userMap ;
//   var tryingToEnd = false;
//   bool personBool = false;
//   bool accepted =false;
//
//   final _channelMessageController = TextEditingController();
//
//   List<LiveMessage> _infoStrings = <LiveMessage>[];
//
//   late RtcEngine _engine;
//   late AgoraRtmClient _client;
//   late AgoraRtmChannel _channel;
//   bool heart = false;
//   bool anyPerson = false;
//
//   //Love animation
//   final _random = math.Random();
//   // Timer _timer;
//   double height = 0.0;
//   int _numConfetti = 5;
//   int guestID=-1;
//   ClientRole role = ClientRole.Broadcaster;
//
//   @override
//   initState() {
//     super.initState();
//     initialize();
//     // _createClient();
//   }
//
//   @override
//   dispose() {
//     // destroy sdk
//     _engine.leaveChannel();
//     _engine.destroy();
//     super.dispose();
//   }
//
//   Future<void> initialize() async {
//     print(dotenv.env['AGORA_APP_ID']??'');
//     // if (defaultTargetPlatform == TargetPlatform.android) {
//     //   await Permission.microphone.request();
//     //   await Permission.camera.request();
//     // }
//     await Permission.microphone.request();
//     await Permission.camera.request();
//     await Permission.storage.request();
//     _engine = await RtcEngine.createWithConfig(RtcEngineConfig(dotenv.env['AGORA_APP_ID']??''));
//     _engine.setEventHandler(_addEventHandlers());
//     await _engine.enableVideo();
//     // make this room live broadcasting room
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setVideoEncoderConfiguration(VideoEncoderConfiguration(
//         dimensions: VideoDimensions(640, 360),
//         frameRate: VideoFrameRate.Fps30,
//         orientationMode: VideoOutputOrientationMode.Adaptative));
//     // enable camera/mic, this will bring up permission dialog for first time
//     await _engine.enableLocalAudio(true);
//     await _engine.enableLocalVideo(true);
//
//     // Set audio route to speaker
//     await _engine.setDefaultAudioRoutetoSpeakerphone(true);
//     await _engine.setClientRole(role);
//     await _engine.joinChannel(null, widget.profile!.uuid, null, 0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         child:SafeArea(
//           child: Scaffold(
//             body: Container(
//               color: Colors.black,
//               child: Center(
//                 child: Stack(
//                   children: <Widget>[
//                     _viewRows(),// Video Widget
//                     if(tryingToEnd==false)_endCall(),
//                     if(tryingToEnd==false)_liveText(),
//                     if(heart == true && tryingToEnd==false) heartPop(),
//                     if(tryingToEnd==false) _bottomBar(), // send message
//                     if(tryingToEnd==false) messageList(),
//                     if(tryingToEnd==true) endLive(),// view message
//                     if(personBool==true) personList(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         onWillPop: _willPopCallback
//     );
//   }
//
//   Widget _bottomBar() {
//     if (!_isLogin || !_isInChannel) {
//       return Container();
//     }
//     return Container(
//       alignment: Alignment.bottomRight,
//       child: Container(
//         color: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.only(left:8,top:5,right: 8,bottom: 5),
//           child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 new Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(0.0,0,0,0),
//                       child: new TextField(
//                           cursorColor: Colors.blue,
//                           textInputAction: TextInputAction.send,
//                           onSubmitted: _sendMessage,
//                           style: TextStyle(color: Colors.white),
//                           controllers: _channelMessageController,
//                           textCapitalization: TextCapitalization.sentences,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             hintText: 'Comment',
//                             hintStyle: TextStyle(color: Colors.white),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(50.0),
//                                 borderSide: BorderSide(color: Colors.white)
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(50.0),
//                                 borderSide: BorderSide(color: Colors.white)
//                             ),
//                           )
//                       ),
//                     )
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
//                   child: MaterialButton(
//                     minWidth: 0,
//                     onPressed: _toggleSendChannelMessage,
//                     child: Icon(
//                       Icons.send,
//                       color: Colors.white,
//                       size: 20.0,
//                     ),
//                     shape: CircleBorder(),
//                     elevation: 2.0,
//                     color: Colors.blue[400],
//                     padding: const EdgeInsets.all(12.0),
//                   ),
//                 ),
//                 if(accepted==false)Padding(
//                   padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
//                   child: MaterialButton(
//                     minWidth: 0,
//                     onPressed: _addPerson,
//                     child: Icon(
//                       Icons.person_add,
//                       color: Colors.white,
//                       size: 20.0,
//                     ),
//                     shape: CircleBorder(),
//                     elevation: 2.0,
//                     color:Colors.blue[400] ,
//                     padding: const EdgeInsets.all(12.0),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
//                   child: MaterialButton(
//                     minWidth: 0,
//                     onPressed: () => _engine.switchCamera(),
//                     child: Icon(
//                       Icons.flip_camera_ios_outlined,
//                       color: Colors.blue[400],
//                       size: 20.0,
//                     ),
//                     shape: CircleBorder(),
//                     elevation: 2.0,
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(12.0),
//                   ),
//                 )
//               ]
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget personList(){
//     return Container(
//       alignment: Alignment.bottomRight,
//       child: Container(
//         height: 2*MediaQuery.of(context).size.height/3,
//         width: MediaQuery.of(context).size.height,
//         decoration: new BoxDecoration(
//           color: Colors.grey[850],
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25)
//           ),
//         ),
//         child: Stack(
//           children: <Widget>[
//             Container(
//               height: 2*MediaQuery.of(context).size.height/3 -50,
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: 10,),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     width: MediaQuery.of(context).size.width,
//                     alignment: Alignment.center,
//                     child: Text('Go Live with',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
//                   ),
//                   SizedBox(height: 10,),
//                   Divider(color: Colors.grey[800],thickness: 0.5,height: 0,),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//                     width: double.infinity,
//                     color: Colors.grey[900],
//                     child: Text(
//                       'When you go live with someone, anyone who can watch their live videos will be able to watch it too.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[400],
//                       ),
//                     ),
//                   ),
//                   anyPerson==true?Container(
//                       padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                       width: double.maxFinite,
//                       child: Text(
//                         'INVITE',
//                         style: TextStyle(
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold
//                         ),
//                         textAlign: TextAlign.start,
//                       )
//                   ):
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text('No Viewers',style: TextStyle(color: Colors.grey[400]),),
//                   ),
//                   Expanded(
//                     child: ListView(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.vertical,
//                         children: getUserStories()
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     personBool= !personBool;
//                   });
//                 },
//                 child: Container(
//                   color: Colors.grey[850],
//                   alignment: Alignment.bottomCenter,
//                   height: 50,
//                   child: Stack(
//                     children: <Widget>[
//                       Container(
//                           height: double.maxFinite,
//                           alignment: Alignment.center ,
//                           child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Info panel to show logs
//   Widget messageList() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return Container();
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       CachedNetworkImage(
//                         imageUrl: _infoStrings[index].image,
//                         imageBuilder: (context, imageProvider) => Container(
//                           width: 32.0,
//                           height: 32.0,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                                 image: imageProvider, fit: BoxFit.cover),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const  EdgeInsets.symmetric(
//                               horizontal: 8,
//                             ),
//                             child: Text(
//                               _infoStrings[index].name,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 5,),
//                           Padding(
//                             padding: const  EdgeInsets.symmetric(
//                               horizontal: 8,
//                             ),
//                             child: Text(
//                               _infoStrings[index].content,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> getUserStories() {
//     List<Widget> stories = [];
//     for (LiveRoom users in userList) {
//       stories.add(getStory(users));
//     }
//     return stories;
//   }
//
//   Widget getStory(LiveRoom users) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 7.5),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: ()async{
//               await _channel.sendMessage(AgoraRtmMessage.fromText('d1a2v3i4s5h6 ${users.name}'));
//             },
//             child: Container(
//                 padding: EdgeInsets.only(left: 15),
//                 color: Colors.grey[850 ],
//                 child: Row(
//                   children: <Widget>[
//                     CachedNetworkImage(
//                       imageUrl: users.image,
//                       imageBuilder: (context, imageProvider) => Container(
//                         width: 40.0,
//                         height: 40.0,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               image: imageProvider, fit: BoxFit.cover),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: <Widget>[
//                           Text(users.name ,style: TextStyle(fontSize: 18,color: Colors.white),),
//                           SizedBox(height: 2,),
//                           Text(users.name,style: TextStyle(color: Colors.grey),),
//                         ],
//                       ),
//                     )
//                   ],
//                 )
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool> _willPopCallback() async {
//     if(personBool==true){
//       setState(() {
//         personBool=false;
//       });
//
//     }else {
//       setState(() {
//         tryingToEnd = !tryingToEnd;
//       });
//     }
//     return false;// return true if the route to be popped
//   }
//
//   // Video layout wrapper
//   Widget _viewRows() {
//     final views = role == ClientRole.Broadcaster
//         ? RtcLocalView.SurfaceView()
//         : remoteUid != null
//         ? RtcRemoteView.SurfaceView(
//       uid: remoteUid!,
//     ) : Container();
//
//     return Container(
//         child: Column(
//           children: <Widget>[_videoView(views)],
//         ));
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: ClipRRect(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   Widget _endCall(){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(15,15,15,15),
//             child: GestureDetector(
//               onTap: () {
//                 if(personBool==true){
//                   setState(() {
//                     personBool=false;
//                   });
//                 }
//                 setState(() {
//                   tryingToEnd=true;
//                 });
//               },
//               child: Text('END',style: TextStyle(color: Colors.indigo,fontSize: 20,fontWeight: FontWeight.bold),),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _liveText(){
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Container(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: <Color>[
//                       Colors.indigo, Colors.blue
//                     ],
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(4.0))
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
//                 child: Text('LIVE',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left:5,right:10),
//               child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(.6),
//                       borderRadius: BorderRadius.all(Radius.circular(4.0))
//                   ),
//                   height: 28,
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Icon(Icons.visibility,color: Colors.white,size: 13,),
//                         SizedBox(width: 5,),
//                         Text('$userNo',style: TextStyle(color: Colors.white,fontSize: 11),),
//                       ],
//                     ),
//                   )
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget endLive(){
//     return Container(
//       color: Colors.black.withOpacity(0.5),
//       child: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: Text(
//                 'Are you sure you want to end your live video?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize:20
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.bottomCenter,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0,right: 4.0,top:8.0,bottom:8.0),
//                     child: RaisedButton(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         child: Text('End Video',style: TextStyle(color: Colors.white),),
//                       ),
//                       elevation: 2.0,
//                       color: Colors.blue,
//                       onPressed: () async{
//                         await Wakelock.disable();
//                         // await _logout();
//                         // await _leaveChannel();
//                         // await _engine.leaveChannel();
//                         // await _engine.destroy();
//                         FirebaseStorage.deleteLiveRoom(id: widget.profile!.uuid);
//                         Navigator.of(context).popUntil((r) => false);
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 4.0,right: 8.0,top:8.0,bottom:8.0),
//                     child: RaisedButton(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         child: Text('Cancel',style: TextStyle(color:Colors.white),),
//                       ),
//                       elevation: 2.0,
//                       color: Colors.grey,
//                       onPressed: (){
//                         setState(() {
//                           tryingToEnd=false;
//                         });
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget heartPop(){
//     final size = MediaQuery.of(context).size;
//     final confetti = <Widget>[];
//     for (var i = 0; i < _numConfetti; i++) {
//       final height = _random.nextInt(size.height.floor());
//       final width = 20;
//       confetti.add(HeartAnim(height % 200.0,
//         width.toDouble(), 0.5,));
//     }
//
//
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom:20),
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             height: 400,
//             width: 200,
//             child: Stack(
//               children: confetti,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   /// Add agora event handlers
//   RtcEngineEventHandler _addEventHandlers() {
//     RtcEngineEventHandler handler = RtcEngineEventHandler();
//     handler.joinChannelSuccess = (
//         String channel,
//         int uid,
//         int elapsed,
//       ) async {
//       // Todo create room data
//       FirebaseStorage.createLiveRoom(LiveRoom(id: widget.profile!.uuid, name: widget.profile!.username, room: widget.profile!.fullName??'', image: '', me: true, timestamp: 0));
//       await Wakelock.enable();
//       // This is used for Keeping the device awake. Its now enabled
//
//     };
//
//     handler.leaveChannel = (RtcStats stats) {
//       setState(() {
//         remoteUid = null;
//       });
//     };
//
//     handler.userJoined = (int uid, int elapsed) {
//       setState(() {
//         remoteUid = uid;
//       });
//     };
//
//     handler.userOffline = (int uid, UserOfflineReason reason) {
//       setState(() {
//         remoteUid = null;
//       });
//     };
//
//
//     return handler;
//   }
//
//   Future<void> _logout() async {
//     try {
//       await _client.logout();
//       //_log(info:'Logout success.',type: 'logout');
//     } catch (errorCode) {
//       //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
//     }
//   }
//
//   Future<void> _leaveChannel() async {
//     try {
//       await _channel.leave();
//       //_log(info: 'Leave channel success.',type: 'leave');
//       _client.releaseChannel(_channel.channelId);
//       _channelMessageController.text = '';
//
//     } catch (errorCode) {
//       // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
//     }
//   }
//
//   void _addPerson() {
//     setState(() {
//       personBool = !personBool;
//     });
//   }
//
//   void stopFunction(){
//     setState(() {
//       accepted= false;
//     });
//   }
//
//   void _toggleSendChannelMessage() async {
//     String text = _channelMessageController.text;
//     if (text.isEmpty) {
//       return;
//     }
//     try {
//       _channelMessageController.clear();
//       await _channel.sendMessage(AgoraRtmMessage.fromText(text));
//     } catch (errorCode) {
//       //_log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
//     }
//   }
//
//   void _sendMessage(text) async {
//     if (text.isEmpty) {
//       return;
//     }
//     try {
//       _channelMessageController.clear();
//       await _channel.sendMessage(AgoraRtmMessage.fromText(text));
//     } catch (errorCode) {
//       // _log('Send channel message error: ' + errorCode.toString());
//     }
//   }
//
//   void _createClient() async {
//     _client =
//     await AgoraRtmClient.createInstance(dotenv.env['AGORA_APP_ID']??'');
//     _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
//       print('User: $peerId, info: ${message.text}, type: message');
//     };
//     _client.onConnectionStateChanged = (int state, int reason) {
//       if (state == 5) {
//         _client.logout();
//         //_log('Logout.');
//         setState(() {
//           _isLogin = false;
//         });
//       }
//     };
//     await _client.login(null, widget.profile!.uuid);
//     _channel = await _createChannel(widget.profile!.uuid);
//     await _channel.join();
//   }
//
//   Future<AgoraRtmChannel> _createChannel(String name) async {
//     AgoraRtmChannel channel = await _client.createChannel(name);
//     channel.onMemberJoined = (AgoraRtmMember member) async {
//       var img ='https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
//       setState(() {
//         userList.add(new LiveRoom(id: member.userId, name: member.userId, image: img));
//         if(userList.length>0)
//           anyPerson =true;
//       });
//       userMap.putIfAbsent(member.userId, () => img);
//       var len;
//       _channel.getMembers().then((value) {
//         len = value.length;
//         setState(() {
//           userNo= len-1 ;
//         });
//       });
//     };
//     channel.onMemberLeft = (AgoraRtmMember member) {
//       var len;
//       setState(() {
//         userList.removeWhere((element) => element.id == member.userId);
//         if(userList.length==0)
//           anyPerson = false;
//       });
//
//       _channel.getMembers().then((value) {
//         len = value.length;
//         setState(() {
//           userNo= len-1 ;
//         });
//       });
//     };
//     channel.onMessageReceived =
//         (AgoraRtmMessage message, AgoraRtmMember member) {
//     };
//     return channel;
//   }
// }