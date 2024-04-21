
import 'package:common_module/dto/live_message_dto.dart';
import 'package:common_module/dto/live_room_dto.dart';
import 'package:common_module/dto/live_viewer_dto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseStorage {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static final roomCollection = '${dotenv.env['ENV_NAME']}_live_room';
  static final viewerCollection = '${dotenv.env['ENV_NAME']}_viewers';
  static final messageCollection = '${dotenv.env['ENV_NAME']}_messages';
  static final viewCount = 'view_count';
  static final ruby = 'ruby';
  static final armorial = 'armorial';
  static final metaData = 'meta_data';
  static final follow = 'follow';

  static Stream getLiveMessage(String roomId) {
    final roomRef = _db.reference().child(messageCollection).child(roomId);
    return roomRef.orderByChild('timestamp').limitToLast(100).onChildAdded;
  }

  static Stream getViewCount(String roomId) {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(viewCount).onValue;
  }

  static Stream getRuby(String roomId) {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(ruby).onValue;
  }

  static Stream getFollow(String roomId) {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(follow).onValue;
  }

  static Stream getLiveRoom() {
    final roomRef = _db.reference().child(roomCollection);
    return roomRef.onValue;
  }

  static Stream getLiveRoomRemoved() {
    final roomRef = _db.reference().child(roomCollection);
    return roomRef.onChildRemoved;
  }

  static Stream<Event> getLiveRoomById(String roomId) {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(metaData).onValue;
  }

  static Future<DataSnapshot?> getLiveRoomSnapshot(String roomId) async {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(metaData).get();
  }

  static Stream getArmorial(String roomId) {
    final roomRef = _db.reference().child(roomCollection).child(roomId);
    return roomRef.child(armorial).onValue;
  }
}
