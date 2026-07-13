import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/entry_detail_screen.dart';
import '../screens/entries_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/stats_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/entries',
      builder: (BuildContext context, GoRouterState state) {
        return const EntriesScreen();
      },
    ),
    GoRoute(
      path: '/entries/new',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage<void>(
          child: EntryFormScreen(),
        );
      },
    ),
    GoRoute(
      path: '/stats',
      builder: (BuildContext context, GoRouterState state) {
        return const StatsScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/entry/:id',
      builder: (BuildContext context, GoRouterState state) {
        return EntryDetailScreen(entryId: state.pathParameters['id'] ?? '');
      },
    ),
  ],
);