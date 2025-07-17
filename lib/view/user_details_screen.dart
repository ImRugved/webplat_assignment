import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../global/colors.dart';
import '../global/text_styles.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
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
            _buildPersonalInfo(context),
            _buildContactInfo(context),
            _buildAddressInfo(context),
            _buildCompanyInfo(context),
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
                user.name[0].toUpperCase(),
                style: AppTextStyles.heading1.copyWith(
                  fontSize: isTablet ? 36 : 30,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: AppTextStyles.heading1.copyWith(
                fontSize: isTablet ? 28 : 24,
                color: AppColors.splashText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${user.username}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: isTablet ? 18 : 16,
                color: AppColors.splashText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: ${user.id}',
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

  Widget _buildPersonalInfo(BuildContext context) {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person,
      context: context,
      children: [
        _buildInfoTile('Full Name', user.name, Icons.person_outline, context),
        _buildInfoTile(
          'Username',
          '@${user.username}',
          Icons.alternate_email,
          context,
        ),
        _buildInfoTile('Email', user.email, Icons.email, context),
        _buildInfoTile('Phone', user.phone, Icons.phone, context),
        _buildInfoTile('Website', user.website, Icons.language, context),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return _buildSection(
      title: 'Contact Information',
      icon: Icons.contact_mail,
      context: context,
      children: [
        _buildInfoTile('Email', user.email, Icons.email_outlined, context),
        _buildInfoTile('Phone', user.phone, Icons.phone_outlined, context),
        _buildInfoTile(
          'Website',
          user.website,
          Icons.language_outlined,
          context,
        ),
      ],
    );
  }

  Widget _buildAddressInfo(BuildContext context) {
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on,
      context: context,
      children: [
        _buildInfoTile(
          'Street',
          user.address.street,
          Icons.streetview,
          context,
        ),
        _buildInfoTile('Suite', user.address.suite, Icons.home, context),
        _buildInfoTile('City', user.address.city, Icons.location_city, context),
        _buildInfoTile(
          'Zip Code',
          user.address.zipcode,
          Icons.pin_drop,
          context,
        ),
        _buildInfoTile(
          'Coordinates',
          '${user.address.geo.lat}, ${user.address.geo.lng}',
          Icons.map,
          context,
        ),
      ],
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return _buildSection(
      title: 'Company Information',
      icon: Icons.business,
      context: context,
      children: [
        _buildInfoTile(
          'Company Name',
          user.company.name,
          Icons.business_outlined,
          context,
        ),
        _buildInfoTile(
          'Catch Phrase',
          user.company.catchPhrase,
          Icons.format_quote,
          context,
        ),
        _buildInfoTile(
          'Business',
          user.company.bs,
          Icons.work_outline,
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
