import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:live_vitalist/app/routing/app_routes.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';

abstract final class SuperSearchNavigation {
  static Future<void> open(
    BuildContext context,
    WidgetRef ref, {
    DateTime? date,
    String? mealName,
  }) async {
    final notifier = ref.read(superSearchProvider.notifier);
    notifier.enter(date: date, mealName: mealName);
    await context.push<void>(AppRoutes.search);
    notifier.exit();
  }

  static void close(BuildContext context) {
    if (context.canPop()) context.pop();
  }
}
