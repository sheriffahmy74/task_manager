// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مدير المهام';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get nameHint => 'أدخل اسمك الكامل';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get hasAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get welcomeBackSub => 'سجّل الدخول للمتابعة';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountSub => 'انضم إلينا وابدأ الآن';

  @override
  String get registeredSuccess => 'تم إنشاء الحساب! سجّل الدخول من فضلك.';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordTooShort => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get nameTooShort => 'الاسم يجب أن يكون حرفين على الأقل';

  @override
  String get projects => 'المشاريع';

  @override
  String get noProjects => 'لا توجد مشاريع بعد';

  @override
  String get noProjectsSub => 'أنشئ أول مشروع لتبدأ';

  @override
  String get viewTasks => 'عرض المهام';

  @override
  String get addProject => 'إضافة مشروع';

  @override
  String get projectName => 'اسم المشروع';

  @override
  String get projectNameHint => 'أدخل اسم المشروع';

  @override
  String get description => 'الوصف';

  @override
  String get descriptionHint => 'أدخل وصفاً (اختياري)';

  @override
  String get projectAdded => 'تم إنشاء المشروع بنجاح';

  @override
  String get tasks => 'المهام';

  @override
  String get noTasks => 'لا توجد مهام بعد';

  @override
  String get noTasksSub => 'أضف أول مهمة لتبدأ';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get taskTitle => 'عنوان المهمة';

  @override
  String get taskTitleHint => 'أدخل عنوان المهمة';

  @override
  String get priority => 'الأولوية';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String tasksCount(int count) {
    return '$count مهمة';
  }

  @override
  String get taskAdded => 'تمت إضافة المهمة بنجاح';

  @override
  String get taskUpdated => 'تم تحديث المهمة بنجاح';

  @override
  String get statusToDo => 'قيد الانتظار';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get statusDone => 'مكتملة';

  @override
  String get statusPending => 'معلّقة';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusOnHold => 'متوقّف';

  @override
  String get priorityLow => 'منخفضة';

  @override
  String get priorityMedium => 'متوسطة';

  @override
  String get priorityHigh => 'عالية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get retry => 'إعادة المحاولة';
}
