// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/local_auth_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final LocalAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user.firstName} ${user.lastName}'),
                Text('Email: ${user.email}'),
                if (user.phoneNumber != null)
                  Text('Phone: ${user.phoneNumber}'),
                if (user.dateOfBirth != null)
                  Text('DOB: ${user.dateOfBirth!.toLocal()}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
