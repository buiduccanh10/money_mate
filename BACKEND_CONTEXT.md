# MoneyMate API Requirements (NestJS Context)

Document này cung cấp ngữ cảnh kỹ thuật cho việc triển khai API bằng NestJS cho ứng dụng MoneyMate. Tất cả các endpoint đều dựa trên cấu trúc repository hiện tại của ứng dụng Flutter.

## 1. Kiến trúc chung (General Architecture)

- **Base URL**: `http://localhost:3000/api` (mặc định cho môi trường dev).
- **Authentication**: JWT (Access Token & Refresh Token).
- **Header**: `Authorization: Bearer <accessToken>` cho các request được bảo mật.
- **Content-Type**: `application/json`.

---

## 2. Authentication API (`/auth`)

Triển khai các endpoint quản lý định danh người dùng.

| Endpoint                | Method | Body Schema                        | Description                               |
| :---------------------- | :----- | :--------------------------------- | :---------------------------------------- |
| `/auth/register`        | POST   | `email, password, confirmPassword` | Đăng ký tài khoản mới.                    |
| `/auth/login`           | POST   | `email, password`                  | Đăng nhập và trả về access/refesh tokens. |
| `/auth/refresh`         | POST   | `refreshToken`                     | Làm mới access token khi hết hạn.         |
| `/auth/logout`          | POST   | -                                  | Đăng xuất và vô hiệu hóa tokens.          |
| `/auth/forgot-password` | POST   | `email`                            | Gửi email khôi phục mật khẩu.             |

---

## 3. Categories API (`/categories`)

Quản lý các danh mục thu chi của người dùng.

| Endpoint                         | Method | Body Schema                   | Description                                             |
| :------------------------------- | :----- | :---------------------------- | :------------------------------------------------------ |
| `/categories`                    | GET    | Query: `isIncome` (optional)  | Lấy danh sách danh mục (có thể lọc theo thu/chi).       |
| `/categories/:id`                | GET    | -                             | Lấy chi tiết một danh mục.                              |
| `/categories`                    | POST   | `icon, name, isIncome, limit` | Tạo danh mục mới (mặc định limit = 0).                  |
| `/categories/:id`                | PUT    | `icon, name, isIncome, limit` | Cập nhật thông tin danh mục.                            |
| `/categories/:id`                | DELETE | -                             | Xóa một danh mục.                                       |
| `/categories`                    | DELETE | Query: `isIncome`             | Xóa tất cả danh mục của người dùng theo loại (thu/chi). |
| `/categories/:id/limit`          | PATCH  | `limit` (number)              | Cập nhật định mức (limit) cho danh mục.                 |
| `/categories/restore-all-limits` | POST   | -                             | Đặt tất cả định mức về 0.                               |

---

## 4. Transactions API (`/transactions`)

Quản lý các giao dịch tài chính.

| Endpoint               | Method | Body Schema                                 | Description                                    |
| :--------------------- | :----- | :------------------------------------------ | :--------------------------------------------- |
| `/transactions`        | GET    | Query: `monthYear, year, isIncome, catId`   | Lấy danh sách giao dịch theo các bộ lọc.       |
| `/transactions`        | POST   | `date, description, money, catId, isIncome` | Thêm giao dịch mới.                            |
| `/transactions/:id`    | PUT    | `date, description, money, catId, isIncome` | Cập nhật giao dịch.                            |
| `/transactions/:id`    | DELETE | -                                           | Xóa một giao dịch.                             |
| `/transactions`        | DELETE | -                                           | Xóa toàn bộ giao dịch của người dùng.          |
| `/transactions/search` | GET    | Query: `q`                                  | Tìm kiếm giao dịch theo mô tả (`description`). |
| `/transactions/yearly` | GET    | Query: `year`                               | Lấy thống kê/dữ liệu theo năm.                 |

---

## 5. Schedules API (`/schedules`)

Quản lý các giao dịch định kỳ (Recurring transactions).

| Endpoint         | Method | Body Schema                                                     | Description                                                           |
| :--------------- | :----- | :-------------------------------------------------------------- | :-------------------------------------------------------------------- |
| `/schedules`     | GET    | -                                                               | Lấy danh sách các tác vụ định kỳ.                                     |
| `/schedules`     | POST   | `date, description, money, catId, icon, name, isIncome, option` | Tạo tác vụ định kỳ (`option`: Never, Daily, Weekly, Monthly, Yearly). |
| `/schedules/:id` | DELETE | -                                                               | Xóa một tác vụ định kỳ.                                               |
| `/schedules`     | DELETE | -                                                               | Xóa tất cả tác vụ định kỳ.                                            |

---

## 6. User & Settings API (`/users`)

Quản lý thông tin cá nhân và cấu hình ứng dụng.

| Endpoint             | Method | Body Schema                | Description                                                     |
| :------------------- | :----- | :------------------------- | :-------------------------------------------------------------- |
| `/users/me`          | GET    | -                          | Lấy thông tin profile người dùng hiện tại.                      |
| `/users/me`          | DELETE | -                          | Xóa tài khoản người dùng và tất cả dữ liệu liên quan.           |
| `/users/me/settings` | PATCH  | `language, isDark, isLock` | Cập nhật cài đặt ứng dụng (Dark mode, Ngôn ngữ, Khóa ứng dụng). |

---

## 7. Quy tắc nghiệp vụ cần lưu ý (Business Rules)

1.  **Định mức danh mục (Category Limit)**: Khi thêm một giao dịch chi (`isIncome: false`), backend cần kiểm tra xem tổng chi tiêu trong tháng hiện tại của danh mục đó có vượt định mức (`limit`) không để cảnh báo hoặc xử lý tương ứng.
2.  **Định kỳ (Schedules)**: Logic thực hiện giao dịch định kỳ có thể xử lý ở backend (Cron job) hoặc gửi thông báo nhắc nhở về mobile. Trong project hiện tại, nó được lưu trữ để hiển thị danh sách các "lịch trình" đã thiết lập.
3.  **Dọn dẹp dữ liệu (Clean up)**: Khi xóa một User hoặc xóa tất cả danh mục, cần đảm bảo tính nhất quán của dữ liệu (Cascade delete hoặc chặn xóa nếu có giao dịch liên quan - tùy lựa chọn triển khai).
