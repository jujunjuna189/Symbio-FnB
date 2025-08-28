class DateFormatter {
  DateFormatter._privateConstructor();
  static final DateFormatter instance = DateFormatter._privateConstructor();

  final months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  String dateNowFormatter() {
    DateTime dateTimeNow = DateTime.now();

    String year = dateTimeNow.year.toString();
    String month = dateTimeNow.month < 10 ? '0${dateTimeNow.month}' : dateTimeNow.month.toString();
    String day = dateTimeNow.day < 10 ? '0${dateTimeNow.day}' : dateTimeNow.day.toString();

    String hour = dateTimeNow.hour < 10 ? '0${dateTimeNow.hour}' : dateTimeNow.hour.toString();
    String minute = dateTimeNow.minute < 10 ? '0${dateTimeNow.minute}' : dateTimeNow.minute.toString();
    String second = dateTimeNow.second < 10 ? '0${dateTimeNow.second}' : dateTimeNow.second.toString();

    String dateNow = '$year-$month-$day $hour:$minute:$second';
    return dateNow;
  }

  String dateNowV2Formatter() {
    DateTime dateTimeNow = DateTime.now();

    String year = dateTimeNow.year.toString();
    String month = dateTimeNow.month < 10 ? '0${dateTimeNow.month}' : dateTimeNow.month.toString();
    String day = dateTimeNow.day < 10 ? '0${dateTimeNow.day}' : dateTimeNow.day.toString();

    String dateNow = '$year-$month-$day';
    return dateNow;
  }

  String dateNowV3Formatter() {
    DateTime dateTimeNow = DateTime.now();

    String year = dateTimeNow.year.toString();
    String month = dateTimeNow.month < 10 ? '0${dateTimeNow.month}' : dateTimeNow.month.toString();
    String day = dateTimeNow.day < 10 ? '0${dateTimeNow.day}' : dateTimeNow.day.toString();

    String dateNow = '$day-$month-$year';
    return dateNow;
  }

  String dateV1(String dateTime) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    String formatterDate = "${setZero(date.day)} ${months[date.month - 1]} ${date.year}";

    return formatterDate;
  }

  String dateV2(String dateTime) {
    DateTime dateTimeParse = DateTime.parse(dateTime);

    String year = dateTimeParse.year.toString();
    String month = dateTimeParse.month < 10 ? '0${dateTimeParse.month}' : dateTimeParse.month.toString();
    String day = dateTimeParse.day < 10 ? '0${dateTimeParse.day}' : dateTimeParse.day.toString();

    String date = '$day-$month-$year';
    return date;
  }

  String timeV1(String dateTime) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    String formatterTime = "${setZero(date.hour)}.${setZero(date.minute)}";

    return formatterTime;
  }

  String timeV2(String dateTime) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    String formatterTime = "${setZero(date.hour)}:${setZero(date.minute)}";

    return formatterTime;
  }

  double getWeekOfMonth(DateTime dateTime) {
    // Hitung hari pertama dan hari terakhir bulan ini
    // DateTime startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    DateTime endOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    return endOfMonth.day / 7;
  }

  String setZero(int value) {
    String data = (value < 10) ? "0${value.toString()}" : value.toString();

    return data;
  }
}
