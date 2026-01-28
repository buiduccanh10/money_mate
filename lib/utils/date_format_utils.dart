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
}
