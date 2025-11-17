import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recepies/models/user.dart';
import 'package:recepies/services/auth_service.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService().getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? _buildNoUserUI()
              : _buildSettingsUI(),
    );
  }

  Widget _buildNoUserUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No User Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please login to view settings'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          _buildProfileSection(),
          const SizedBox(height: 30),
          
          // App Information Section
          _buildAppInfoSection(),
          const SizedBox(height: 30),
          
          // Support Section
          _buildSupportSection(),
          const SizedBox(height: 30),
          
          // Logout Button
          _buildLogoutButton(),
          const SizedBox(height: 20),
          
          // Version Info
          _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _currentUser!.image.isNotEmpty
                      ? NetworkImage(_currentUser!.image)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  backgroundColor: Colors.grey[300],
                  child: _currentUser!.image.isEmpty
                      ? const Icon(Icons.person, size: 25, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_currentUser!.firstName} ${_currentUser!.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8F4C39),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${_currentUser!.username}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser!.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showEditProfileDialog();
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF8F4C39)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'App Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8F4C39),
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Learn more about Recipe App',
                onTap: () => _showAboutAppDialog(),
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'About Developer',
                subtitle: 'Meet the creator',
                onTap: () => _showDeveloperInfo(),
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () => _showPrivacyPolicy(),
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'App usage terms',
                onTap: () => _showTermsOfService(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8F4C39),
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help using the app',
                onTap: () => _showHelpSupport(),
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.bug_report_outlined,
                title: 'Report a Bug',
                subtitle: 'Found an issue? Let us know',
                onTap: () => _reportBug(),
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.star_outline,
                title: 'Rate the App',
                subtitle: 'Share your experience',
                onTap: () => _rateApp(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8F4C39)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Recipe App',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8F4C39),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Version 2.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '© 2024 Recipe App. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing functionality will be implemented in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Recipe App'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recipe App v2.0',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your ultimate cooking companion! Discover thousands of delicious recipes from around the world.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('🍳 Browse recipes by category'),
              _buildFeatureItem('⭐ Save your favorite recipes'),
              _buildFeatureItem('⏱️ Filter by preparation time'),
              _buildFeatureItem('👨‍🍳 Detailed cooking instructions'),
              _buildFeatureItem('🛒 Smart ingredient lists'),
              const SizedBox(height: 16),
              const Text(
                'Built with Flutter and love for cooking!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showDeveloperInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Developer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF8F4C39),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ian Brian Otieno',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Flutter Developer & UI/UX Enthusiast',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Passionate about creating beautiful and functional mobile applications. Specializing in Flutter development with a focus on user experience.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _launchURL('https://ianbrianotieno.netlify.app/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F4C39),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Visit Portfolio'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy for Recipe App\n\n'
            'We value your privacy and are committed to protecting your personal information. '
            'This app collects minimal data required for functionality:\n\n'
            '• User account information for personalized experience\n'
            '• Favorite recipes (stored locally on your device)\n'
            '• App usage analytics for improvement\n\n'
            'We do not share your personal data with third parties without your consent. '
            'All data is encrypted and stored securely.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service for Recipe App\n\n'
            'By using this app, you agree to:\n\n'
            '• Use the app for personal, non-commercial purposes\n'
            '• Not attempt to reverse engineer the application\n'
            '• Respect copyright and intellectual property rights\n'
            '• Use the app in compliance with applicable laws\n\n'
            'We reserve the right to update these terms at any time. '
            'Continued use of the app constitutes acceptance of updated terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Text(
            'Need help with Recipe App?\n\n'
            'Common Issues:\n'
            '• Can\'t login: Check your username and password\n'
            '• Recipes not loading: Check your internet connection\n'
            '• App crashes: Try restarting the app\n\n'
            'For additional support, contact us at:\n'
            'support@recipeapp.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const Text(
          'Found a bug? We appreciate your feedback!\n\n'
          'Please describe the issue you encountered and the steps to reproduce it. '
          'This helps us fix it quickly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('mailto:ianotieno23@gmail.com?subject=Bug Report - Recipe App');
            },
            child: const Text('Report Bug'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate the App'),
        content: const Text(
          'Enjoying Recipe App?\n\n'
          'Your rating helps us improve and reach more cooking enthusiasts. '
          'Thank you for your support!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // You can add your app store link here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to app store...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}