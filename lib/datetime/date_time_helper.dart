// convert DateTime object to a string yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  // year in the format -> yyyy
  String year = dateTime.year.toString();

  //month to -> mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }

  // Day -> dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }

  //final format -> yyyymmdd
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
