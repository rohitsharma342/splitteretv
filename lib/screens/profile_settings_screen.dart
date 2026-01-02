import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_app_bar.dart';
import 'dashboard_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _reminderNotifications = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  void _loadUserData() {
    final userController = context.read<UserController>();
    final currentUser = userController.currentUser;
    
    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _emailController.text = currentUser.email;
      _phoneController.text = currentUser.phone ?? '';
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Profile & Settings',
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          final currentUser = userController.currentUser;
          
          if (currentUser == null) {
            return const Center(
              child: Text(
                'No user data available',
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 16,
                ),
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(currentUser, userController),
                const SizedBox(height: AppConstants.largePadding),
                _buildNotificationSettings(),
                const SizedBox(height: AppConstants.largePadding),
                _buildPaymentMethods(),
                const SizedBox(height: AppConstants.largePadding),
                _buildAccountActions(userController),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildProfileSection(dynamic currentUser, UserController userController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                currentUser.avatar != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(currentUser.avatar!),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          currentUser.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Manage your personal information',
                        style: TextStyle(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                    ),
                    validator: (value) => Validators.validateRequired(value, 'Name'),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                    ),
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: userController.isLoading
                          ? null
                          : () => _saveProfile(userController),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: userController.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const Text(
              'Choose how you want to be notified',
              style: TextStyle(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            SwitchListTile(
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
              title: const Text('Email Notifications'),
              subtitle: const Text('Get notified about new expenses and payments'),
              activeColor: AppColors.primary,
            ),
            SwitchListTile(
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive instant notifications on your device'),
              activeColor: AppColors.primary,
            ),
            SwitchListTile(
              value: _reminderNotifications,
              onChanged: (value) {
                setState(() {
                  _reminderNotifications = value;
                });
              },
              title: const Text('Payment Reminders'),
              subtitle: const Text('Get reminders about pending payments'),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaymentMethods() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: _addPaymentMethod,
                  child: const Text('Add Method'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const Text(
              'Manage your payment methods for settling expenses',
              style: TextStyle(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            ...AppConstants.paymentMethods.map(
              (method) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    _getPaymentMethodIcon(method),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(method),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textLight,
                ),
                onTap: () {
                  // Handle payment method selection
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAccountActions(UserController userController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.info,
                child: Icon(
                  Icons.help_outline,
                  color: AppColors.textWhite,
                ),
              ),
              title: const Text('Help & Support'),
              subtitle: const Text('Get help and contact support'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
              onTap: () {
                // Handle help & support
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.warning,
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: AppColors.textWhite,
                ),
              ),
              title: const Text('Privacy Policy'),
              subtitle: const Text('Read our privacy policy'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
              onTap: () {
                // Handle privacy policy
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.error,
                child: Icon(
                  Icons.logout,
                  color: AppColors.textWhite,
                ),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _showLogoutDialog(userController),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.payments;
      case 'credit card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'venmo':
        return Icons.phone_android;
      case 'bank transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }
  
  Future<void> _saveProfile(UserController userController) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    try {
      await userController.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  void _addPaymentMethod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add payment method feature coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }
  
  void _showLogoutDialog(UserController userController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout(userController);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textWhite,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _logout(UserController userController) async {
    try {
      await userController.logout();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}