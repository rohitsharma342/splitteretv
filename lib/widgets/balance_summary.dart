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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppConstants.largePadding),
            _buildBalanceDetails(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildNetBalance(netBalance),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.textWhite.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: AppColors.textWhite,
            size: 24,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        const Expanded(
          child: Text(
            'Balance Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBalanceDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceItem(
            title: 'You Owe',
            amount: totalOwed,
            icon: Icons.arrow_upward,
            isNegative: true,
          ),
        ),
        Container(
          width: 1,
          height: 60,
          color: AppColors.textWhite.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        ),
        Expanded(
          child: _buildBalanceItem(
            title: 'Owed to You',
            amount: totalOwedTo,
            icon: Icons.arrow_downward,
            isNegative: false,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBalanceItem({
    required String title,
    required double amount,
    required IconData icon,
    required bool isNegative,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textWhite.withOpacity(0.8),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textWhite.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
      ],
    );
  }
  
  Widget _buildNetBalance(double netBalance) {
    final isPositive = netBalance >= 0;
    final balanceText = isPositive
        ? 'You are owed \$${netBalance.toStringAsFixed(2)}'
        : 'You owe \$${(-netBalance).toStringAsFixed(2)}';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        border: Border.all(
          color: AppColors.textWhite.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: AppColors.textWhite,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Balance',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textWhite.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  balanceText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}