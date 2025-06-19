import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_x_bloc/core/utils/reg_ex.dart';
import 'package:insta_x_bloc/features/user/domain/entities/user.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_up/sign_up_event.dart';
import 'package:insta_x_bloc/features/user/presentation/bloc/sign_up/sign_up_state.dart';
import 'package:insta_x_bloc/features/user/presentation/screens/home_screen.dart';
import 'package:insta_x_bloc/features/user/presentation/widgets/my_formfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  final nameController = TextEditingController();
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
        if (state.status == SignUpStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyFormField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(CupertinoIcons.mail_solid),
                        errorMessage:
                            !state.isEmailValid ? 'Неверный email' : null,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!emailRegExp.hasMatch(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        errorMessage:
                            !state.isPasswordValid ? 'Неверный пароль' : null,
                        onChanged: (val) {
                          if (val!.contains(RegExp(r'[A-Z]'))) {
                            setState(() {
                              containsUpperCase = true;
                            });
                          } else {
                            setState(() {
                              containsUpperCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[a-z]'))) {
                            setState(() {
                              containsLowerCase = true;
                            });
                          } else {
                            setState(() {
                              containsLowerCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[0-9]'))) {
                            setState(() {
                              containsNumber = true;
                            });
                          } else {
                            setState(() {
                              containsNumber = false;
                            });
                          }
                          if (val.contains(specialCharRexExp)) {
                            setState(() {
                              containsSpecialChar = true;
                            });
                          } else {
                            setState(() {
                              containsSpecialChar = false;
                            });
                          }
                          if (val.length >= 8) {
                            setState(() {
                              contains8Length = true;
                            });
                          } else {
                            setState(() {
                              contains8Length = false;
                            });
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                              if (obscurePassword) {
                                iconPassword = CupertinoIcons.eye_fill;
                              } else {
                                iconPassword = CupertinoIcons.eye_slash_fill;
                              }
                            });
                          },
                          icon: Icon(iconPassword),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!passwordRexExp.hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 uppercase",
                            style: TextStyle(
                                color: containsUpperCase
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                                color: containsLowerCase
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                                color: containsNumber
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 special character",
                            style: TextStyle(
                                color: containsSpecialChar
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  8 minimum character",
                            style: TextStyle(
                                color: contains8Length
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyFormField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(CupertinoIcons.person_fill),
                        errorMessage:
                            !state.isNameValid ? 'Неверное имя' : null,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (val.length > 30) {
                            return 'Name too long';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  !signUpRequired
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  UserEntity myUser = UserEntity.empty;
                                  myUser = myUser.copyWith(
                                    email: emailController.text,
                                    name: nameController.text,
                                  );

                                  setState(() {
                                    context.read<SignUpBloc>().add(
                                          SignUpWithEmailAndPasswordEvent(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            name: nameController.text,
                                          ),
                                        );
                                  });
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
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        )
                      : const CircularProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
