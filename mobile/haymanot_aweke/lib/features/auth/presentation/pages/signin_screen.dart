import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/socket/socket_service.dart';
import '../../data/datasource/user_local_datasource.dart';
import '../../data/datasource/user_remote_datasource.dart';
import '../../data/repository/siginin_repository.dart';
import '../../domain/usecases/login.dart';
import '../bloc/signin_bloc/signin_bloc.dart';
import '../bloc/signin_bloc/signin_event.dart';
import '../bloc/signin_bloc/signin_state.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.connect();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SigninBloc>(
      future: _createSigninBloc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocProvider<SigninBloc>(
          create: (context) => snapshot.data!,
          child: _buildSigninUI(),
        );
      },
    );
  }

  Future<SigninBloc> _createSigninBloc() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final internetConnectionChecker = InternetConnectionChecker.instance;
      final httpClient = http.Client();
      final networkInfo = NetworkInfoImpl(
        connectionChecker: internetConnectionChecker,
      );
      final userLocalDatasource = UserLocalDatasourceImpl(
        sharedPreferences: sharedPreferences,
        client: httpClient,
      );
      final userRemoteDatasource = UserRemoteDatasourceImpl(client: httpClient);
      final signinRepository = SigninRepositoryImpl(
        userLocalDatasource: userLocalDatasource,
        userRemoteDatasource: userRemoteDatasource,
        networkInfo: networkInfo,
      );

      final signinUsecase = SigninUsecase(signinRepository: signinRepository);

      return SigninBloc(signinUsecase: signinUsecase);
    } catch (e) {
      throw Exception('Failed to initialize signin functionality: $e');
    }
  }

  Widget _buildSigninUI() {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.pushReplacementNamed(context, '/retrieve');
        }

        if (state is SigninFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<SigninBloc, SigninState>(
        builder: (context, state) {
          bool isPasswordVisible = false;
          bool isLoading = state is SigninLoading;

          if (state is SigninPasswordVisibilityToggled) {
            isPasswordVisible = state.isPasswordVisible;
          }

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "ECOM",
                            style: TextStyle(
                              color: Color.fromARGB(255, 15, 83, 201),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      "Sign into Your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Section
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              enabled: !isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "ex: haymi@gmail.com",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Password Section
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !isLoading,
                              obscureText: !isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(),
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
                                  onPressed:
                                      !isLoading
                                          ? () {
                                            context.read<SigninBloc>().add(
                                              TogglePasswordVisibility(),
                                            );
                                          }
                                          : null,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    !isLoading
                                        ? () => _handleSignIn(context)
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
                                          strokeWidth: 2,
                                        )
                                        : const Text(
                                          "SIGN IN",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),

                            const SizedBox(height: 30),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        !isLoading
                                            ? () {
                                              Navigator.pushNamed(
                                                context,
                                                '/signup',
                                              );
                                            }
                                            : null,
                                    child: const Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
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
            ),
          );
        },
      ),
    );
  }

  void _handleSignIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SigninBloc>().add(
        SigninSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}
