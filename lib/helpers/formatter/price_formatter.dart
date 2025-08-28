class PriceFormatter {
  PriceFormatter._privateConstructor();
  static final PriceFormatter instance = PriceFormatter._privateConstructor();

  String price(double price, {String thousandsSeparator = '.', int decimalDigits = 2}) {
    // Pisahkan angka menjadi bagian utuh dan pecahan
    String formattedPrice = price.toStringAsFixed(decimalDigits);
    List<String> parts = formattedPrice.split('.');

    // Pisahkan angka utuh menjadi tiga angka setiap grup dan tambahkan tanda koma sebagai pemisah ribuan
    String wholeNumber = parts[0];
    String formattedWholeNumber = '';
    int count = 0;
    for (int i = wholeNumber.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        formattedWholeNumber = thousandsSeparator + formattedWholeNumber;
      }
      formattedWholeNumber = wholeNumber[i] + formattedWholeNumber;
      count++;
    }

    // Jika ada pecahan, tambahkan titik dan pecahan
    String formattedPriceResult = formattedWholeNumber;
    if (parts.length > 1) {
      formattedPriceResult += ',${parts[1]}';
    }

    // Tambahkan simbol mata uang atau format tambahan sesuai kebutuhan
    return 'Rp$formattedPriceResult'; // Hapus simbol mata uang dolar
  }

  String decimal(double price, {String thousandsSeparator = '.', int decimalDigits = 2}) {
    // Pisahkan angka menjadi bagian utuh dan pecahan
    String formattedPrice = price.toStringAsFixed(decimalDigits);
    List<String> parts = formattedPrice.split('.');

    // Pisahkan angka utuh menjadi tiga angka setiap grup dan tambahkan tanda koma sebagai pemisah ribuan
    String wholeNumber = parts[0];
    String formattedWholeNumber = '';
    int count = 0;
    for (int i = wholeNumber.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        formattedWholeNumber = thousandsSeparator + formattedWholeNumber;
      }
      formattedWholeNumber = wholeNumber[i] + formattedWholeNumber;
      count++;
    }

    // Jika ada pecahan, tambahkan titik dan pecahan
    String formattedPriceResult = formattedWholeNumber;
    if (parts.length > 1) {
      formattedPriceResult += ',${parts[1]}';
    }

    // Tambahkan simbol mata uang atau format tambahan sesuai kebutuhan
    return formattedPriceResult; // Hapus simbol mata uang dolar
  }

  String cleanPrice(String value) {
    // Menggunakan regex untuk menghapus "Rp", titik, dan koma
    String cleanedValue = value.replaceAll(RegExp(r'[Rp.,\s]'), '');
    return cleanedValue;
  }

  String formatNominal(double number) {
    if (number >= 100000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(0)}T'; // 1T, 10T, 100T
    } else if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T'; // 1T sampai 999T
    } else if (number >= 100000000000) {
      return '${(number / 1000000000).toStringAsFixed(0)}B'; // 100B sampai 999B
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B'; // 1B sampai 99B
    } else if (number >= 100000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M'; // 100M sampai 999M
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M'; // 1M sampai 99M
    } else if (number >= 100000) {
      return '${(number / 1000).toStringAsFixed(0)}K'; // 100K sampai 999K
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K'; // 1K sampai 99K
    } else {
      return number.toStringAsFixed(0); // Di bawah 1K, tidak ada singkatan
    }
  }
}
