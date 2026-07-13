import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinanceFlowScaffold extends StatelessWidget {
  const FinanceFlowScaffold({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.child,
    this.maxContentWidth = 1120,
  });

  final String title;
  final int selectedIndex;
  final Widget child;
  final double maxContentWidth;

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/entries');
        break;
      case 2:
        context.go('/stats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  Widget _buildNavigation(BuildContext context, bool useRail) {
    final List<NavigationDestination> destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      const NavigationDestination(
        icon: Icon(Icons.list_alt_outlined),
        label: 'Entries',
      ),
      const NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        label: 'Stats',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        label: 'Settings',
      ),
    ];

    if (useRail) {
      return NavigationRail(
        selectedIndex: selectedIndex,
        extended: false,
        onDestinationSelected: (int index) => _navigate(context, index),
        labelType: NavigationRailLabelType.all,
        destinations: destinations
            .map(
              (NavigationDestination destination) => NavigationRailDestination(
                icon: destination.icon,
                selectedIcon: destination.icon,
                label: Text(destination.label),
              ),
            )
            .toList(growable: false),
      );
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) => _navigate(context, index),
      destinations: destinations,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useRail = constraints.maxWidth >= 768;

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: useRail ? 16 : 0,
                  ),
                  child: useRail
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                child: _buildNavigation(context, true),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: child,
                                ),
                              ),
                            ),
                          ],
                        )
                      : child,
                ),
              ),
            ),
          ),
          bottomNavigationBar: useRail ? null : _buildNavigation(context, false),
        );
      },
    );
  }
}