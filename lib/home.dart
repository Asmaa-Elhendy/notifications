import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'ListCAT.dart';
import 'database/category_model.dart';
import 'database/database_connection.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String title='';
  late String description='';
  late String isfinished='';
  late int hours;
  late int minute;
  late var selectedshow='';
  var mylist=[];
  var badgenum=0;
  DatabaseConnection databaseConnection=DatabaseConnection();
  Future getData()async{
    var list=await databaseConnection.getdatabase();
    setState(() {
      mylist=list;
    });
  }

  //  void background() async{
  //   for(var i = 0; i < mylist.length; i++){
  //     if(mylist[i]['hours']==DateTime.now().hour && mylist[i]['minute']==DateTime.now().minute) {
  //       await createMyNotificcation(mylist[i]['title'],mylist[i]['description']);
  //     }
  //   }
  // }
  @override
  void initState() {
    super.initState();
    getData();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text('Allow Notification'),
          content: Text('Our app would require to send you notifications'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Don\'t allow')),
            TextButton(onPressed: (){ AwesomeNotifications().requestPermissionToSendNotifications().then((value) => Navigator.pop(context));}, child: Text('Allow'))
          ],
        ));

      }
    });

    AwesomeNotifications().actionStream.listen(

            (receivedNotification) async{
          await  FlutterRingtonePlayer.stop();
          if(receivedNotification.channelKey=='basic_channel'&&Platform.isIOS){
            AwesomeNotifications().getGlobalBadgeCounter().then((value) => AwesomeNotifications().setGlobalBadgeCounter(value-1));

          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('notification created on ${receivedNotification.title}'))
          );


        }
    );
    AwesomeNotifications().dismissedStream.listen(

            (receivedNotification) async{
          await  FlutterRingtonePlayer.stop();

          print(AwesomeNotifications().decrementGlobalBadgeCounter().then((value) {
              print(' badge $value');
              badgenum=value;
              print(badgenum);
            }));


          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NOOOOO'))
          );

        }
    );

    AwesomeNotifications().createdStream.listen(

            (receivedNotification) async{

          print(AwesomeNotifications().getGlobalBadgeCounter().then((value) {
              print(' badge create $value');
              badgenum=value;
              print(badgenum);

          }
          ));



        }
    );


  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {


    DatabaseConnection databaseConnection =DatabaseConnection();
    return Scaffold(

      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              decoration: new InputDecoration.collapsed(
                  hintText: 'title'
              ),
              onChanged: (value){
                setState(() {
                  title=value;

                });

              },
            ),
            TextField(
              decoration: new InputDecoration.collapsed(
                  hintText: 'description'
              ),
              onChanged: (value){
                setState(() {
                  description=value;
                });

              },
            ),
            TextField(
              decoration: new InputDecoration.collapsed(
                  hintText: 'isfinished'
              ),
              onChanged: (value){
                setState(() {
                  isfinished=value;
                });

              },
            ),    ElevatedButton(
                child: Text('select time'),
                onPressed: () async {
                  var result = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now(),

                  );

                  setState(() {
                    hours=result!.hour;
                    minute=result.minute;
                    print(result.runtimeType);
                    selectedshow= result.format(context);
                  });
                  print('res ${result!}');

                  // print(result!.format(context));
                  //********************
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                  print('now ${TimeOfDay.now()}');
                }
            ),SizedBox(height: 5,),
            TextButton(onPressed: ()async{
              print(title);print(description);

              var catobj=Category(title: title, description: description, isfinished: isfinished,hours: hours,minute: minute,time_format_show: selectedshow);
              var result=   await databaseConnection.saveitem(catobj);
              print(result);

              getData();

              //

              // for(var i = 0; i < mylist.length; i++){
              //   if(mylist[i]['hours']==DateTime.now().hour && mylist[i]['minute']==DateTime.now().minute) {
              //    await createMyNotificcation(mylist[i]['title'],mylist[i]['description']);
              //   }
              // }

              //    categoryProvider.addtolist(catobj)           ;
              //  print('hiiiiiiiiii ${categoryProvider.categorylist}');
              //   print(catobj);

            }, child: Text('Save')),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: ( context)=>ListCat()));
            }, child: Text('go to next page ')),


            Text(selectedshow),
            //  TextButton(onPressed: ()async{await createMyNotificcation();}, child: Text('send'))


          ],
        ),
      ),
    );
  }

}
// able to work in background .
// fire tasks in backg