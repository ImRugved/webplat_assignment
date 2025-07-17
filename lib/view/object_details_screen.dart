import 'package:flutter/material.dart';
import '../model/object_model.dart';
import '../global/colors.dart';
import '../global/text_styles.dart';

class ObjectDetailsScreen extends StatelessWidget {
  final ObjectItem object;

  const ObjectDetailsScreen({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Object Details',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.splashText,
            fontSize: isTablet ? 22 : 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.splashText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildBasicInfo(context),
            if (object.data != null) _buildDetailedInfo(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 15),
        child: Column(
          children: [
            CircleAvatar(
              radius: isTablet ? 50 : 40,
              backgroundColor: AppColors.surface,
              child: Text(
                object.name[0].toUpperCase(),
                style: AppTextStyles.heading1.copyWith(
                  fontSize: isTablet ? 36 : 30,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              object.name,
              style: AppTextStyles.heading1.copyWith(
                fontSize: isTablet ? 28 : 24,
                color: AppColors.splashText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: ${object.id}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.splashText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return _buildSection(
      title: 'Basic Information',
      icon: Icons.info,
      context: context,
      children: [
        _buildInfoTile('Object Name', object.name, Icons.label, context),
        _buildInfoTile('Object ID', object.id, Icons.fingerprint, context),
        _buildInfoTile(
          'Data Available',
          object.data != null ? 'Yes' : 'No',
          Icons.data_usage,
          context,
        ),
      ],
    );
  }

  Widget _buildDetailedInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return _buildSection(
      title: 'Detailed Information',
      icon: Icons.details,
      context: context,
      children: [
        if (object.color != null)
          _buildInfoTile('Color', object.color!, Icons.palette, context),
        if (object.capacity != null)
          _buildInfoTile('Capacity', object.capacity!, Icons.storage, context),
        if (object.price != null)
          _buildInfoTile(
            'Price',
            '\$${object.price}',
            Icons.attach_money,
            context,
          ),
        if (object.generation != null)
          _buildInfoTile(
            'Generation',
            object.generation!,
            Icons.update,
            context,
          ),
        if (object.year != null)
          _buildInfoTile('Year', object.year!, Icons.calendar_today, context),
        if (object.cpuModel != null)
          _buildInfoTile('CPU Model', object.cpuModel!, Icons.memory, context),
        if (object.hardDiskSize != null)
          _buildInfoTile(
            'Storage',
            object.hardDiskSize!,
            Icons.storage,
            context,
          ),
        if (object.caseSize != null)
          _buildInfoTile(
            'Case Size',
            object.caseSize!,
            Icons.straighten,
            context,
          ),
        if (object.description != null)
          _buildInfoTile(
            'Description',
            object.description!,
            Icons.description,
            context,
          ),
        if (object.screenSize != null)
          _buildInfoTile(
            'Screen Size',
            '${object.screenSize}"',
            Icons.screen_rotation,
            context,
          ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryDark,
                  size: isTablet ? 28 : 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: isTablet ? 20 : 18,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isTablet ? 20 : 18,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.detailLabel.copyWith(
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.detailValue.copyWith(
                    fontSize: isTablet ? 16 : 14,
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
