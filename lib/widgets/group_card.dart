import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/group.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../screens/group_detail_screen.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  
  const GroupCard({
    super.key,
    required this.group,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
            _buildCoverImage(),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  if (group.description != null) ..[
                    const SizedBox(height: AppConstants.smallPadding),
                    _buildDescription(),
                  ],
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildMembersInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCoverImage() {
    if (group.coverImage != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
        child: CachedNetworkImage(
          imageUrl: group.coverImage!,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 120,
            color: AppColors.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 120,
            color: AppColors.surfaceVariant,
            child: const Icon(
              Icons.image_not_supported,
              color: AppColors.textLight,
              size: 40,
            ),
          ),
        ),
      );
    }
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primaryDark,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.group,
          size: 48,
          color: AppColors.textWhite.withOpacity(0.8),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            group.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textLight,
        ),
      ],
    );
  }
  
  Widget _buildDescription() {
    return Text(
      group.description!,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textMedium,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildMembersInfo() {
    return Row(
      children: [
        _buildMemberAvatars(),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: Text(
            '${group.members.length} member${group.members.length != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Active',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMemberAvatars() {
    const maxVisible = 3;
    final visibleMembers = group.members.take(maxVisible).toList();
    final remainingCount = group.members.length - maxVisible;
    
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          ...visibleMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            
            return Positioned(
              left: index * 20.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
                child: member.avatar != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: member.avatar!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(
                              Icons.person,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              member.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          member.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            );
          }),
          if (remainingCount > 0)
            Positioned(
              left: maxVisible * 20.0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textLight,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}