import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/user_controller.dart';
import '../models/expense.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_app_bar.dart';

class AddExpenseScreen extends StatefulWidget {
  final String? groupId;
  
  const AddExpenseScreen({super.key, this.groupId});
  
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedGroupId;
  DateTime _selectedDate = DateTime.now();
  bool _isEqualSplit = true;
  List<String> _selectedParticipants = [];
  Map<String, double> _customSplits = {};
  
  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.groupId;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add Expense',
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer3<ExpenseController, GroupController, UserController>(
        builder: (context, expenseController, groupController, userController, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildGroupSelection(groupController),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildParticipantSelection(groupController, userController),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildSplitOptions(),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildNotesSection(),
                  const SizedBox(height: AppConstants.largePadding * 2),
                  _buildActionButtons(expenseController, userController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expense Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Title *',
            hintText: 'What did you spend on?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          validator: (value) => Validators.validateRequired(value, 'Title'),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount *',
                  hintText: '0.00',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                validator: Validators.validateAmount,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                items: AppConstants.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => Validators.validateRequired(value, 'Category'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.textMedium),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: AppColors.textMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildGroupSelection(GroupController groupController) {
    final groups = groupController.groups;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Group (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        DropdownButtonFormField<String>(
          value: _selectedGroupId,
          decoration: InputDecoration(
            labelText: 'Select Group',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('No Group (Personal Expense)'),
            ),
            ...groups.map((group) {
              return DropdownMenuItem(
                value: group.id,
                child: Text(group.name),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGroupId = value;
              _selectedParticipants.clear();
              _customSplits.clear();
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildParticipantSelection(GroupController groupController, UserController userController) {
    final selectedGroup = _selectedGroupId != null
        ? groupController.getGroupById(_selectedGroupId!)
        : null;
    final availableUsers = selectedGroup?.members ?? userController.users;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Participants',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        ...availableUsers.map((user) {
          final isSelected = _selectedParticipants.contains(user.id);
          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedParticipants.add(user.id);
                } else {
                  _selectedParticipants.remove(user.id);
                  _customSplits.remove(user.id);
                }
              });
            },
            title: Text(user.name),
            subtitle: Text(user.email),
            secondary: user.avatar != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar!),
                  )
                : CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
          );
        }),
      ],
    );
  }
  
  Widget _buildSplitOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Split Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                value: true,
                groupValue: _isEqualSplit,
                onChanged: (value) {
                  setState(() {
                    _isEqualSplit = value!;
                    _customSplits.clear();
                  });
                },
                title: const Text('Equal Split'),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                value: false,
                groupValue: _isEqualSplit,
                onChanged: (value) {
                  setState(() {
                    _isEqualSplit = value!;
                  });
                },
                title: const Text('Custom Split'),
              ),
            ),
          ],
        ),
        if (!_isEqualSplit) _buildCustomSplitInputs(),
      ],
    );
  }
  
  Widget _buildCustomSplitInputs() {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return Column(
          children: _selectedParticipants.map((userId) {
            final user = userController.getUserById(userId);
            if (user == null) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.only(top: AppConstants.smallPadding),
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '${user.name}\'s share',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  if (amount != null) {
                    _customSplits[userId] = amount;
                  } else {
                    _customSplits.remove(userId);
                  }
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
  
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add any additional details...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons(ExpenseController expenseController, UserController userController) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: ElevatedButton(
            onPressed: expenseController.isLoading
                ? null
                : () => _saveExpense(expenseController, userController),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
            ),
            child: expenseController.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                    ),
                  )
                : const Text('Save Expense'),
          ),
        ),
      ],
    );
  }
  
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }
  
  Future<void> _saveExpense(ExpenseController expenseController, UserController userController) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedParticipants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one participant'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    final currentUser = userController.currentUser;
    if (currentUser == null) {
      return;
    }
    
    final amount = double.parse(_amountController.text);
    final splits = _createSplits(amount, userController);
    
    if (!_isEqualSplit) {
      final totalSplit = splits.fold<double>(0, (sum, split) => sum + split.amount);
      if ((totalSplit - amount).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom split amounts must equal the total amount'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    
    try {
      await expenseController.addExpense(
        title: _titleController.text.trim(),
        amount: amount,
        category: _selectedCategory!,
        date: _selectedDate,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        paidBy: currentUser,
        splits: splits,
        groupId: _selectedGroupId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding expense: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  List<ExpenseSplit> _createSplits(double amount, UserController userController) {
    final splits = <ExpenseSplit>[];
    
    if (_isEqualSplit) {
      final splitAmount = amount / _selectedParticipants.length;
      for (final userId in _selectedParticipants) {
        final user = userController.getUserById(userId);
        if (user != null) {
          splits.add(ExpenseSplit(user: user, amount: splitAmount));
        }
      }
    } else {
      for (final userId in _selectedParticipants) {
        final user = userController.getUserById(userId);
        final customAmount = _customSplits[userId] ?? 0.0;
        if (user != null) {
          splits.add(ExpenseSplit(user: user, amount: customAmount));
        }
      }
    }
    
    return splits;
  }
}