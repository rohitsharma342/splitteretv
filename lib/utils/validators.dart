class Validators {
  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Email validation (simplified - no regex)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final email = value.trim();
    
    // Basic email validation without regex
    if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid email address';
    }
    
    // Check for basic email structure
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return 'Please enter a valid email address';
    }
    
    final domain = parts[1];
    if (!domain.contains('.') || domain.startsWith('.') || domain.endsWith('.')) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    
    final phone = value.trim().replaceAll(RegExp(r'[^0-9+]'), '');
    
    if (phone.length < 10) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Amount validation
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (amount > 999999.99) {
      return 'Amount is too large';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    final name = value.trim();
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (name.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    return null;
  }
  
  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Description is optional
    }
    
    if (value.trim().length > 500) {
      return 'Description must be less than 500 characters';
    }
    
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }
    
    final url = value.trim().toLowerCase();
    
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'URL must start with http:// or https://';
    }
    
    return null;
  }
  
  // Custom validation for specific business rules
  static String? validateSplitAmount(String? value, double totalAmount) {
    final amountValidation = validateAmount(value);
    if (amountValidation != null) {
      return amountValidation;
    }
    
    final amount = double.parse(value!);
    if (amount > totalAmount) {
      return 'Split amount cannot exceed total amount';
    }
    
    return null;
  }
  
  // Validate that splits equal total amount
  static String? validateTotalSplits(List<double> splits, double totalAmount) {
    final splitTotal = splits.fold<double>(0.0, (sum, amount) => sum + amount);
    final difference = (splitTotal - totalAmount).abs();
    
    if (difference > 0.01) { // Allow for small rounding differences
      return 'Split amounts must equal the total amount';
    }
    
    return null;
  }
}