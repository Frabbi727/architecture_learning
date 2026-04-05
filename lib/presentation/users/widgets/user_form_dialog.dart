import 'package:architecture_learning/core/validation/input_validators.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:flutter/material.dart';

class UserFormResult {
  const UserFormResult({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;
}

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({
    this.user,
    super.key,
  });

  final User? user;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _roleController = TextEditingController(text: widget.user?.role ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit User' : 'Create User'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                validator: InputValidators.validateName,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                validator: InputValidators.validateEmail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roleController,
                validator: InputValidators.validateRole,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) {
              return;
            }

            Navigator.of(context).pop(
              UserFormResult(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                role: _roleController.text.trim(),
              ),
            );
          },
          child: Text(isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
