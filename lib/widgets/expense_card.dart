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
      margin: EdgeInsets.zero,
      elevation: AppConstants.cardElevation,
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
              Row(
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
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expense.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd').format(expense.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                children: [
                  expense.paidBy.avatar != null
                      ? CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(expense.paidBy.avatar!),
                        )
                      : CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            expense.paidBy.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      'Paid by ${expense.paidBy.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${expense.splits.length} people',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (expense.notes != null && expense.notes!.isNotEmpty) ..[
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  expense.notes!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getCategoryColor() {
    switch (expense.category.toLowerCase()) {
      case 'food & dining':
        return const Color(0xFFFF6B6B);
      case 'transportation':
        return const Color(0xFF4ECDC4);
      case 'entertainment':
        return const Color(0xFFFFE66D);
      case 'shopping':
        return const Color(0xFFFF8B94);
      case 'bills & utilities':
        return const Color(0xFF95E1D3);
      case 'travel':
        return const Color(0xFF87CEEB);
      case 'health & medical':
        return const Color(0xFFDDA0DD);
      default:
        return AppColors.primary;
    }
  }
  
  IconData _getCategoryIcon() {
    switch (expense.category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_bag;
      case 'bills & utilities':
        return Icons.receipt;
      case 'travel':
        return Icons.flight;
      case 'health & medical':
        return Icons.medical_services;
      default:
        return Icons.attach_money;
    }
  }
}