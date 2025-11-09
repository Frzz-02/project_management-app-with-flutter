import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_management/features/authentication/presentation/pages/login_page.dart';
import 'package:quickalert/quickalert.dart';

void alertSuccessWidget(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: 'Berhasil',
    text: 'Akun anda berhasil dibuat, silahkan masuk untuk melanjutkan.',
    confirmBtnText: 'Masuk',
    onConfirmBtnTap: () => context.go(LoginPage.routeName),
  );
}
