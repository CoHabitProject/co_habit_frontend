import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final Color avatarColor;

  const CustomAppBar({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.avatarColor,
  });

  String _getInitials(String first, String last) {
    return '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}';
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.push('/profil'),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                child: Text(
                  _getInitials(firstName, lastName).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => context.push('/profil', extra: {
                'firstName': firstName,
                'lastName': lastName,
                'avatarColor': avatarColor,
              }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenu',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {}, // Action paramétrable
              icon: const Icon(Icons.settings),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
