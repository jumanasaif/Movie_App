import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/data/models/user_model.dart';
import 'package:movie_app/providers/user_provider.dart';
import 'package:movie_app/providers/bottom_nav_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentRouteProvider.notifier).state = '/profile';
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white60),
          onPressed: () {
            ref.read(currentRouteProvider.notifier).state = '/';
            context.go('/');
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 28,
            fontFamily: 'Bilbo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.white, height: 2),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: userAsync.when(
              data: (user) {
                if (user == null) {
                  return const Center(
                    child: Text(
                      'No user logged in',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),

                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.amber.shade200,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _editableField(
                        context: context,
                        user: user,
                        ref: ref,
                        title: "Name",
                        value: user.name,
                        icon: Icons.person,
                        iconColor: Colors.amber,
                        onSave: (newValue) {
                          user.name = newValue;
                        },
                      ),

                      const SizedBox(height: 10),

                      _editableField(
                        context: context,
                        user: user,
                        ref: ref,
                        title: "Email",
                        value: user.email,
                        icon: Icons.email,
                        iconColor: Colors.blue,
                        onSave: (newValue) {
                          user.email = newValue;
                        },
                      ),

                      const SizedBox(height: 25),

                      _editableField(
                        context: context,
                        user: user,
                        ref: ref,
                        title: "Country",
                        value: user.country,
                        icon: Icons.flag,
                        iconColor: Colors.redAccent,
                        onSave: (newValue) {
                          user.country = newValue;
                        },
                      ),

                      _editableField(
                        context: context,
                        user: user,
                        ref: ref,
                        title: "Age",
                        value: user.age.toString(),
                        icon: Icons.cake,
                        iconColor: Colors.purpleAccent,
                        keyboardType: TextInputType.number,
                        onSave: (newValue) {
                          user.age = int.tryParse(newValue) ?? user.age;
                        },
                      ),

                      _profileCard(
                        icon: Icons.favorite,
                        title: "Favorites Count",
                        value: user.favorites.length.toString(),
                        iconColor: Colors.green,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(smartBottomNavProvider);

              return BottomNavigationBar(
                currentIndex: index,
                onTap: (value) {
                  ref.read(bottomNavIndexProvider.notifier).state = value;
                  ref.read(currentRouteProvider.notifier).state = value == 0
                      ? '/'
                      : '/profile';

                  if (value == 0) {
                    context.go('/');
                  } else if (value == 1) {
                    context.go('/profile');
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                selectedItemColor: Colors.amber,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.black,
                elevation: 20,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editableField({
    required BuildContext context,
    required UserModel user,
    required WidgetRef ref,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onSave,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {
              final controller = TextEditingController(text: value);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Edit $title'),
                  content: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(hintText: 'Enter new $title'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onSave(controller.text);
                        ref.read(userProvider.notifier).updateUser(user);

                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
