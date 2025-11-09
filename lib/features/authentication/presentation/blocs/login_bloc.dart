import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:project_management/features/authentication/domain/entities/authentication.dart';
import 'package:project_management/features/authentication/domain/use_cases/get_login_token_use_case.dart';
import 'package:project_management/features/authentication/domain/use_cases/login_use_case.dart';
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final AuthenticationRepositoryImpl repository;
  LoginBloc({required this.repository}) : super(InitialState());

  void login(Authentication credential) async {
    emit(LoadingState());

    try {
      // Kode asli dengan error handling yang lebih baik
      // Penjelasan bayi: Sekarang kita coba login beneran ke server dengan perlindungan error

      final login = LoginUseCase(repository: repository);
      await login(credential).timeout(
        const Duration(seconds: 10), // Timeout 10 detik
        onTimeout: () {
          throw Exception('Login timeout - server terlalu lambat merespon');
        },
      );

      final token = GetLoginTokenUseCase(repository: repository);
      final result = await token().timeout(
        const Duration(seconds: 5), // Timeout 5 detik untuk get token
        onTimeout: () {
          throw Exception('Get token timeout');
        },
      );

      if (result != null && result.isNotEmpty) {
        emit(SuccessState(token: result));
      } else {
        emit(FailureState('Token kosong atau tidak valid'));
      }
    } on Exception catch (e) {
      // Handle exception yang kita throw sendiri
      // Penjelasan bayi: Kalau ada error yang kita tau (timeout, dll), kasih pesan yang jelas
      emit(
        FailureState(
          'Login gagal: ${e.toString().replaceAll('Exception: ', '')}',
        ),
      );
    } catch (e) {
      // Handle error lainnya (DioException, dll)
      // Penjelasan bayi: Kalau ada error lain, kita coba kasih pesan yang lebih mudah dimengerti
      String errorMessage = 'Login gagal';

      if (e.toString().contains('connection')) {
        errorMessage =
            'Tidak bisa terhubung ke server. Pastikan koneksi internet stabil.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Email atau password salah';
      } else if (e.toString().contains('422')) {
        errorMessage = 'Data yang dimasukkan tidak valid';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server sedang bermasalah. Coba lagi nanti.';
      } else {
        errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      }

      emit(FailureState(errorMessage));
    }
  }
}
