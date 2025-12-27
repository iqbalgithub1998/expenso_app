import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/core/constants/colors.dart';
import 'package:expenso/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.defaultPadding,
          vertical: 30,
        ),
        child: Column(
          children: [
            // Avatar + Name
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.primary, width: 2),
                    color: TColors.primary,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AuthController.instance.authUser?.name[0].toUpperCase() ??
                        "",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  AuthController.instance.authUser?.name ?? "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  AuthController.instance.authUser?.email ?? "",
                  style: TextStyle(color: AppColors.textLight),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Info Cards
            _profileTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {},
            ),
            _profileTile(
              icon: Icons.notifications_none,
              title: "Notifications",
              onTap: () {},
            ),
            _profileTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {},
            ),
            _profileTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {},
            ),

            const Spacer(),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  AuthController.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.04)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
