import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_management/core/widgets/alert_success_widget.dart';
import 'package:project_management/features/authentication/presentation/pages/login_page.dart';
import 'package:project_management_widgets/project_management_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController telepon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    username.dispose();
    telepon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.54, 0.78],
          colors: [
            const Color.fromARGB(255, 255, 241, 236),
            const Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),

          body: Stack(
            children: [
              Positioned(
                bottom: 260,
                left: -57,
                child: Transform.rotate(
                  angle: -0.7,
                  child: Blob.fromID(
                    id: ["15-4-12"],
                    size: 590,
                    styles: BlobStyles(
                      // color: const Color.fromARGB(255, 255, 68, 0),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(100, 255, 95, 108),
                          const Color.fromARGB(100, 255, 196, 113),
                        ],
                      ).createShader(Rect.fromLTWH(-30, 0, 420, 420)),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 255, 255, 255),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                  vertical: 40,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Daftar Akun Baru',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Cukup satu akun untuk menjangkau berbagai layanan terbaik bagi hewan kesayangan Anda.',
                          style: TextStyle(
                            color: const Color.fromARGB(117, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 25,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(193, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(236, 0, 0, 0),
                              width: 0.1,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                'Registrasi Akun',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 30),

                              // input Email
                              AuthTextfield(
                                page: 'register',
                                label: 'Masukkan email',
                                controller: email,
                              ),

                              const SizedBox(height: 18),

                              // input Username
                              AuthTextfield(
                                page: 'register',
                                label: 'Masukkan username',
                                controller: username,
                              ),

                              const SizedBox(height: 18),

                              // input Nomor Telepon
                              Container(
                                padding: EdgeInsets.only(right: 40),
                                child: AuthTextfield(
                                  page: 'register',
                                  suffixIcon: Icon(Icons.visibility_off),
                                  label: 'Masukkan nomor telepon',
                                  controller: telepon,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // input Password
                              AuthTextfield(
                                page: 'register',
                                suffixIcon: Icon(Icons.visibility_off),
                                label: 'Masukkan password',
                                controller: passwordConfirm,
                              ),

                              const SizedBox(height: 15),

                              AuthTextfield(
                                page: 'register',
                                suffixIcon: Icon(Icons.visibility_off),
                                label: 'Konfirmasi password',
                                controller: password,
                              ),

                              const SizedBox(height: 13),

                              AuthButton(
                                text: 'Daftar',
                                page: 'register',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    alertSuccessWidget(context);
                                  } else {
                                    return;
                                  }
                                },
                              ),

                              const SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Sudah mempunyai akun ?  ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(117, 0, 0, 0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),

                                  // text button daftar
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.only(right: 5),
                                      foregroundColor: const Color.fromARGB(
                                        255,
                                        25,
                                        0,
                                        255,
                                      ),
                                      textStyle: const TextStyle(fontSize: 13),
                                    ),
                                    onPressed: () {
                                      context.go(LoginPage.routeName);
                                    },
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
