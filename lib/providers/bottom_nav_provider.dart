import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final currentRouteProvider = StateProvider<String>((ref) => '/');

final smartBottomNavProvider = Provider<int>((ref) {
  final currentRoute = ref.watch(currentRouteProvider);
  final manualIndex = ref.watch(bottomNavIndexProvider);

  if (currentRoute == '/profile') {
    return 1;
  } else if (currentRoute == '/') {
    return 0;
  } else {
    return manualIndex;
  }
});
