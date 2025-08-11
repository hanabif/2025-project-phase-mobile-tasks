// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/network/network_info.dart';
import '../../data/datasource/user_local_datasource.dart';
import '../../data/datasource/user_remote_datasource.dart';
import '../../data/repository/signup_repository_impl.dart';
import '../../domain/usecases/signup.dart';
import '../bloc/signup_bloc/signup_bloc.dart';
import '../bloc/signup_bloc/signup_event.dart';
import '../bloc/signup_bloc/signup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SignupBloc>(
      future: _createSignupBloc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        return BlocProvider<SignupBloc>(
          create: (context) => snapshot.data!,
          child: _buildUI(),
        );
      },
    );
  }

  Future<SignupBloc> _createSignupBloc() async {
    try {
      final connectivity = InternetConnectionChecker.instance;
      final httpClient = http.Client();

      final networkInfo = NetworkInfoImpl(connectionChecker: connectivity);

      final sharedPreferences = await SharedPreferences.getInstance();
      final userLocalDatasource = UserLocalDatasourceImpl(
        sharedPreferences: sharedPreferences, client: httpClient,
       
      );
      final userRemoteDatasource = UserRemoteDatasourceImpl(client: httpClient);

      final signupRepository = SignupRepositoryImpl(
        userRemoteDatasource: userRemoteDatasource,
        networkInfo: networkInfo,
      );

      final signupUsecase = SignupUsecase(signupRepository);

      return SignupBloc(signupUsecase: signupUsecase);
    } catch (e) {
      throw Exception('Failed to initialize SignupBloc: $e');
    }
  }

  Widget _buildUI() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
        ),
        actions: [
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  'ECOM',
                  style: TextStyle(
                    fontFamily: 'CaveatBrush',
                    color: Color.fromARGB(255, 15, 83, 201),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.greenAccent,
              ),
            );
            Navigator.pushReplacementNamed(context, '/sign-in');
          }
          if (state is SignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            bool isPasswordVisible = false;
            bool isConfirmPasswordVisible = false;
            bool isTermsAccepted = false;
            bool isLoading = state is SignupLoading;

            if (state is SignupFormState) {
              isPasswordVisible = state.isPasswordVisible;
              isConfirmPasswordVisible = state.isConfirmPasswordVisible;
              isTermsAccepted = state.isTermsAccepted;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Create Your account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.length <= 5) {
                                  return 'Name must have atleast have 5 charachters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'ex: John Doe',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email adress.';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: ' ex: jon.smith@email.com',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password.';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long.';
                                }
                                if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
                                ).hasMatch(value)) {
                                  return 'Password must contain uppercase, lowercase, number and special character.';
                                }
                                return null;
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<SignupBloc>().add(
                                      TogglePasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: !isConfirmPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return "Password don't match";
                                }
                                return null;
                              },
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<SignupBloc>().add(
                                      ToggleConfirmPasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  side: const BorderSide(
                                    width: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  value: isTermsAccepted,
                                  onChanged: (bool? value) {
                                    context.read<SignupBloc>().add(
                                      ToggleTermsAcceptance(),
                                    );
                                  },
                                  activeColor: Colors.blueAccent,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<SignupBloc>().add(
                                        ToggleTermsAcceptance(),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 1.0),
                                      child: Text(
                                        'I understood the terms and policy',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    isTermsAccepted && !isLoading
                                        ? () => _handleSignUp(context)
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),

                            const SizedBox(height: 100),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/sign-in');
                                    },
                                    child: const Text(
                                      'SIGN IN',
                                      style: TextStyle(
                                        color: Color(0xFF3F51F3),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(
        SignupSubmitted(
          name: _nameController.text,
          confirmPassword: _confirmPasswordController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
