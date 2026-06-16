import 'package:expenso/models/friend.dart';
import 'package:expenso/repositories/friends_repository.dart';
import 'package:get/get.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Global, app-wide cache of the current user's friends.
///
/// Fetched once (lazily) and reused everywhere — screens call [ensureLoaded]
/// before reading [friends] instead of hitting Supabase on every screen.
/// Use [loadFriends] to force a refresh and [cacheFriend] to add a freshly
/// inserted friend without a round-trip.
/// ─────────────────────────────────────────────────────────────────────────────
class FriendsStore extends GetxController {
  static FriendsStore get instance => Get.find();

  final FriendsRepository _repo = Get.put(FriendsRepository());

  /// Single source of truth for the friends list across the whole app.
  final RxList<Friends> friends = <Friends>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoaded = false.obs;

  /// Fetch friends only if they haven't been loaded yet. Safe to call from
  /// every screen — it no-ops once the cache is populated.
  Future<void> ensureLoaded() async {
    if (isLoaded.value || isLoading.value) return;
    await loadFriends();
  }

  /// Force-refresh the friends list from Supabase.
  Future<void> loadFriends() async {
    isLoading.value = true;
    try {
      final result = await _repo.fetchFriends();
      friends.assignAll(result);
      isLoaded.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Insert a newly created friend into the cache without re-fetching.
  void cacheFriend(Friends friend) {
    final i = friends.indexWhere((f) => f.id == friend.id);
    if (i >= 0) {
      friends[i] = friend;
    } else {
      friends.insert(0, friend);
    }
  }

  Friends? byId(String? id) {
    if (id == null) return null;
    return friends.firstWhereOrNull((f) => f.id == id);
  }

  /// Clear the cache (e.g. on logout) so the next user fetches fresh.
  void clear() {
    friends.clear();
    isLoaded.value = false;
  }
}
