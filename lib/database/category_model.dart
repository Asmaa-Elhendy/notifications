class Category{

  String title;
  String description;
  String isfinished;
  int hours;
  int minute;
  String time_format_show;

  Category({required this.title,required this.description,required this.isfinished,required this.hours,required this.minute,this.time_format_show='0'});

  Category.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        description = json['description'],
        isfinished = json['isfinished'],
        hours = json['hours'],
        minute = json['minute'],
        time_format_show = json['time_format_show'];




  Map<String,dynamic> category_to_map(){
    var mapping = Map<String,dynamic>();

    mapping['title']=title;
    mapping['description']=description;
    mapping['isfinished']=isfinished;
    mapping['hours']=hours;
    mapping['minute']=minute;
    mapping['time_format_show']=time_format_show;
    return mapping;
  }
}
