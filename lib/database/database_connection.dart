import 'package:save_local/database/category_model.dart';
import 'package:save_local/notifications/notification_file.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:workmanager/workmanager.dart';
import 'package:save_local/notifications/notification_file.dart';


class DatabaseConnection {
  static Future<Database> SetDatabase() async{
   var directory = await getDatabasesPath();
   String path = join(directory, 'demo.db');
   var database= await
    openDatabase(path,version: 1,onCreate: _oncreate);
   return database;

}

static _oncreate(Database database,int version )async{
   await database.execute("CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,isfinished TEXT,hours INTEGER,minute INTEGER,time_format_show TEXT)");
 }



  Duration getTaskDuration(DateTime selectedDateTime){
    DateTime now = DateTime.now();
    bool nowIsBigger = now.isAfter(selectedDateTime);
    Duration myDuration = nowIsBigger? now.difference(selectedDateTime) :
    selectedDateTime.difference(now) ;
   return myDuration;
  }

 saveitem(Category category)async {
    final db =await SetDatabase();
    final int id=await db.insert('categories', category.category_to_map()); //تلقائي بيبقي فيه id
    print("going through");
  //  await AndroidAlarmManager.oneShotAt(DateTime(2021,10,26,category.hours,category.minute,5), id,createMyNotification(id)); //top level issue
  // final Duration taskDuration =  getTaskDuration(DateTime(2021,10,27,20,20));
   Workmanager().registerOneOffTask("${category.description}", "${category.title}",initialDelay: Duration(seconds: 5),inputData: category.category_to_map());
  // await createMyNotificcation(category.title,category.description);
    print('before return');


    return id;
 }



  Future deleteItem(int id)async{
    final db=await SetDatabase();
    var count = await db
        .rawDelete('DELETE FROM categories WHERE id ="$id"');
    return count;

 }

 Future<List<Map<String,dynamic>>>getdatabase()async{
    final db=await SetDatabase();
    return db.query('categories');
 }

}

// new thread => isolation .
// callbackFunc => callbackDispatcher () or (int) , task id
// one func only manage the tasks in background .

// reg peroidc task
// get all element in db
// check on date time comparing with date time now
// on any operation reg new task !