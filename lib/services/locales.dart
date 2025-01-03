import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/widget/setting/advance_setting/advance_setting.dart';

const List<MapLocale> LOCALES = [
  MapLocale('vi', LocaleData.VI),
  MapLocale('en', LocaleData.EN),
  MapLocale('zh', LocaleData.CN),
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
  static const String no_available = 'no_available';

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
  static const String des_validator = 'des_validator';
  static const String money_validator = 'money_validator';
  static const String cat_validator = 'cat_validator';

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
  static const String cat_icon_validator = 'cat_icon_validator';
  static const String cat_name_validator = 'cat_name_validator';

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
  static const String op_cn = 'op_cn';
  static const String currency = 'currency';
  static const String appearance = 'appearance';
  static const String darkmode_light_des = 'darkmode_light_des';
  static const String darkmode_dark_des = 'darkmode_dark_des';
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
  static const String delete_all_data_acc = 'delete_all_data_acc';
  static const String delete_all_data_acc_des = 'delete_all_data_acc_des';
  static const String delete_acc = 'delete_acc';
  static const String delete_acc_des = 'delete_acc_des';
  static const String advanced_settings = 'advanced_settings';
  static const String setting_limit_title = 'setting_limit_tile';
  static const String setting_limit_des = 'setting_limit_des';
  static const String restore_all_limit_title = 'restore_all_limit_title';
  static const String restore_limit = 'restore_limit';
  static const String no_limit = 'no_limit';
  static const String limit_dialog = 'limit_dialog';
  static const String over_limit = 'over_limit';
  static const String over = 'over';
  static const String limit_success = 'limit_success';
  static const String limit_fail = 'limit_fail';
  static const String restore_limit_success = 'restore_limit_success';
  static const String restore_limit_fail = 'restore_limit_fail';
  static const String restore_all_limit_success = 'restore_all_limit_success';
  static const String restore_all_limit_fail = 'restore_all_limit_fail';

  //fixed income and expense
  static const String fixed_in_ex = 'fixed_in_ex';
  static const String fixed_in_ex_des = 'fixed_in_ex_des';
  static const String set_up = 'set_up';
  static const String no_set_up_yet = 'no_set_up_yet';
  static const String delete_all_schedule = 'delete_all_schedule';
  static const String select_category = 'select_category';
  static const String repeat = 'repeat';
  static const String never_repeat = 'never_repeat';
  static const String daily = 'daily';
  static const String monthly = 'monthly';
  static const String weekly = 'weekly';
  static const String yearly = 'yearly';

  //pay by e-wallet
  static const String pay_by_e_wallet = 'pay_by_e_wallet';
  static const String pay_by_e_wallet_des = 'pay_by_e_wallet_des';
  static const String pay_by_e_wallet_title = 'pay_by_e_wallet_title';
  static const String payment_method_title = 'payment_method_title';
  static const String payment_method_qr = 'payment_method_qr';
  static const String payment_method_new = 'payment_method_new';
  static const String paypal_account_holder = 'paypal_account_holder';
  static const String paypal_content_billing = 'paypal_content_billing';
  static const String option_category = 'option_category';
  static const String check_out = 'check_out';
  static const String paypal_success = 'paypal_success';
  static const String paypal_fail = 'paypal_fail';
  static const String paypal_cancel = 'paypal_cancel';

  //login
  static const String email = 'email';
  static const String password = 'password';
  static const String forgot_pass = 'forgot_pass';
  static const String login = 'login';
  static const String dont_have_acc = 'dont_have_acc';
  static const String sign_up = 'sign_up';
  static const String or_sign_in = 'or_sign_in';
  static const String sign_in_gg = 'sign_in_gg';

  //ftoast
  static const String toast_add_success = 'toast_add_success';
  static const String toast_update_success = 'toast_update_success';
  static const String toast_delete_success = 'toast_delete_success';
  static const String toast_add_fail = 'toast_add_fail';
  static const String toast_update_fail = 'toast_update_fail';
  static const String toast_delete_fail = 'toast_delete_fail';
  static const String toast_delete_user_fail = 'toast_delete_user_fail';
  static const String toast_login_success = 'toast_login_success';
  static const String toast_login_fail = 'toast_login_fail';
  static const String toast_sign_up_success = 'toast_sign_up_success';
  static const String toast_sign_up_weakpass = 'toast_sign_up_weakpass';
  static const String toast_user_exist = 'toast_user_exist';
  static const String toast_not_found = 'toast_not_found';
  static const String toast_verify_email = 'toast_verify_email';
  static const String toast_user_not_exist = 'toast_user_not_exist';

  //local auth
  static const String local_auth_title = 'local_auth_title';
  static const String local_auth_warning = 'local_auth_warning';

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
    appearance: 'Appearance',
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
    op_cn: 'Chinese',
    email: 'Email',
    password: 'Password',
    forgot_pass: 'Forgot your password ?',
    login: 'Log in',
    dont_have_acc: "Don't you have account ?",
    sign_up: 'Sign up',
    or_sign_in: 'Or sign in with:',
    sign_in_gg: 'Sign in with Google',
    delete_all_data_acc: 'Delete all data',
    delete_all_data_acc_des: 'Your input, category,... data will be delete',
    delete_acc: 'Delete account',
    delete_acc_des: 'Your account will no longer exist',
    toast_add_success: 'Create successfull !',
    toast_update_success: 'Update successfull !',
    toast_delete_success: 'Delete successfull !',
    toast_add_fail: 'Create fail !',
    toast_update_fail: 'Update fail !',
    toast_delete_fail: 'Delete fail !',
    toast_delete_user_fail: 'Delete user fail ! (Login and try again)',
    toast_login_success: 'Login successful !',
    toast_login_fail: 'Wrong user or password !',
    toast_sign_up_success:
        'Sign up successful, check the link in your email to verify !',
    toast_sign_up_weakpass: 'Password too weak !',
    toast_user_exist: 'Email already exists',
    toast_not_found: 'Not found !',
    toast_verify_email:
        'Your account not verify, check the link in your email !',
    toast_user_not_exist: 'User is not exist !',
    cat_validator: 'No category selected yet !',
    des_validator: 'Description field can not be blank',
    money_validator: 'Money field can not be blank',
    darkmode_light_des: 'Light',
    darkmode_dark_des: 'Dark',
    local_auth_title: 'Authenticate to access the app',
    local_auth_warning:
        "Your device don't have any security method, set it again !",
    no_available: 'No available',
    cat_icon_validator: 'Please choose an icon',
    cat_name_validator: 'Please enter category name',
    advanced_settings: 'Advanced settings',
    fixed_in_ex: 'Set up fixed income and expense',
    fixed_in_ex_des: 'Automating recurring income and expense entries',
    delete_all_schedule: 'Delete all schedule ?',
    no_set_up_yet: 'No set up yet !',
    set_up: 'Set up',
    select_category: 'Select category:',
    repeat: 'Repeat:',
    never_repeat: 'Never',
    daily: 'Daily',
    weekly: 'Weekly',
    monthly: 'Monthly',
    yearly: 'Yearly',
    pay_by_e_wallet: 'Pay by e-wallet',
    pay_by_e_wallet_des: 'Payment is via e-wallet, and saved as an expense',
    pay_by_e_wallet_title: 'Choose a e-wallet',
    payment_method_title: 'Payment method',
    payment_method_qr: 'QR Code',
    payment_method_new: 'New beneficiary',
    paypal_account_holder: 'Account holder',
    paypal_content_billing: 'Content billing',
    option_category: 'Category (optional):',
    check_out: 'Check out',
    paypal_success: 'Payment success',
    paypal_fail: 'Payment fail',
    paypal_cancel: 'Payment cancel',

    setting_limit_title: 'Spending limit',
    setting_limit_des: 'Set limit for each spending category',
    restore_limit: 'Restore',
    restore_all_limit_title: 'Restore all limit',
    no_limit: 'No limit yet',
    limit_dialog: 'Set limit for',
    over_limit: 'Exceeded the expense limit of',
    over: 'over',
    limit_success: 'Set limit success',
    limit_fail: 'Set limit fail',
    restore_limit_success: 'Restore limit success',
    restore_limit_fail: 'Restore limit fail',
    restore_all_limit_success: 'Restore all limit success',
    restore_all_limit_fail: 'Restore all limit fail',
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
    appearance: 'Giao diện',
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
    op_cn: 'Tiếng Trung',
    email: 'Địa chỉ email',
    password: 'Mật khẩu',
    forgot_pass: 'Quên mật khẩu ?',
    login: 'Đăng nhập',
    dont_have_acc: "Bạn không có tài khoản ?",
    sign_up: 'Đăng ký',
    or_sign_in: 'Hoặc đăng nhập bằng:',
    sign_in_gg: 'Đăng nhập với Google',
    delete_all_data_acc: 'Xoá tất cả dữ liệu',
    delete_all_data_acc_des: 'Dữ liệu nhập vào, danh mục,... của bạn sẽ bị xoá',
    delete_acc: 'Xoá tài khoản',
    delete_acc_des: 'Tài khoản của bạn sẽ không còn tồn tại',
    toast_add_success: 'Tạo thành công!',
    toast_update_success: 'Cập nhật thành công!',
    toast_delete_success: 'Xoá thành công!',
    toast_add_fail: 'Tạo thất bại!',
    toast_update_fail: 'Cập nhật thất bại!',
    toast_delete_fail: 'Xoá thất bại!',
    toast_delete_user_fail: 'Xoá người dùng thất bại! (Đăng nhập và thử lại)',
    toast_login_success: 'Đăng nhập thành công!',
    toast_login_fail: 'Sai tên người dùng hoặc mật khẩu!',
    toast_sign_up_success:
        'Đăng ký thành công, kiểm tra liên kết trong email của bạn để xác minh!',
    toast_sign_up_weakpass: 'Mật khẩu quá yếu!',
    toast_user_exist: 'Email đã tồn tại',
    toast_not_found: 'Không tìm thấy!',
    toast_verify_email:
        'Tài khoản của bạn chưa được xác minh, kiểm tra liên kết trong email của bạn!',
    toast_user_not_exist: 'Người dùng không tồn tại!',
    cat_validator: 'Chưa có danh mục nào được chọn !',
    des_validator: 'Trường mô tả không được để trống',
    money_validator: 'Trường số tiền không được để trống',
    darkmode_light_des: 'Sáng',
    darkmode_dark_des: 'Tối',
    local_auth_title: 'Xác thực để truy cập ứng dụng',
    local_auth_warning:
        "Thiết bị của bạn không có bất kỳ phương thức bảo mật nào, hãy thiết lập lại!",
    no_available: 'Không có sẵn',
    cat_icon_validator: 'Vui lòng chọn một biểu tượng',
    cat_name_validator: 'Vui lòng nhập tên danh mục',
    advanced_settings: 'Cài đặt nâng cao',
    fixed_in_ex: 'Thiết lập thu nhập và chi phí cố định',
    fixed_in_ex_des: 'Tự động hóa các mục thu nhập và chi phí định kỳ',
    delete_all_schedule: 'Xóa tất cả lịch trình ?',
    no_set_up_yet: 'Chưa thiết lập !',
    set_up: 'Thiết lập',
    select_category: 'Chọn danh mục:',
    repeat: 'Lặp lại:',
    never_repeat: 'Không bao giờ',
    daily: 'Hàng ngày',
    weekly: 'Hàng tuần',
    monthly: 'Hàng tháng',
    yearly: 'Hàng năm',
    pay_by_e_wallet: 'Thanh toán bằng ví điện tử',
    pay_by_e_wallet_des:
        'Thanh toán qua ví điện tử và được lưu dưới dạng chi phí',
    pay_by_e_wallet_title: 'Chọn ví điện tử',
    payment_method_title: 'Phương thức thanh toán',
    payment_method_qr: 'Mã QR',
    payment_method_new: 'Người thụ hưởng mới',
    paypal_account_holder: 'Chủ tài khoản',
    paypal_content_billing: 'Nội dung thanh toán',
    option_category: 'Danh mục (Không bắt buộc):',
    check_out: 'Thanh toán',
    paypal_success: 'Thanh toán thành công',
    paypal_fail: 'Thanh toán không thành công',
    paypal_cancel: 'Hủy thanh toán',

    setting_limit_title: 'Giới hạn chi tiêu',
    setting_limit_des: 'Thiết lập giới hạn cho mỗi danh mục chi tiêu',
    restore_all_limit_title: 'Khôi phục tất cả giới hạn',
    restore_limit: 'Khôi phục',
    no_limit: 'Chưa có giới hạn',
    limit_dialog: 'Thiết lập giới hạn cho',
    over_limit: 'Vượt giới hạn chi tiêu của',
    over: 'vượt',
    limit_success: 'Thiết lập giới hạn thành công',
    limit_fail: 'Thiết lập giới hạn thất bại',
    restore_limit_success: 'Khôi phục giới hạn thành công',
    restore_limit_fail: 'Khôi phục giới hạn thất bại',
    restore_all_limit_success: 'Khôi phục tất cả giới hạn thành công',
    restore_all_limit_fail: 'Khôi phục tất cả giới hạn thất bại',
  };

  static const Map<String, dynamic> CN = {
    home: '首页',
    input: '输入',
    search: '搜索',
    chart: '图表',
    setting: '设置',
    hello_home_appbar: '你好，',
    total_saving: '总额：',
    income: '收入',
    expense: '支出',
    no_input_data: '暂无输入数据！',
    slide_edit: '编辑',
    slide_delete: '删除',
    input_description: '描述',
    input_money: '金额',
    income_category: '收入分类',
    expense_category: '支出分类',
    more: '更多...',
    input_save: '保存',
    in_category_manage_appbar: '收入分类管理',
    ex_category_manage_appbar: '支出分类管理',
    in_delete_all_title: '删除所有收入分类？',
    ex_delete_all_title: '删除所有支出分类？',
    confirm: '确认',
    cancel: '取消',
    add_cat_dialog_title: '添加新分类',
    choose_an_icon: '选择一个图标',
    category_name: '分类名称',
    update_cat_title: '更新分类',
    update: '更新',
    type_any_to_search: '输入搜索内容...',
    switch_monthly: '按月',
    switch_yearly: '按年',
    modify: '修改',
    modify_des: '点击以更改您的资料',
    language: '语言',
    currency: '货币',
    appearance: '展示',
    application_lock: '应用程序锁',
    application_lock_des: '打开时使用密码或面容识别',
    privacy: '隐私',
    privacy_des: '更多隐私选项',
    about: '关于',
    about_des: '了解更多关于 Money Mate 的信息',
    send_feedback: '发送反馈',
    send_feedback_des: '告诉我们您对应用的体验',
    log_out: '退出登录',
    no_cat_yet: '尚无分类！',
    log_out_dialog: '确定要退出登录吗？',
    language_appbar: '语言',
    language_des: '中文',
    op_en: '英语',
    op_vi: '越南语',
    op_cn: '中国人',
    email: '电子邮件',
    password: '密码',
    forgot_pass: '忘记密码？',
    login: '登录',
    dont_have_acc: "没有账户？",
    sign_up: '注册',
    or_sign_in: '或使用以下方式登录：',
    sign_in_gg: '使用 Google 登录',
    delete_all_data_acc: '删除所有数据',
    delete_all_data_acc_des: '您的输入、分类等数据将被删除',
    delete_acc: '删除账户',
    delete_acc_des: '您的账户将不再存在',
    toast_add_success: '创建成功！',
    toast_update_success: '更新成功！',
    toast_delete_success: '删除成功！',
    toast_add_fail: '创建失败！',
    toast_update_fail: '更新失败！',
    toast_delete_fail: '删除失败！',
    toast_delete_user_fail: '删除用户失败！（请登录并重试）',
    toast_login_success: '登录成功！',
    toast_login_fail: '用户名或密码错误！',
    toast_sign_up_success: '注册成功，请查看您的电子邮件中的链接以进行验证！',
    toast_sign_up_weakpass: '密码太弱！',
    toast_user_exist: '电子邮件已存在',
    toast_not_found: '未找到！',
    toast_verify_email: '您的帐户尚未验证，请检查您的电子邮件中的链接！',
    toast_user_not_exist: '用户不存在！',
    cat_validator: '尚未选择类别！',
    des_validator: '描述字段不能为空',
    money_validator: '金钱字段不能为空',
    darkmode_light_des: '明亮',
    darkmode_dark_des: '暗',
    local_auth_title: '授权以访问应用',
    local_auth_warning: "您的设备没有任何安全方法，请重新设置！",
    no_available: '暂无可用',
    cat_icon_validator: '请选择一个图标',
    cat_name_validator: '请输入类别名称',
    advanced_settings: '高级设置',
    fixed_in_ex: '设置固定收入和支出',
    fixed_in_ex_des: '自动生成经常性收入和支出条目',
    delete_all_schedule: '删除所有日程？',
    no_set_up_yet: '尚未设置！',
    set_up: '设置',
    select_category: '选择类别：',
    repeat: '重复：',
    never_repeat: '从不',
    daily: '每日',
    weekly: '每周',
    monthly: '每月',
    yearly: '每年',
    pay_by_e_wallet: '通过电子钱包支付',
    pay_by_e_wallet_des: '通过电子钱包付款，并保存为费用',
    pay_by_e_wallet_title: '选择电子钱包',
    payment_method_title: '付款方式',
    payment_method_qr: '二维码',
    payment_method_new: '新受益人',
    paypal_account_holder: '账户持有人',
    paypal_content_billing: '内容计费',
    option_category: '类别（可选）：',
    check_out: '签出',
    paypal_success: '支付成功',
    paypal_fail: '支付失败',
    paypal_cancel: '取消付款',
    setting_limit_title: '限制',
    setting_limit_des: '为每个类别设置限制',
    restore_all_limit_title: '恢复所有限制',
    restore_limit: '恢复',
    no_limit: '无限制',
    limit_dialog: '为',
    over_limit: '超过限制',
    over: '超过',
    limit_success: '限制设置成功',
    limit_fail: '限制设置失败',
    restore_limit_success: '恢复限制成功',
    restore_limit_fail: '恢复限制失败',
    restore_all_limit_success: '恢复所有限制成功',
    restore_all_limit_fail: '恢复所有限制失败',
  };
}
