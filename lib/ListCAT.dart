import 'package:flutter/material.dart';
import 'package:save_local/database/database_connection.dart';


class ListCat extends StatefulWidget {
  const ListCat({Key? key}) : super(key: key);

  @override
  _ListCatState createState() => _ListCatState();
}

class _ListCatState extends State<ListCat> {
  DatabaseConnection databaseConnection=DatabaseConnection();
  var mylist=[];
  Future getData()async{
    var list=await databaseConnection.getdatabase();
    setState(() {
      mylist=list;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getData();

  }
  @override

  Widget build(BuildContext context) {
  print(mylist);
    return Scaffold(
      appBar: AppBar(title: Text('Database'),),
      body: ListView.builder(
          itemCount: mylist.length,
          itemBuilder: (context,index){
            return ListTile(title:Text(mylist[index]['title']),
                        subtitle: Row(children: [Text(mylist[index]['description']),Text('    ${mylist[index]['time_format_show'].toString()}')],),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: ()async{
               await   databaseConnection.deleteItem(mylist[index]['id']).then((value) => print('note delete $value'));
               setState(() {
                 mylist;
                 getData();
               });
                },
              ),

              //
              // IconButton(icon: Icon(Icons.alarm),
              // onPressed: () async{
              //   // if(mylist[index]['hours']==DateTime.now().hour && mylist[index]['minute']==DateTime.now().minute) {
              //   //   await createMyNotificcation(mylist[index]['title'],mylist[index]['description']);
              //   // }
              // },
              // ),

            );
          }),
    );
  }
}
