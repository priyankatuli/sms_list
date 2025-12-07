class TimeUtils{

  static String getTimeAgo(DateTime date){

    final now = DateTime.now();
    final differences = now.difference(date);

   if(differences.inSeconds < 60){
     return "${differences.inSeconds} s ago";
   }else if(differences.inMinutes < 60){
      return "${differences.inMinutes} min ago";
   }else if(differences.inHours < 24){
     return "${differences.inHours} h ago";
   }else if(differences.inDays < 7){
     return _getWeekDay(date.weekday);
   }else{
     return "${date.day.toString().padLeft(2,"0")}/${date.month.toString().padLeft(2,"0")}/${date.year}";
   }

  }

  static String _getWeekDay(int weekday){
    switch(weekday){
      case 1: return 'mon';
      case 2: return 'Tues';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return "";

    }
  }



}