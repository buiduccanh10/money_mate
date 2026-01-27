# Hướng dẫn tạo API Client từ Swagger

Tài liệu này hướng dẫn cách cập nhật hoặc tạo lại API Client cho Flutter từ backend Swagger spec.

## 1. Yêu cầu

- Đảm bảo Backend đang chạy (mặc định tại `http://localhost:3000`).
- Swagger JSON có sẵn tại `http://localhost:3000/api/docs-json`.

## 2. Quy trình cập nhật API

### Bước 1: Tải Swagger JSON mới nhất

Chạy lệnh sau từ thư mục gốc của project flutter:

```bash
curl http://localhost:3000/api/docs-json -o lib/data/network/swagger/money_mate_api.json
```

### Bước 2: Tạo code bằng build_runner

Chạy lệnh sau để Flutter tự động tạo lại các file `.swagger.dart` và `.chopper.dart`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 3. Cấu trúc thư mục

- `lib/data/network/swagger/money_mate_api.json`: File định nghĩa API.
- `lib/data/network/swagger/generated/`: Chứa code được tự động tạo.
  - `money_mate_api.swagger.dart`: Client chính.
  - `money_mate_api.models.swagger.dart`: Các DTO (Data Transfer Objects).
  - `money_mate_api.chopper.dart`: Implementation của Chopper.

## 4. Lưu ý

- Nếu bạn thêm endpoint mới ở backend, hãy đảm bảo đã cập nhật Swagger decorator đầy đủ.
- Sau khi generate, nếu có lỗi về kiểu dữ liệu (DTO), hãy kiểm tra lại cấu trúc JSON ở backend.
- Các repository trong Flutter đã được chuyển sang sử dụng `ApiClient.api`, bạn chỉ cần cập nhật code repository nếu schema của API thay đổi.
