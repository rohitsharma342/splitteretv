class AppConstants {
  // App Info
  static const String appName = 'SplitteretV';
  static const String appVersion = '1.0.0';
  
  // Spacing
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Border Radius
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  // Categories
  static const List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Travel',
    'Education',
    'Groceries',
    'Other',
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'PayPal',
    'Venmo',
    'Bank Transfer',
  ];
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // API Endpoints (if needed for external services)
  static const String baseUrl = 'https://api.splitteretv.com';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 200;
  
  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '$';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
}