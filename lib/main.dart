import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_local/notifications/notification_file.dart';
import 'package:save_local/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'database/category_model.dart';
import 'database/database_connection.dart';
import 'home.dart';

List<Map<String,dynamic>> dataList = [];

//CategoryProvider categoryProvider=CategoryProvider();

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  DatabaseConnection databaseConnection=DatabaseConnection();
  await databaseConnection.getdatabase().then((value) {
    dataList = value ;
    Workmanager().initialize((callbackDispatcher));
  });
  print('main ${dataList}');
  //await categoryProvider.getlist();




  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
             enableLights: true,
             channelShowBadge: true,
          importance: NotificationImportance.High,
         // playSound: true,
         defaultRingtoneType: DefaultRingtoneType.Alarm

          //  defaultRingtoneType: sound()
        )
      ]
  );
  runApp(MyApp());
}

   void callbackDispatcher()async {

   //  await categoryProvider.getlist();
  print("we in");
  Workmanager().executeTask((task, inputData) async {
    print("before for");
    print('inside fun ${dataList}');
    if(dataList.isEmpty) return true;
    for (var i in dataList){
      if(i['title'] == task){
        print("inside title");
        final Category myCategory = Category.fromJson(inputData!);
        print(myCategory.title);
        await createMyNotificcation(myCategory.title,myCategory.description);
        Workmanager().cancelByUniqueName(myCategory.description);
      }
    }
    print("Native called background task: $task");
    print("we out 1");
    return Future.value(true);
  });
  // print("we out 2");
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context)=>CategoryProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home()
      ),
    );
  }
}
