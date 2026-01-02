import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  
  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppConstants.smallPadding),
              _buildDetails(),
              const SizedBox(height: AppConstants.smallPadding),
              _buildSplitInfo(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(),
            color: _getCategoryColor(),
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                expense.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetails() {
    return Row(
      children: [
        Icon(
          Icons.person,
          size: 14,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 4),
        Text(
          'Paid by ${expense.paidBy.name}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.calendar_today,
          size: 14,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM dd').format(expense.date),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSplitInfo() {
    final splitCount = expense.splits.length;
    final paidSplits = expense.splits.where((split) => split.isPaid).length;
    
    return Row(
      children: [
        Icon(
          Icons.group,
          size: 14,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 4),
        Text(
          'Split $splitCount ways',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
        const Spacer(),
        if (paidSplits < splitCount) ... [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${splitCount - paidSplits} pending',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ] else ... [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Settled',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  Color _getCategoryColor() {
    final categoryIndex = AppConstants.categories.indexOf(expense.category);
    if (categoryIndex != -1) {
      return AppColors.getCategoryColor(categoryIndex);
    }
    return AppColors.primary;
  }
  
  IconData _getCategoryIcon() {
    switch (expense.category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills & utilities':
        return Icons.receipt_long;
      case 'healthcare':
        return Icons.local_hospital;
      case 'travel':
        return Icons.flight;
      case 'education':
        return Icons.school;
      case 'personal care':
        return Icons.spa;
      case 'gifts & donations':
        return Icons.card_giftcard;
      case 'business':
        return Icons.business;
      default:
        return Icons.category;
    }
  }
}