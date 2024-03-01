import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('vi', LocaleData.VI),
  MapLocale('en', LocaleData.EN),
];

mixin LocaleData {
  //GNav (navigator)
  static const String home = 'home';
  static const String input = 'input';
  static const String search = 'search';
  static const String chart = 'chart';
  static const String setting = 'setting';

  //home page
  static const String hello_home_appbar = 'hello_home_appbar';
  static const String total_saving = 'total_saving';
  static const String no_input_data = 'no_input_data';

  //slideable
  static const String slide_edit = 'slide_edit';
  static const String slide_delete = 'slide_delete';

  //switch
  static const String switch_monthly = 'switch_monthly';
  static const String switch_yearly = 'switch_yearly';

  //input page
  static const String input_description = 'input_description';
  static const String input_money = 'input_money';
  static const String income_category = 'income_category category';
  static const String expense_category = 'expense_category';
  static const String more = 'more';
  static const String input_save = 'input_save';

  //category manage page
  static const String income = 'income';
  static const String expense = 'expense';
  static const String in_category_manage_appbar = 'in_category manage';
  static const String ex_category_manage_appbar = 'ex_category manage';
  static const String in_delete_all_title = 'in_delete_all_title';
  static const String ex_delete_all_title = 'ex_delete_all_title';
  static const String no_cat_yet = 'no_cat_yet';
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  //add cat dialog
  static const String add_cat_dialog_title = 'add_cat_dialog_title';
  static const String choose_an_icon = 'choose_an_icon';
  static const String category_name = 'category_name';
  static const String add_cat = 'add_cat';
  static const String update_cat_title = 'update_cat_title';
  static const String update = 'update';

  //search page
  static const String type_any_to_search = 'type_any_to_search';

  //setting page
  static const String modify = 'modify';
  static const String modify_des = 'modify_des';
  static const String language = 'language';
  static const String language_appbar = 'language_appbar';
  static const String language_des = 'language_des';
  static const String op_en = 'op_en';
  static const String op_vi = 'op_vi';
  static const String currency = 'currency';
  static const String darkmode = 'darkmode';
  static const String application_lock = 'application_lock';
  static const String application_lock_des = 'application_lock_des';
  static const String privacy = 'privacy';
  static const String privacy_des = 'privacy_des';
  static const String about = 'about';
  static const String about_des = 'about_des';
  static const String send_feedback = 'send_feedback';
  static const String send_feedback_des = 'send_feedback_des';
  static const String log_out = 'log_out';
  static const String log_out_dialog = 'log_out_dialog';

  //login
  static const String email = 'email';
  static const String password = 'password';
  static const String forgot_pass = 'forgot_pass';
  static const String login = 'login';
  static const String dont_have_acc = 'dont_have_acc';
  static const String sign_up = 'sign_up';
  static const String or_sign_in = 'or_sign_in';
  static const String sign_in_gg = 'sign_in_gg';

  static const Map<String, dynamic> EN = {
    home: 'Home',
    input: 'Input',
    search: 'Search',
    chart: 'Chart',
    setting: 'Setting',
    hello_home_appbar: 'Hi, ',
    total_saving: 'Total: ',
    income: 'Income',
    expense: 'Expense',
    no_input_data: 'No input data yet !',
    slide_edit: 'Edit',
    slide_delete: 'Delete',
    input_description: 'Description',
    input_money: 'Money',
    income_category: 'Income category',
    expense_category: 'Expense category',
    more: 'More...',
    input_save: 'Save',
    in_category_manage_appbar: 'Income category manage',
    ex_category_manage_appbar: 'Expense category manage',
    in_delete_all_title: 'Delete all income category ?',
    ex_delete_all_title: 'Delete all expense category ?',
    confirm: 'Confirm',
    cancel: 'Cancel',
    add_cat_dialog_title: 'Add a new category',
    choose_an_icon: 'Choose an icon',
    category_name: 'Category name',
    update_cat_title: 'Update category',
    update: 'Update',
    type_any_to_search: 'Type any to search...',
    switch_monthly: 'Monthly',
    switch_yearly: 'Yearly',
    modify: 'Modify',
    modify_des: 'Tap to change your profile',
    language: 'Language',
    currency: 'Currency',
    darkmode: 'Dark mode',
    application_lock: 'Application lock',
    application_lock_des: 'Use Passwork or FaceID when open',
    privacy: 'Privacy',
    privacy_des: 'More privacy options',
    about: 'About',
    about_des: 'Learn more about Money Mate',
    send_feedback: 'Send feedback',
    send_feedback_des: 'Let us know your experience about app',
    log_out: 'Log out',
    no_cat_yet: 'No category yet !',
    log_out_dialog: 'Sign out your account ?',
    language_appbar: 'Language',
    language_des: 'English',
    op_en: 'English',
    op_vi: 'Vietnamese',
    email: 'Email',
    password: 'Password',
    forgot_pass: 'Forgot your password ?',
    login: 'Log in',
    dont_have_acc: "Don't you have account ?",
    sign_up: 'Sign up',
    or_sign_in: 'Or sign in with:',
    sign_in_gg: 'Sign in with Google'
  };

  static const Map<String, dynamic> VI = {
    home: 'Trang chủ',
    input: 'Nhập',
    search: 'Tìm kiếm',
    chart: 'Biểu đồ',
    setting: 'Cài đặt',
    hello_home_appbar: 'Xin chào, ',
    total_saving: 'Tổng: ',
    income: 'Thu nhập',
    expense: 'Chi phí',
    no_input_data: 'Chưa có dữ liệu nhập vào !',
    slide_edit: 'Sửa',
    slide_delete: 'Xoá',
    input_description: 'Mô tả',
    input_money: 'Tiền',
    income_category: 'Danh mục thu nhập',
    expense_category: 'Danh mục chi phí',
    more: 'Thêm...',
    input_save: 'Lưu',
    in_category_manage_appbar: 'Quản lí danh mục thu nhập',
    ex_category_manage_appbar: 'Quản lí danh mục chi phí',
    in_delete_all_title: 'Xoá tất cả danh mục thu nhập ?',
    ex_delete_all_title: 'Xoá tất cả danh mục chi phí ?',
    confirm: 'Xác nhận',
    cancel: 'Huỷ',
    add_cat_dialog_title: 'Thêm một danh mục mới',
    choose_an_icon: 'Chọn một biểu tượng',
    category_name: 'Tên danh mục',
    update_cat_title: 'Cập nhật danh mục',
    update: 'Cập nhật',
    type_any_to_search: 'Nhập bất kì để tìm kiếm...',
    switch_monthly: 'Hàng tháng',
    switch_yearly: 'Hàng năm',
    modify: 'Chỉnh sửa',
    modify_des: 'Nhấn để thay đổi hồ sơ của bạn',
    language: 'Ngôn ngữ',
    currency: 'Tiền tệ',
    darkmode: 'Chế độ tối',
    application_lock: 'Khoá ứng dụng',
    application_lock_des: 'Sử dụng mật khẩu hoặc FaceID khi mở ứng dụng',
    privacy: 'Quyền riêng tư',
    privacy_des: 'Thêm lựa chọn quyền riêng tư',
    about: 'Giới thiệu',
    about_des: 'Tìm hiểu thêm về Money Mate',
    send_feedback: 'Gửi nhận xét',
    send_feedback_des: 'Cho chúng tôi biết trải nghiệm của bạn về ứng dụng',
    log_out: 'Đăng xuất',
    no_cat_yet: 'Chưa có danh mục nào !',
    log_out_dialog: 'Đăng xuất tài khoản của bạn ?',
    language_appbar: 'Ngôn ngữ',
    language_des: 'Tiếng Việt',
    op_en: 'Tiếng Anh',
    op_vi: 'Tiếng Việt',
    email: 'Địa chỉ email',
    password: 'Mật khẩu',
    forgot_pass: 'Quên mật khẩu ?',
    login: 'Đăng nhập',
    dont_have_acc: "Bạn không có tài khoản ?",
    sign_up: 'Đăng ký',
    or_sign_in: 'Hoặc đăng nhập bằng:',
    sign_in_gg: 'Đăng nhập với Google'
  };
}
