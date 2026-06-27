import 'package:expenso/controllers/navigation_controller.dart';
import 'package:expenso/models/user.dart';
import 'package:expenso/repositories/auth_repository.dart';
import 'package:expenso/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  // ── Observables ─────────────────────────────────────────────────────────────
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  final pushNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  // ── Data ─────────────────────────────────────────────────────────────────────
  /// Fetches the live profile row from Supabase. Falls back to the cached
  /// `AuthRepository` user (set during login/register) if the network call
  /// fails or there is no authenticated session.
  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      if (currentAuthUser != null) {
        final response = await Supabase.instance.client
            .from('user_profile')
            .select()
            .eq('id', currentAuthUser.id)
            .single();
        final fetched = UserModel.fromJson(response);
        user.value = fetched;
        // keep the shared repository in sync for the rest of the app
        AuthRepository.instance.user = fetched;
      } else {
        user.value = AuthRepository.instance.user;
      }
    } catch (e) {
      debugPrint('ProfileController.loadUser error: $e');
      user.value = AuthRepository.instance.user;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() => loadUser();

  // ── Derived Display Values ───────────────────────────────────────────────────
  String get displayName {
    final name = user.value?.name.trim();
    return (name == null || name.isEmpty) ? 'Expenso User' : name;
  }

  String get initials {
    final parts = displayName.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final n = displayName;
    return n.isNotEmpty ? n[0].toUpperCase() : '?';
  }

  String get memberSince {
    final created = Supabase.instance.client.auth.currentUser?.createdAt;
    if (created == null || created.isEmpty) return '';
    try {
      return 'Member Since ${DateTime.parse(created).year}';
    } catch (_) {
      return '';
    }
  }

  String get email => user.value?.email.trim() ?? '—';
  String get phone {
    final n = user.value?.number.trim();
    return (n == null || n.isEmpty) ? '—' : n;
  }

  // ── Actions ──────────────────────────────────────────────────────────────────
  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void onEditAvatar() {
    // TODO: implement avatar editing
  }

  void onLanguageTap() {
    // TODO: implement language selection
  }

  void onCurrencyTap() {
    // TODO: implement currency selection
  }

  Future<void> onLogout() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAll(() => const AuthScreen());
    NavigationController.instance.selectedIndex.value = 0;
  }
}
