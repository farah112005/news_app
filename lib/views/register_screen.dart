import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../utils/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final Map<String, dynamic> _formData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
    'phoneNumber': '',
    'dateOfBirth': null,
  };

  bool _termsAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;
    _formKey.currentState!.save();

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms & conditions')),
      );
      return;
    }

    context.read<AuthCubit>().register(_formData);
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _formData['dateOfBirth'] = picked;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Create Account")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Sign Up", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: _buildInputDecoration(
                          "First Name",
                          Icons.person,
                        ),
                        validator: ValidationUtils.validateName,
                        onSaved: (val) => _formData['firstName'] = val,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: _buildInputDecoration(
                          "Last Name",
                          Icons.person_2,
                        ),
                        validator: ValidationUtils.validateName,
                        onSaved: (val) => _formData['lastName'] = val,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: _buildInputDecoration("Email", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: ValidationUtils.validateEmail,
                        onSaved: (val) => _formData['email'] = val,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: _buildInputDecoration(
                          "Phone Number",
                          Icons.phone,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: ValidationUtils.validatePhone,
                        onSaved: (val) => _formData['phoneNumber'] = val,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration:
                            _buildInputDecoration(
                              "Password",
                              Icons.lock,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                        validator: ValidationUtils.validatePassword,
                        onSaved: (val) => _formData['password'] = val,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _obscureConfirmPassword,
                        decoration:
                            _buildInputDecoration(
                              "Confirm Password",
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                              ),
                            ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Confirm your password";
                          }
                          if (val.trim() != _passwordController.text.trim()) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        onSaved: (val) => _formData['confirmPassword'] = val,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _formData['dateOfBirth'] != null
                                ? _formData['dateOfBirth']
                                      .toString()
                                      .split(" ")
                                      .first
                                : "Select Date of Birth",
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _pickDate,
                            child: const Text("Pick Date"),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        value: _termsAccepted,
                        onChanged: (val) =>
                            setState(() => _termsAccepted = val ?? false),
                        title: const Text("I agree to the Terms & Conditions"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: state is AuthLoading ? null : _submit,
                        icon: const Icon(Icons.app_registration),
                        label: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Register"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
