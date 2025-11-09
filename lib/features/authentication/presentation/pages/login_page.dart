import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:project_management/core/layout/main_page.dart';
import 'package:project_management/features/authentication/domain/entities/authentication.dart';
import 'package:project_management/features/authentication/presentation/blocs/login_bloc.dart';
import 'package:project_management/features/authentication/presentation/pages/register_page.dart';
import 'package:project_management_widgets/project_management_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phoneController = PhoneController();

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFfeecc2), Color.fromARGB(255, 234, 186, 247)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: Scaffold(
            backgroundColor: const Color.fromARGB(0, 207, 202, 202),

            body: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 13),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: const Color.fromARGB(163, 239, 236, 236),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Silahkan isi data akun anda dibawah ini',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      SizedBox(height: 35),

                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is SuccessState && state.token != '') {
                            context.go('/main');
                          }

                          if (state is FailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },

                        builder: (context, state) {
                          if (state is LoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthTextfield(
                                  page: 'login',

                                  label: 'Masukkan email',
                                  controller: _email,
                                ),

                                SizedBox(height: 12),
                                AuthTextfield(
                                  page: 'login',
                                  label: 'Masukkan password',
                                  controller: _password,
                                  suffixIcon: Icon(Icons.visibility),
                                ),

                                SizedBox(height: 22),

                                AuthButton(
                                  page: 'login',
                                  text: 'Masuk',
                                  onPressed: () {
                                    // Validasi form dulu sebelum login
                                    // Ini kayak ngecek apakah semua kotak udah diisi dengan benar
                                    if (_formKey.currentState!.validate()) {
                                      // Kalau validasi berhasil, baru jalankan proses login
                                      // Kalau semua kotak udah diisi benar, baru kita coba masuk
                                      context.read<LoginBloc>().login(
                                        Authentication(
                                          email: _email.text.trim(),
                                          password: _password.text.trim(),
                                        ),
                                      );
                                    } else {
                                      // Kalau validasi gagal, kasih pesan error
                                      // Kalau ada kotak yang belum diisi atau salah, kasih tau user
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Mohon isi semua field dengan benar',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),

                                // SizedBox(
                                //   width: double.infinity,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       if (_formKey.currentState!.validate()) {
                                //         // Process data.
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       padding: EdgeInsets.symmetric(vertical: 15),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(12),
                                //       ),
                                //       backgroundColor: Colors.blue,
                                //     ),
                                //     child: Text('Masuk', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                //   ),
                                // ),
                                SizedBox(height: 35),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Belum punya akun?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black54,
                                      ),
                                    ),

                                    SizedBox(width: 4),

                                    TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                        ),
                                        foregroundColor: const Color.fromARGB(
                                          255,
                                          25,
                                          0,
                                          255,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.go(RegisterPage.routeName);
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            137,
                                            55,
                                            0,
                                            255,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
