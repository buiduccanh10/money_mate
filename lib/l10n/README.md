# Hướng dẫn đa ngôn ngữ (Localization Guide)

Tài liệu này hướng dẫn cách thêm mới ngôn ngữ hoặc cập nhật các chuỗi văn bản trong ứng dụng Money Mate sử dụng hệ thống localization chính thức của Flutter.

## 1. Cấu trúc thư mục

- `lib/l10n/`: Chứa các tệp nguồn `.arb` và các tệp mã nguồn được tạo tự động.
- `app_en.arb`: Tệp ngôn ngữ gốc (Tiếng Anh).
- `app_vi.arb`: Tệp ngôn ngữ Tiếng Việt.
- `app_zh.arb`: Tệp ngôn ngữ Tiếng Trung.

## 2. Cách thêm một chuỗi văn bản mới

Để thêm một từ hoặc câu mới vào ứng dụng, bạn cần thực hiện các bước sau:

1. Mở tệp `app_en.arb` (tệp mẫu).
2. Thêm một cặp key-value mới. Ví dụ:
   ```json
   "helloWorld": "Hello World!",
   "@helloWorld": {
     "description": "Lời chào mặc định"
   }
   ```
3. Mở các tệp `.arb` khác (`app_vi.arb`, `app_zh.arb`) và thêm key tương ứng với bản dịch.
   ```json
   "helloWorld": "Xin chào thế giới!"
   ```

## 3. Cách cập nhật code (Generation)

Sau khi chỉnh sửa các tệp `.arb`, bạn cần chạy lệnh sau để Flutter tự động tạo lại các tệp `.dart` tương ứng trong `lib/l10n/`:

```bash
flutter gen-l10n
```

_Lưu ý: Nếu bạn đang chạy ứng dụng ở chế độ Debug hoặc dùng VS Code/Android Studio, lệnh này thường được tự động chạy khi bạn lưu tệp hoặc chạy `flutter pub get`._

## 4. Cách sử dụng trong mã nguồn

Để sử dụng các chuỗi đã định nghĩa trong widget:

1. Đảm bảo đã import:

   ```dart
   import 'package:money_mate/l10n/app_localizations.dart';
   ```

2. Truy cập chuỗi văn bản thông qua `context`:
   ```dart
   Text(AppLocalizations.of(context)!.helloWorld)
   ```

## 5. Thêm một ngôn ngữ hoàn toàn mới

1. Tạo tệp mới trong `lib/l10n/` với định dạng `app_<language_code>.arb`. Ví dụ: `app_fr.arb` cho tiếng Pháp.
2. Sao chép nội dung từ `app_en.arb` và dịch sang ngôn ngữ mới.
3. Chạy lại lệnh `flutter gen-l10n`.
4. Cập nhật danh sách ngôn ngữ hỗ trợ trong ứng dụng (nếu có dropdown chọn ngôn ngữ).
