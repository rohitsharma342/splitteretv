import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/expense_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/user_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/expense_card.dart';
import '../widgets/group_card.dart';
import '../widgets/balance_summary.dart';
import '../widgets/custom_app_bar.dart';
import 'add_expense_screen.dart';
import 'profile_settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppConstants.appName,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalTab(),
                _buildGroupsTab(),
                _buildNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search groups, friends, or expenses...',
          prefixIcon: Icon(Icons.search, color: AppColors.textLight),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          context.read<GroupController>().setSearchQuery(value);
        },
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
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
          Tab(text: 'Personal'),
          Tab(text: 'Groups'),
          Tab(text: 'Notifications'),
        ],
      ),
    );
  }
  
  Widget _buildPersonalTab() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        return Consumer<UserController>(
          builder: (context, userController, child) {
            final currentUser = userController.currentUser;
            if (currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BalanceSummary(
                    totalOwed: expenseController.getTotalOwed(currentUser.id),
                    totalOwedTo: expenseController.getTotalOwedTo(currentUser.id),
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ...expenseController.getRecentExpenses().map(
                    (expense) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                      child: ExpenseCard(expense: expense),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildGroupsTab() {
    return Consumer<GroupController>(
      builder: (context, groupController, child) {
        final groups = groupController.groups;
        
        if (groups.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_add,
                  size: 64,
                  color: AppColors.textLight,
                ),
                SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'No groups yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: AppConstants.smallPadding),
                Text(
                  'Create a group to start splitting expenses',
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
              child: GroupCard(group: group),
            );
          },
        );
      },
    );
  }
  
  Widget _buildNotificationsTab() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final notifications = expenseController.notifications;
        
        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: AppColors.textLight,
                ),
                SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'No notifications',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: AppConstants.smallPadding),
                Text(
                  'You\'re all caught up!',
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
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.isRead
                      ? AppColors.surface
                      : AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: notification.isRead
                        ? AppColors.textLight
                        : AppColors.primary,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                subtitle: Text(notification.message),
                trailing: Text(
                  _formatNotificationTime(notification.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                onTap: () {
                  if (!notification.isRead) {
                    expenseController.markNotificationAsRead(notification.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
  
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'expense':
        return Icons.receipt;
      case 'reminder':
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }
  
  String _formatNotificationTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}