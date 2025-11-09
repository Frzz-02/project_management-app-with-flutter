import 'package:project_management/features/card/domain/entities/card.dart';

/// Card State
///
/// Base state untuk Card feature
/// Sealed class untuk type-safe pattern matching
///
sealed class CardState {
  const CardState();
}

/// Card Initial State
///
/// State awal sebelum ada aksi apapun
///
class CardInitial extends CardState {
  const CardInitial();
}

/// Card Loading State
///
/// State ketika sedang fetch data dari API
/// Digunakan untuk menampilkan loading indicator
///
class CardLoading extends CardState {
  const CardLoading();
}

/// Card Loaded State
///
/// State ketika data berhasil di-fetch dari API
/// Berisi list cards yang akan ditampilkan
///
class CardLoaded extends CardState {
  final List<Card> cards;

  const CardLoaded({required this.cards});
}

/// Card Error State
///
/// State ketika terjadi error saat fetch data
/// Berisi error message untuk ditampilkan ke user
///
class CardError extends CardState {
  final String message;

  const CardError({required this.message});
}
