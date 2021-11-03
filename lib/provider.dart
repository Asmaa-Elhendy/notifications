
import'package:flutter/material.dart';
import 'package:save_local/database/category_model.dart';

import 'database/database_connection.dart';

class CategoryProvider with ChangeNotifier{
  late List<Map<String,dynamic>> dataList=[] ;

  List<Map<String,dynamic>> get list2{
    return [...dataList];
  }

  DatabaseConnection databaseConnection=DatabaseConnection();

  getlist()async{
    List<Map<String,dynamic>> list2= await databaseConnection.getdatabase();
     list2.forEach((element) {dataList.add(element);});

     print('in provider ${dataList.length}');
    // print(dataList);
    notifyListeners();
     return dataList;

  }

  // List<dynamic> categorylist =[
  //   {'id': 1, 'title': 'asmaa', 'description': 'faculty' , 'isfinished': 'yes'}
  // ];
  //
  // addtolist(Category category){
  //   categorylist.add(category.category_to_map());
  // }



}// in screens
// CategoryProvider categoryProvider=Provider.of<CategoryProvider>(context);
// categoryProvider.categorylist=mylist;



