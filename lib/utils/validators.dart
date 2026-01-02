class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter a valid positive amount';
    }
    
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    const pattern = r'^[\+]?[1-9]([\d\s\-\(\)]{8,20})$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    
    return null;
  }
  
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    
    if (value.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }
    
    return null;
  }
}