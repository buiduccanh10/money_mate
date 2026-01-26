import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> locales = [
  MapLocale('vi', LocaleData.vi),
  MapLocale('en', LocaleData.en),
  MapLocale('zh', LocaleData.cn),
];

mixin LocaleData {
  //GNav (navigator)
  static const String home = 'home';
  static const String input = 'input';
  static const String search = 'search';
  static const String chart = 'chart';
  static const String setting = 'setting';

  //home page
  static const String helloHomeAppbar = 'helloHomeAppbar';
  static const String totalSaving = 'totalSaving';
  static const String noInputData = 'noInputData';
  static const String noAvailable = 'noAvailable';

  //slideable
  static const String slideEdit = 'slideEdit';
  static const String slideDelete = 'slideDelete';

  //switch
  static const String switchMonthly = 'switchMonthly';
  static const String switchYearly = 'switchYearly';

  //input page
  static const String inputDescription = 'inputDescription';
  static const String inputMoney = 'inputMoney';
  static const String incomeCategory = 'incomeCategory category';
  static const String expenseCategory = 'expenseCategory';
  static const String more = 'more';
  static const String inputVave = 'inputVave';
  static const String desValidator = 'desValidator';
  static const String moneyValidator = 'moneyValidator';
  static const String catValidator = 'catValidator';

  //category manage page
  static const String income = 'income';
  static const String expense = 'expense';
  static const String inCategoryManageAppbar = 'in_category manage';
  static const String exCategoryManageAppbar = 'ex_category manage';
  static const String inDeleteAllTitle = 'inDeleteAllTitle';
  static const String exDeleteAllTitle = 'exDeleteAllTitle';
  static const String noCatYet = 'noCatYet';
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  //add cat dialog
  static const String addCatDialogTitle = 'addCatDialogTitle';
  static const String chooseAnIcon = 'chooseAnIcon';
  static const String categoryName = 'categoryName';
  static const String addCat = 'addCat';
  static const String updateCatTitle = 'updateCatTitle';
  static const String update = 'update';
  static const String catIconValidator = 'catIconValidator';
  static const String catNameValidator = 'catNameValidator';

  //search page
  static const String typeAnyToSearch = 'typeAnyToSearch';

  //setting page
  static const String modify = 'modify';
  static const String modifyDes = 'modifyDes';
  static const String language = 'language';
  static const String languageAppbar = 'languageAppbar';
  static const String languageDes = 'languageDes';
  static const String opEn = 'opEn';
  static const String opVi = 'opVi';
  static const String opCn = 'opCn';
  static const String currency = 'currency';
  static const String appearance = 'appearance';
  static const String darkmodeLightDes = 'darkmodeLightDes';
  static const String darkmodeDarkDes = 'darkmodeDarkDes';
  static const String applicationLock = 'applicationLock';
  static const String applicationLockDes = 'applicationLockDes';
  static const String privacy = 'privacy';
  static const String privacyDes = 'privacyDes';
  static const String about = 'about';
  static const String aboutDes = 'aboutDes';
  static const String sendFeedback = 'sendFeedback';
  static const String sendFeedbackDes = 'sendFeedbackDes';
  static const String logOut = 'logOut';
  static const String logOutDialog = 'logOutDialog';
  static const String deleteAllDataAcc = 'deleteAllDataAcc';
  static const String deleteAllDataAccDes = 'deleteAllDataAccDes';
  static const String deleteAcc = 'deleteAcc';
  static const String deleteAccDes = 'deleteAccDes';
  static const String advancedSettings = 'advancedSettings';
  static const String settingLimitTitle = 'setting_limit_tile';
  static const String settingLimitDes = 'settingLimitDes';
  static const String restoreAllLimitTitle = 'restoreAllLimitTitle';
  static const String restoreLimit = 'restoreLimit';
  static const String noLimit = 'noLimit';
  static const String limitDialog = 'limitDialog';
  static const String overLimit = 'overLimit';
  static const String over = 'over';
  static const String limitSuccess = 'limitSuccess';
  static const String limitFail = 'limitFail';
  static const String restorelimitSuccess = 'restorelimitSuccess';
  static const String restorelimitFail = 'restorelimitFail';
  static const String restoreAllLimitSuccess = 'restoreAllLimitSuccess';
  static const String restoreAllLimitFail = 'restoreAllLimitFail';

  //fixed income and expense
  static const String fixedInEx = 'fixedInEx';
  static const String fixedInExDes = 'fixedInExDes';
  static const String setUp = 'setUp';
  static const String noSetUpYet = 'noSetUpYet';
  static const String deleteAllSchedule = 'deleteAllSchedule';
  static const String selectCategory = 'selectCategory';
  static const String repeat = 'repeat';
  static const String neverRepeat = 'neverRepeat';
  static const String daily = 'daily';
  static const String monthly = 'monthly';
  static const String weekly = 'weekly';
  static const String yearly = 'yearly';

  //pay by e-wallet
  static const String payByEWallet = 'payByEWallet';
  static const String payByEWalletDes = 'payByEWalletDes';
  static const String payByEWalletTitle = 'payByEWalletTitle';
  static const String paymentMethodTitle = 'paymentMethodTitle';
  static const String paymentMethodQr = 'paymentMethodQr';
  static const String paymentMethodNew = 'paymentMethodNew';
  static const String paypalAccountHolder = 'paypalAccountHolder';
  static const String paypalContentBilling = 'paypalContentBilling';
  static const String optionCategory = 'optionCategory';
  static const String checkOut = 'checkOut';
  static const String paypalSuccess = 'paypalSuccess';
  static const String paypalFail = 'paypalFail';
  static const String paypalCancel = 'paypalCancel';

  //login
  static const String email = 'email';
  static const String password = 'password';
  static const String forgotPass = 'forgotPass';
  static const String login = 'login';
  static const String dontHaveAcc = 'dontHaveAcc';
  static const String signUp = 'signUp';
  static const String orSignIn = 'orSignIn';
  static const String signInGg = 'signInGg';

  //ftoast
  static const String toastAddSuccess = 'toastAddSuccess';
  static const String toastUpdateSuccess = 'toastUpdateSuccess';
  static const String toastDeleteSuccess = 'toastDeleteSuccess';
  static const String toastAddFail = 'toastAddFail';
  static const String toastUpdateFail = 'toastUpdateFail';
  static const String toastDeleteFail = 'toastDeleteFail';
  static const String toastDeleteUserFail = 'toastDeleteUserFail';
  static const String toastLoginSuccess = 'toastLoginSuccess';
  static const String toastLoginFail = 'toastLoginFail';
  static const String toastSignupSuccess = 'toastSignupSuccess';
  static const String toastSignupFail = 'toastSignupFail';
  static const String toastSignupWeakpass = 'toastSignupWeakpass';
  static const String toastUserExist = 'toastUserExist';
  static const String toastNotFound = 'toastNotFound';
  static const String toastVerifyEmail = 'toastVerifyEmail';
  static const String toastUserNotExist = 'toastUserNotExist';

  //local auth
  static const String localAuthTitle = 'localAuthTitle';
  static const String localAuthWarning = 'localAuthWarning';

  static const Map<String, dynamic> en = {
    home: 'Home',
    input: 'Input',
    search: 'Search',
    chart: 'Chart',
    setting: 'Setting',
    helloHomeAppbar: 'Hi, ',
    totalSaving: 'Total: ',
    income: 'Income',
    expense: 'Expense',
    noInputData: 'No input data yet !',
    slideEdit: 'Edit',
    slideDelete: 'Delete',
    inputDescription: 'Description',
    inputMoney: 'Money',
    incomeCategory: 'Income category',
    expenseCategory: 'Expense category',
    more: 'More...',
    inputVave: 'Save',
    inCategoryManageAppbar: 'Income category manage',
    exCategoryManageAppbar: 'Expense category manage',
    inDeleteAllTitle: 'Delete all income category ?',
    exDeleteAllTitle: 'Delete all expense category ?',
    confirm: 'Confirm',
    cancel: 'Cancel',
    addCatDialogTitle: 'Add a new category',
    chooseAnIcon: 'Choose an icon',
    categoryName: 'Category name',
    updateCatTitle: 'Update category',
    update: 'Update',
    typeAnyToSearch: 'Type any to search...',
    switchMonthly: 'Monthly',
    switchYearly: 'Yearly',
    modify: 'Modify',
    modifyDes: 'Tap to change your profile',
    language: 'Language',
    currency: 'Currency',
    appearance: 'Appearance',
    applicationLock: 'Application lock',
    applicationLockDes: 'Use Passwork or FaceID when open',
    privacy: 'Privacy',
    privacyDes: 'More privacy options',
    about: 'About',
    aboutDes: 'Learn more about Money Mate',
    sendFeedback: 'Send feedback',
    sendFeedbackDes: 'Let us know your experience about app',
    logOut: 'Log out',
    noCatYet: 'No category yet !',
    logOutDialog: 'Sign out your account ?',
    languageAppbar: 'Language',
    languageDes: 'English',
    opEn: 'English',
    opVi: 'Vietnamese',
    opCn: 'Chinese',
    email: 'Email',
    password: 'Password',
    forgotPass: 'Forgot your password ?',
    login: 'Log in',
    dontHaveAcc: "Don't you have account ?",
    signUp: 'Sign up',
    orSignIn: 'Or sign in with:',
    signInGg: 'Sign in with Google',
    deleteAllDataAcc: 'Delete all data',
    deleteAllDataAccDes: 'Your input, category,... data will be delete',
    deleteAcc: 'Delete account',
    deleteAccDes: 'Your account will no longer exist',
    toastAddSuccess: 'Create successfull !',
    toastUpdateSuccess: 'Update successfull !',
    toastDeleteSuccess: 'Delete successfull !',
    toastAddFail: 'Create fail !',
    toastUpdateFail: 'Update fail !',
    toastDeleteFail: 'Delete fail !',
    toastDeleteUserFail: 'Delete user fail ! (Login and try again)',
    toastLoginSuccess: 'Login successful !',
    toastLoginFail: 'Wrong user or password !',
    toastSignupSuccess:
        'Sign up successful, check the link in your email to verify !',
    toastSignupFail: 'Sign up failed !',
    toastSignupWeakpass: 'Password too weak !',
    toastUserExist: 'Email already exists',
    toastNotFound: 'Not found !',
    toastVerifyEmail: 'Your account not verify, check the link in your email !',
    toastUserNotExist: 'User is not exist !',
    catValidator: 'No category selected yet !',
    desValidator: 'Description field can not be blank',
    moneyValidator: 'Money field can not be blank',
    darkmodeLightDes: 'Light',
    darkmodeDarkDes: 'Dark',
    localAuthTitle: 'Authenticate to access the app',
    localAuthWarning:
        "Your device don't have any security method, set it again !",
    noAvailable: 'No available',
    catIconValidator: 'Please choose an icon',
    catNameValidator: 'Please enter category name',
    advancedSettings: 'Advanced settings',
    fixedInEx: 'Set up fixed income and expense',
    fixedInExDes: 'Automating recurring income and expense entries',
    deleteAllSchedule: 'Delete all schedule ?',
    noSetUpYet: 'No set up yet !',
    setUp: 'Set up',
    selectCategory: 'Select category:',
    repeat: 'Repeat:',
    neverRepeat: 'Never',
    daily: 'Daily',
    weekly: 'Weekly',
    monthly: 'Monthly',
    yearly: 'Yearly',
    payByEWallet: 'Pay by e-wallet',
    payByEWalletDes: 'Payment is via e-wallet, and saved as an expense',
    payByEWalletTitle: 'Choose a e-wallet',
    paymentMethodTitle: 'Payment method',
    paymentMethodQr: 'QR Code',
    paymentMethodNew: 'New beneficiary',
    paypalAccountHolder: 'Account holder',
    paypalContentBilling: 'Content billing',
    optionCategory: 'Category (optional):',
    checkOut: 'Check out',
    paypalSuccess: 'Payment success',
    paypalFail: 'Payment fail',
    paypalCancel: 'Payment cancel',
    settingLimitTitle: 'Spending limit',
    settingLimitDes: 'Set limit for each spending category',
    restoreLimit: 'Restore',
    restoreAllLimitTitle: 'Restore all limit',
    noLimit: 'No limit yet',
    limitDialog: 'Set limit for',
    overLimit: 'Exceeded the expense limit of',
    over: 'over',
    limitSuccess: 'Set limit success',
    limitFail: 'Set limit fail',
    restorelimitSuccess: 'Restore limit success',
    restorelimitFail: 'Restore limit fail',
    restoreAllLimitSuccess: 'Restore all limit success',
    restoreAllLimitFail: 'Restore all limit fail',
  };

  static const Map<String, dynamic> vi = {
    home: 'Trang chủ',
    input: 'Nhập',
    search: 'Tìm kiếm',
    chart: 'Biểu đồ',
    setting: 'Cài đặt',
    helloHomeAppbar: 'Xin chào, ',
    totalSaving: 'Tổng: ',
    income: 'Thu nhập',
    expense: 'Chi phí',
    noInputData: 'Chưa có dữ liệu nhập vào !',
    slideEdit: 'Sửa',
    slideDelete: 'Xoá',
    inputDescription: 'Mô tả',
    inputMoney: 'Tiền',
    incomeCategory: 'Danh mục thu nhập',
    expenseCategory: 'Danh mục chi phí',
    more: 'Thêm...',
    inputVave: 'Lưu',
    inCategoryManageAppbar: 'Quản lí danh mục thu nhập',
    exCategoryManageAppbar: 'Quản lí danh mục chi phí',
    inDeleteAllTitle: 'Xoá tất cả danh mục thu nhập ?',
    exDeleteAllTitle: 'Xoá tất cả danh mục chi phí ?',
    confirm: 'Xác nhận',
    cancel: 'Huỷ',
    addCatDialogTitle: 'Thêm một danh mục mới',
    chooseAnIcon: 'Chọn một biểu tượng',
    categoryName: 'Tên danh mục',
    updateCatTitle: 'Cập nhật danh mục',
    update: 'Cập nhật',
    typeAnyToSearch: 'Nhập bất kì để tìm kiếm...',
    switchMonthly: 'Hàng tháng',
    switchYearly: 'Hàng năm',
    modify: 'Chỉnh sửa',
    modifyDes: 'Nhấn để thay đổi hồ sơ của bạn',
    language: 'Ngôn ngữ',
    currency: 'Tiền tệ',
    appearance: 'Giao diện',
    applicationLock: 'Khoá ứng dụng',
    applicationLockDes: 'Sử dụng mật khẩu hoặc FaceID khi mở ứng dụng',
    privacy: 'Quyền riêng tư',
    privacyDes: 'Thêm lựa chọn quyền riêng tư',
    about: 'Giới thiệu',
    aboutDes: 'Tìm hiểu thêm về Money Mate',
    sendFeedback: 'Gửi nhận xét',
    sendFeedbackDes: 'Cho chúng tôi biết trải nghiệm của bạn về ứng dụng',
    logOut: 'Đăng xuất',
    noCatYet: 'Chưa có danh mục nào !',
    logOutDialog: 'Đăng xuất tài khoản của bạn ?',
    languageAppbar: 'Ngôn ngữ',
    languageDes: 'Tiếng Việt',
    opEn: 'Tiếng Anh',
    opVi: 'Tiếng Việt',
    opCn: 'Tiếng Trung',
    email: 'Địa chỉ email',
    password: 'Mật khẩu',
    forgotPass: 'Quên mật khẩu ?',
    login: 'Đăng nhập',
    dontHaveAcc: "Bạn không có tài khoản ?",
    signUp: 'Đăng ký',
    orSignIn: 'Hoặc đăng nhập bằng:',
    signInGg: 'Đăng nhập với Google',
    deleteAllDataAcc: 'Xoá tất cả dữ liệu',
    deleteAllDataAccDes: 'Dữ liệu nhập vào, danh mục,... của bạn sẽ bị xoá',
    deleteAcc: 'Xoá tài khoản',
    deleteAccDes: 'Tài khoản của bạn sẽ không còn tồn tại',
    toastAddSuccess: 'Tạo thành công!',
    toastUpdateSuccess: 'Cập nhật thành công!',
    toastDeleteSuccess: 'Xoá thành công!',
    toastAddFail: 'Tạo thất bại!',
    toastUpdateFail: 'Cập nhật thất bại!',
    toastDeleteFail: 'Xoá thất bại!',
    toastDeleteUserFail: 'Xoá người dùng thất bại! (Đăng nhập và thử lại)',
    toastLoginSuccess: 'Đăng nhập thành công!',
    toastLoginFail: 'Sai tên người dùng hoặc mật khẩu!',
    toastSignupSuccess:
        'Đăng ký thành công, kiểm tra liên kết trong email của bạn để xác minh!',
    toastSignupFail: 'Đăng ký thất bại!',
    toastSignupWeakpass: 'Mật khẩu quá yếu!',
    toastUserExist: 'Email đã tồn tại',
    toastNotFound: 'Không tìm thấy!',
    toastVerifyEmail:
        'Tài khoản của bạn chưa được xác minh, kiểm tra liên kết trong email của bạn!',
    toastUserNotExist: 'Người dùng không tồn tại!',
    catValidator: 'Chưa có danh mục nào được chọn !',
    desValidator: 'Trường mô tả không được để trống',
    moneyValidator: 'Trường số tiền không được để trống',
    darkmodeLightDes: 'Sáng',
    darkmodeDarkDes: 'Tối',
    localAuthTitle: 'Xác thực để truy cập ứng dụng',
    localAuthWarning:
        "Thiết bị của bạn không có bất kỳ phương thức bảo mật nào, hãy thiết lập lại!",
    noAvailable: 'Không có sẵn',
    catIconValidator: 'Vui lòng chọn một biểu tượng',
    catNameValidator: 'Vui lòng nhập tên danh mục',
    advancedSettings: 'Cài đặt nâng cao',
    fixedInEx: 'Thiết lập thu nhập và chi phí cố định',
    fixedInExDes: 'Tự động hóa các mục thu nhập và chi phí định kỳ',
    deleteAllSchedule: 'Xóa tất cả lịch trình ?',
    noSetUpYet: 'Chưa thiết lập !',
    setUp: 'Thiết lập',
    selectCategory: 'Chọn danh mục:',
    repeat: 'Lặp lại:',
    neverRepeat: 'Không bao giờ',
    daily: 'Hàng ngày',
    weekly: 'Hàng tuần',
    monthly: 'Hàng tháng',
    yearly: 'Hàng năm',
    payByEWallet: 'Thanh toán bằng ví điện tử',
    payByEWalletDes: 'Thanh toán qua ví điện tử và được lưu dưới dạng chi phí',
    payByEWalletTitle: 'Chọn ví điện tử',
    paymentMethodTitle: 'Phương thức thanh toán',
    paymentMethodQr: 'Mã QR',
    paymentMethodNew: 'Người thụ hưởng mới',
    paypalAccountHolder: 'Chủ tài khoản',
    paypalContentBilling: 'Nội dung thanh toán',
    optionCategory: 'Danh mục (Không bắt buộc):',
    checkOut: 'Thanh toán',
    paypalSuccess: 'Thanh toán thành công',
    paypalFail: 'Thanh toán không thành công',
    paypalCancel: 'Hủy thanh toán',
    settingLimitTitle: 'Giới hạn chi tiêu',
    settingLimitDes: 'Thiết lập giới hạn cho mỗi danh mục chi tiêu',
    restoreAllLimitTitle: 'Khôi phục tất cả giới hạn',
    restoreLimit: 'Khôi phục',
    noLimit: 'Chưa có giới hạn',
    limitDialog: 'Thiết lập giới hạn cho',
    overLimit: 'Vượt giới hạn chi tiêu của',
    over: 'vượt',
    limitSuccess: 'Thiết lập giới hạn thành công',
    limitFail: 'Thiết lập giới hạn thất bại',
    restorelimitSuccess: 'Khôi phục giới hạn thành công',
    restorelimitFail: 'Khôi phục giới hạn thất bại',
    restoreAllLimitSuccess: 'Khôi phục tất cả giới hạn thành công',
    restoreAllLimitFail: 'Khôi phục tất cả giới hạn thất bại',
  };

  static const Map<String, dynamic> cn = {
    home: '首页',
    input: '输入',
    search: '搜索',
    chart: '图表',
    setting: '设置',
    helloHomeAppbar: '你好，',
    totalSaving: '总额：',
    income: '收入',
    expense: '支出',
    noInputData: '暂无输入数据！',
    slideEdit: '编辑',
    slideDelete: '删除',
    inputDescription: '描述',
    inputMoney: '金额',
    incomeCategory: '收入分类',
    expenseCategory: '支出分类',
    more: '更多...',
    inputVave: '保存',
    inCategoryManageAppbar: '收入分类管理',
    exCategoryManageAppbar: '支出分类管理',
    inDeleteAllTitle: '删除所有收入分类？',
    exDeleteAllTitle: '删除所有支出分类？',
    confirm: '确认',
    cancel: '取消',
    addCatDialogTitle: '添加新分类',
    chooseAnIcon: '选择一个图标',
    categoryName: '分类名称',
    updateCatTitle: '更新分类',
    update: '更新',
    typeAnyToSearch: '输入搜索内容...',
    switchMonthly: '按月',
    switchYearly: '按年',
    modify: '修改',
    modifyDes: '点击以更改您的资料',
    language: '语言',
    currency: '货币',
    appearance: '展示',
    applicationLock: '应用程序锁',
    applicationLockDes: '打开时使用密码或面容识别',
    privacy: '隐私',
    privacyDes: '更多隐私选项',
    about: '关于',
    aboutDes: '了解更多关于 Money Mate 的信息',
    sendFeedback: '发送反馈',
    sendFeedbackDes: '告诉我们您对应用的体验',
    logOut: '退出登录',
    noCatYet: '尚无分类！',
    logOutDialog: '确定要退出登录吗？',
    languageAppbar: '语言',
    languageDes: '中文',
    opEn: '英语',
    opVi: '越南语',
    opCn: '中国人',
    email: '电子邮件',
    password: '密码',
    forgotPass: '忘记密码？',
    login: '登录',
    dontHaveAcc: "没有账户？",
    signUp: '注册',
    orSignIn: '或使用以下方式登录：',
    signInGg: '使用 Google 登录',
    deleteAllDataAcc: '删除所有数据',
    deleteAllDataAccDes: '您的输入、分类等数据将被删除',
    deleteAcc: '删除账户',
    deleteAccDes: '您的账户将不再存在',
    toastAddSuccess: '创建成功！',
    toastUpdateSuccess: '更新成功！',
    toastDeleteSuccess: '删除成功！',
    toastAddFail: '创建失败！',
    toastUpdateFail: '更新失败！',
    toastDeleteFail: '删除失败！',
    toastDeleteUserFail: '删除用户失败！（请登录并重试）',
    toastLoginSuccess: '登录成功！',
    toastLoginFail: '用户名或密码错误！',
    toastSignupSuccess: '注册成功，请查看您的电子邮件中的链接以进行验证！',
    toastSignupFail: '注册失败！',
    toastSignupWeakpass: '密码太弱！',
    toastUserExist: '电子邮件已存在',
    toastNotFound: '未找到！',
    toastVerifyEmail: '您的帐户尚未验证，请检查您的电子邮件中的链接！',
    toastUserNotExist: '用户不存在！',
    catValidator: '尚未选择类别！',
    desValidator: '描述字段不能为空',
    moneyValidator: '金钱字段不能为空',
    darkmodeLightDes: '明亮',
    darkmodeDarkDes: '暗',
    localAuthTitle: '授权以访问应用',
    localAuthWarning: "您的设备没有任何安全方法，请重新设置！",
    noAvailable: '暂无可用',
    catIconValidator: '请选择一个图标',
    catNameValidator: '请输入类别名称',
    advancedSettings: '高级设置',
    fixedInEx: '设置固定收入和支出',
    fixedInExDes: '自动生成经常性收入和支出条目',
    deleteAllSchedule: '删除所有日程？',
    noSetUpYet: '尚未设置！',
    setUp: '设置',
    selectCategory: '选择类别：',
    repeat: '重复：',
    neverRepeat: '从不',
    daily: '每日',
    weekly: '每周',
    monthly: '每月',
    yearly: '每年',
    payByEWallet: '通过电子钱包支付',
    payByEWalletDes: '通过电子钱包付款，并保存为费用',
    payByEWalletTitle: '选择电子钱包',
    paymentMethodTitle: '付款方式',
    paymentMethodQr: '二维码',
    paymentMethodNew: '新受益人',
    paypalAccountHolder: '账户持有人',
    paypalContentBilling: '内容计费',
    optionCategory: '类别（可选）：',
    checkOut: '签出',
    paypalSuccess: '支付成功',
    paypalFail: '支付失败',
    paypalCancel: '取消付款',
    settingLimitTitle: '限制',
    settingLimitDes: '为每个类别设置限制',
    restoreAllLimitTitle: '恢复所有限制',
    restoreLimit: '恢复',
    noLimit: '无限制',
    limitDialog: '为',
    overLimit: '超过限制',
    over: '超过',
    limitSuccess: '限制设置成功',
    limitFail: '限制设置失败',
    restorelimitSuccess: '恢复限制成功',
    restorelimitFail: '恢复限制失败',
    restoreAllLimitSuccess: '恢复所有限制成功',
    restoreAllLimitFail: '恢复所有限制失败',
  };
}
