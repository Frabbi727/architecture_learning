import 'package:architecture_learning/features/users/controllers/users_controller.dart';
import 'package:architecture_learning/features/users/models/user_model.dart';
import 'package:architecture_learning/features/users/widgets/user_form_dialog.dart';
import 'package:architecture_learning/features/users/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add User'),
      ),
      body: Obx(() {
        final message = controller.errorMessage.value;
        if (message.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final snackBar = SnackBar(content: Text(message));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            controller.clearMessage();
          });
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: controller.hasUsers
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SummaryBanner(totalUsers: controller.users.length),
                    const SizedBox(height: 16),
                    ...controller.users.map(
                      (user) => UserTile(
                        user: user,
                        onEdit: () => _openEditDialog(context, user),
                        onDelete: () => _confirmDelete(context, user),
                      ),
                    ),
                  ],
                )
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: const [
                    SizedBox(height: 80),
                    _EmptyState(),
                  ],
                ),
        );
      }),
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final result = await showDialog<UserFormResult>(
      context: context,
      builder: (_) => const UserFormDialog(),
    );

    if (result == null) {
      return;
    }

    await controller.createUser(
      firstName: result.firstName,
      lastName: result.lastName,
      email: result.email,
    );
  }

  Future<void> _openEditDialog(BuildContext context, UserModel user) async {
    final result = await showDialog<UserFormResult>(
      context: context,
      builder: (_) => UserFormDialog(user: user),
    );

    if (result == null) {
      return;
    }

    await controller.updateUser(
      id: user.id,
      firstName: result.firstName,
      lastName: result.lastName,
      email: result.email,
    );
  }

  Future<void> _confirmDelete(BuildContext context, UserModel user) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete user'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.deleteUser(user.id);
    }
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.totalUsers});

  final int totalUsers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4D3E), Color(0xFF2D6A4F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team snapshot',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalUsers users loaded through the shared API client.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.people_outline, size: 72),
        const SizedBox(height: 16),
        Text(
          'No users yet',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Use the Add User button to create your first record.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
