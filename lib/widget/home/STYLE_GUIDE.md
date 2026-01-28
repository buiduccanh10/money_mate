# Hướng dẫn Phong cách Thiết kế (Design Style Guide) - MoneyMate

Tài liệu này tổng hợp các quy tắc thiết kế và mẫu lập trình (patterns) được áp dụng trong thư mục `lib/widget/home`, nhằm mục đích tạo sự đồng nhất khi triển khai các trang khác trong ứng dụng.

## 1. Hệ thống Màu sắc & Gradient

### 1.1. AppBar Gradient

Sử dụng Gradient chéo từ `topLeft` đến `bottomRight` để tạo chiều sâu:

- **Light Mode**: `[Color(0xFF4364F7), Color(0xFF6FB1FC)]` (Xanh dương hiện đại).
- **Dark Mode**: `[Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)]` (Deep Midnight).

### 1.2. Màu sắc Trạng thái

- **Thu nhập (Income)**: `Color(0xFF00C853)` (Light: Green Accent).
- **Chi tiêu (Expense)**: `Color(0xFFFF3D00)` (Light: Red Accent).
- **Nền phụ (Icon Layer)**: Sử dụng màu chính với `withValues(alpha: 0.15)` để tạo hiệu ứng lớp (layering).

## 2. Các thành phần UI đặc trưng

### 2.1. Hiệu ứng Glassmorphism (Kính mờ)

Áp dụng cho các container trên nền gradient:

```dart
color: Colors.white.withValues(alpha: 0.2),
borderRadius: BorderRadius.circular(20),
border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
```

### 2.2. Thẻ hiển thị số dư (Floating Cards)

- **Border Radius**: Luôn sử dụng `20` cho các thẻ bo góc.
- **Shadow**: `BoxShadow` nhẹ với `blurRadius: 15`, `offset: Offset(0, 8)`.
- **Layout**: Sử dụng `Positioned` phối hợp với `SafeArea` để tạo hiệu ứng thẻ đè lên AppBar (Overlap).

### 2.3. Loading & Shimmer

- Sử dụng package `shimmer` cho tất cả các trạng thái đang tải dữ liệu.
- **Màu nền Shimmer**:
  - Light: `baseColor: grey[300]`, `highlightColor: grey[100]`.
  - Dark: `baseColor: grey[800]`, `highlightColor: grey[700]`.

## 3. Patterns Lập trình (Implementation Patterns)

### 3.1. Phân tách Widget Member (Helper Methods)

Chia nhỏ các widget phức tạp thành các hàm helper như `_buildTotalCard`, `_buildShimmer` để tăng khả năng đọc code.

### 3.2. Sử dụng Widget dùng chung (Common Widgets)

- **MonthYearPickerSheet**: Sử dụng `MonthYearPickerSheet.show(...)` cho các yêu cầu chọn thời gian dạng Tháng/Năm.
- **TransactionItemTile**: Re-use cho tất cả các danh sách hiển thị giao dịch.

### 3.3. Xử lý Trạng thái (State Management)

Luôn bọc `Scaffold` hoặc Content bằng `BlocBuilder<HomeCubit, HomeState>` để đảm bảo UI phản ứng ngay lập tức với các thay đổi từ Cubit.

## 4. Typography & Spacing

- **Tiêu đề chính**: `fontSize: 24`, `fontWeight: FontWeight.bold`.
- **Số tiền lớn**: `fontSize: 32`, `letterSpacing: 1.2`.
- **Nội dung phụ**: `fontSize: 14`, `color: grey[600]` (Light) / `grey[400]` (Dark).
- **Padding chuẩn**: `width * 0.06` hoặc `16.0` cho khoảng cách lề.

---

_Ghi chú: Luôn kiểm tra `Theme.of(context).brightness` để đảm bảo hỗ trợ đầy đủ Dark/Light Mode._
