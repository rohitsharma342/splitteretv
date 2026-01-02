import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group.dart';
import '../screens/group_detail_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  
  const GroupCard({
    super.key,
    required this.group,
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupDetailScreen(group: group),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (group.coverImage != null)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.borderRadius),
                    topRight: Radius.circular(AppConstants.borderRadius),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(group.coverImage!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.borderRadius),
                      topRight: Radius.circular(AppConstants.borderRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${group.members.length} members',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (group.description != null && group.description!.isNotEmpty) ..[
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      group.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      _buildMemberAvatars(),
                      const Spacer(),
                      Text(
                        'Created ${DateFormat('MMM yyyy').format(group.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMemberAvatars() {
    const int maxVisible = 4;
    final visibleMembers = group.members.take(maxVisible).toList();
    final remainingCount = group.members.length - maxVisible;
    
    return Row(
      children: [
        ...visibleMembers.asMap().entries.map((entry) {
          final index = entry.key;
          final member = entry.value;
          
          return Container(
            margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
            child: member.avatar != null
                ? CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(member.avatar!),
                    backgroundColor: AppColors.surface,
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          );
        }),
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface,
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}