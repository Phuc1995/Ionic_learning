import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationSubjects {
  static final _createdSubject = BehaviorSubject<ReceivedAction>();
  static final _displayedSubject = BehaviorSubject<ReceivedAction>();
  static final _dismissedSubject = BehaviorSubject<ReceivedAction>();
  static final _actionSubject = BehaviorSubject<ReceivedAction>();

  /// Stream to capture all created notifications
  static Stream<ReceivedNotification> get createdStream {
    return _createdSubject.stream;
  }

  /// Stream to capture all notifications displayed on user's screen.
  static Stream<ReceivedNotification> get displayedStream {
    return _displayedSubject.stream;
  }

  /// Stream to capture all notifications dismissed by the user.
  static Stream<ReceivedAction> get dismissedStream {
    return _dismissedSubject.stream;
  }

  /// Stream to capture all actions (tap) over notifications
  static Stream<ReceivedAction> get actionStream {
    return _actionSubject.stream;
  }

  /// Sink to dispose the stream, if you don't need it anymore.
  static Sink get createdSink {
    return _createdSubject.sink;
  }

  /// Sink to dispose the stream, if you don't need it anymore.
  static Sink get displayedSink {
    return _displayedSubject.sink;
  }

  /// Sink to dispose the stream, if you don't need it anymore.
  static Sink get dismissedSink {
    return _dismissedSubject.sink;
  }

  /// Sink to dispose the stream, if you don't need it anymore.
  static Sink get actionSink {
    return _actionSubject.sink;
  }

  /// CLOSE STREAM METHODS *********************************************

  /// Closes definitely all the streams.
  static dispose() {
    _createdSubject.close();
    _displayedSubject.close();
    _dismissedSubject.close();
    _actionSubject.close();
  }
}
