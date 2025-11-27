import 'package:flutter/material.dart';

class FilterDrawer extends StatelessWidget {
  final VoidCallback? onApply;
  const FilterDrawer({super.key, this.onApply});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(title: Text('Filters')),
            const Spacer(),
            ElevatedButton(onPressed: onApply, child: const Text('Apply')),
          ],
        ),
      ),
    );
  }
}
