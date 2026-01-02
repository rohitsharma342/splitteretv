import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/expense_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/user_controller.dart';
import '../models/group.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/expense_card.dart';
import '../widgets/custom_app_bar.dart';
import 'add_expense_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;
  
  const GroupDetailScreen({super.key, required this.group});
  
  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inviteController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _inviteController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.group.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showInviteDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGroupHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExpensesTab(),
                _buildBalancesTab(),
                _buildMembersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(groupId: widget.group.id),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }
  
  Widget _buildGroupHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          if (widget.group.coverImage != null)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.group.coverImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                Text(
                  widget.group.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.group.description != null) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    widget.group.description!,
                    style: const TextStyle(
                      color: AppColors.textMedium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppConstants.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 16,
                      color: AppColors.textMedium,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      '${widget.group.members.length} members',
                      style: const TextStyle(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius - 2),
        ),
        labelColor: AppColors.textWhite,
        unselectedLabelColor: AppColors.textMedium,
        tabs: const [
          Tab(text: 'Expenses'),
          Tab(text: 'Balances'),
          Tab(text: 'Members'),
        ],
      ),
    );
  }
  
  Widget _buildExpensesTab() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final groupExpenses = expenseController.getExpensesByGroup(widget.group.id);
        
        if (groupExpenses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: AppColors.textLight,
                ),
                SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'No expenses yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: AppConstants.smallPadding),
                Text(
                  'Add an expense to get started',
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: groupExpenses.length,
          itemBuilder: (context, index) {
            final expense = groupExpenses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              child: ExpenseCard(expense: expense),
            );
          },
        );
      },
    );
  }
  
  Widget _buildBalancesTab() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final balances = expenseController.getGroupBalances(widget.group.id);
        
        if (balances.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.balance,
                  size: 64,
                  color: AppColors.textLight,
                ),
                SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'No balances to show',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          );
        }
        
        final sortedBalances = balances.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: sortedBalances.length,
          itemBuilder: (context, index) {
            final entry = sortedBalances[index];
            final userId = entry.key;
            final balance = entry.value;
            final user = widget.group.members.firstWhere(
              (member) => member.id == userId,
              orElse: () => widget.group.members.first,
            );
            
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              child: ListTile(
                leading: user.avatar != null
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
                title: Text(user.name),
                trailing: Text(
                  balance >= 0
                      ? '+\$${balance.toStringAsFixed(2)}'
                      : '-\$${(-balance).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: balance >= 0 ? AppColors.incomeGreen : AppColors.expenseRed,
                  ),
                ),
                subtitle: Text(
                  balance >= 0
                      ? 'Gets back'
                      : 'Owes',
                  style: TextStyle(
                    color: balance >= 0 ? AppColors.incomeGreen : AppColors.expenseRed,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: widget.group.members.length,
      itemBuilder: (context, index) {
        final member = widget.group.members[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
          child: ListTile(
            leading: member.avatar != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(member.avatar!),
                  )
                : CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
            title: Text(member.name),
            subtitle: Text(member.email),
            trailing: const Icon(
              Icons.more_vert,
              color: AppColors.textLight,
            ),
          ),
        );
      },
    );
  }
  
  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<GroupController>(
          builder: (context, groupController, child) {
            return AlertDialog(
              title: const Text('Invite Member'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter the email address of the person you want to invite to this group.',
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextField(
                    controller: _inviteController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _inviteController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: groupController.isLoading
                      ? null
                      : () => _sendInvite(groupController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                  ),
                  child: groupController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                          ),
                        )
                      : const Text('Send Invite'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Future<void> _sendInvite(GroupController groupController) async {
    final email = _inviteController.text.trim();
    
    if (email.isEmpty) {
      return;
    }
    
    try {
      await groupController.inviteMember(widget.group.id, email);
      
      if (mounted) {
        _inviteController.clear();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation sent to $email'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending invitation: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}