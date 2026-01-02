import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class BalanceSummary extends StatelessWidget {
  final double totalOwed;
  final double totalOwedTo;
  
  const BalanceSummary({
    super.key,
    required this.totalOwed,
    required this.totalOwedTo,
  });
  
  @override
  Widget build(BuildContext context) {
    final netBalance = totalOwedTo - totalOwed;
    
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.textWhite,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  const Text(
                    'Balance Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      netBalance >= 0 ? 'Net Positive' : 'Net Negative',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.largePadding),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceItem(
                      title: 'You Owe',
                      amount: totalOwed,
                      isNegative: true,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.textWhite.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                  ),
                  Expanded(
                    child: _buildBalanceItem(
                      title: 'Owed to You',
                      amount: totalOwedTo,
                      isNegative: false,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.largePadding),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: AppColors.textWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Net Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      netBalance >= 0
                          ? '+\$${netBalance.toStringAsFixed(2)}'
                          : '-\$${(-netBalance).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBalanceItem({
    required String title,
    required double amount,
    required bool isNegative,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.textWhite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.textWhite,
            size: 20,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textWhite.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}