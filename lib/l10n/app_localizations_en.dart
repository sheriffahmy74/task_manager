// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Task Manager';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get nameHint => 'Enter your full name';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get hasAccount => 'Already have an account? ';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get welcomeBackSub => 'Sign in to continue';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSub => 'Join us and get started';

  @override
  String get registeredSuccess => 'Account created! Please login.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get projects => 'Projects';

  @override
  String get noProjects => 'No Projects Yet';

  @override
  String get noProjectsSub => 'Create your first project to get started';

  @override
  String get viewTasks => 'View tasks';

  @override
  String get addProject => 'Add Project';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectNameHint => 'Enter project name';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Enter a description (optional)';

  @override
  String get projectAdded => 'Project created successfully';

  @override
  String get tasks => 'Tasks';

  @override
  String get noTasks => 'No Tasks Yet';

  @override
  String get noTasksSub => 'Add your first task to get started';

  @override
  String get addTask => 'Add Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskTitleHint => 'Enter task title';

  @override
  String get priority => 'Priority';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String tasksCount(int count) {
    return '$count tasks';
  }

  @override
  String get taskAdded => 'Task added successfully';

  @override
  String get taskUpdated => 'Task updated successfully';

  @override
  String get statusToDo => 'To Do';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusDone => 'Done';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusActive => 'Active';

  @override
  String get statusOnHold => 'On Hold';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get profile => 'Profile';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get retry => 'Retry';
}
