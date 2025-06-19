import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/core/utils/reg_ex.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_in/sign_in_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_in/sign_in_state.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/home_screen.dart';
import 'package:insta_x_bloc/features/user/presentation/widgets/my_formfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  IconData _passwordIcon = CupertinoIcons.eye_fill;
  bool signInReqired = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.isLoading) {
          signInReqired = true;
        }
      },
      child: Form(
        key: _formKey,
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyFormField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIconData: CupertinoIcons.mail_solid,
                    errorMessage: _errorMessage,
                    focusNode: _emailFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please fill in this field";
                      } else if (!emailRegExp.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyFormField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: !_isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIconData: CupertinoIcons.lock_circle,
                    errorMessage: _errorMessage,
                    focusNode: _passwordFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please fill in this field";
                      } else if (!passwordRexExp.hasMatch(value)) {
                        return "Password must be at least 8 characters long";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      color: _passwordFocusNode.hasFocus
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      icon: Icon(_passwordIcon),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                          _passwordIcon = _isPasswordVisible
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                !state.isLoading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInBloc>().add(
                                    SignInWithEmailAndPasswordEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
