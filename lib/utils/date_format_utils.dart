import 'package:intl/intl.dart';

class DateFormatUtils {
  static String formatDisplayDate(String d) {
    try {
      // Thử parse định dạng ISO yyyy-MM-dd
      DateTime dt = DateFormat('yyyy-MM-dd').parse(d);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      // Nếu lỗi (có thể là định dạng cũ hoặc đã là dd/MM/yyyy), trả về nguyên bản
      return d;
    }
  }

  static String formatFullDate(String locale, String dateStr) {
    DateTime? date = DateTime.tryParse(dateStr);
    if (date != null) {
      return DateFormat.yMMMd(locale).add_jm().format(date);
    }
    return dateStr;
  }

  static String formatDate(String locale, String dateStr) {
    DateTime? date = DateTime.tryParse(dateStr);
    if (date != null) {
      return DateFormat.yMMMd(locale).format(date);
    }
    return dateStr;
  }
}
