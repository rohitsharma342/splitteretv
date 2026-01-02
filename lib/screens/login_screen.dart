import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Login',
        showBackButton: false,
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.largePadding * 2),
                  _buildHeader(),
                  const SizedBox(height: AppConstants.largePadding * 2),
                  _buildLoginForm(authController),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildLoginButton(authController),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildSignUpLink(),
                  if (authController.error.isNotEmpty) ... [
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildErrorMessage(authController.error),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          'Sign in to continue managing your expenses',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoginForm(AuthController authController) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildLoginButton(AuthController authController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: authController.isLoading
            ? null
            : () => _handleLogin(authController),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: authController.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
  
  Widget _buildSignUpLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: AppColors.textMedium,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleLogin(AuthController authController) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    authController.clearError();
    
    final success = await authController.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }
}