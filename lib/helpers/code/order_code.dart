class OrderCode {
  OrderCode._privateConstructor();
  static final OrderCode instance = OrderCode._privateConstructor();

  String generate(int orderNumber) {
    // Dapatkan tanggal hari ini
    DateTime now = DateTime.now();

    // Format komponen tanggal
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');

    // Format nomor urut dengan 4 digit, isi dengan '0' jika kurang
    String orderNumberFormatted = orderNumber.toString().padLeft(4, '0');

    // Gabungkan semuanya menjadi kode order
    String orderCode = "INV$year$month$day$orderNumberFormatted";

    return orderCode;
  }

  String getLastCharacters({String input = "", int lastDigit = 4}) {
    // Jika panjang string kurang dari 4, kembalikan string asli
    if (input.length <= lastDigit) {
      return input;
    }

    // Ambil 4 karakter terakhir
    return input.substring(input.length - 4);
  }
}
