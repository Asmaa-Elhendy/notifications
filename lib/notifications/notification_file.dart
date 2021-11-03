import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:save_local/notifications/utilities.dart';


Future<void> createMyNotificcation(String title,String desc )async{

  await AwesomeNotifications( ).createNotification(
      content: NotificationContent(
          id: ctreateUniqueId(),
          channelKey: 'basic_channel',
          title: '${Emojis.activites_balloon} $title',
          body: desc,
           bigPicture: 'asset://images/hiring.png',
         largeIcon: 'asset://images/hiring.png',
         notificationLayout: NotificationLayout.BigPicture,
     //  customSound:  sound()
      ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      )
    ]

  );

}

sound(){
  FlutterRingtonePlayer.play(
    android: AndroidSounds.alarm,
    ios: IosSounds.alarm,
    looping: true, // Android only - API >= 28
    volume: 0.1, // Android only - API >= 28
    asAlarm: true, // Android only - all APIs

  );
}
