import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/card/domain/use_cases/create_card_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/delete_card_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/get_cards_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/update_card_use_case.dart';
import 'package:project_management/features/card/presentation/cubits/card_state.dart';

/// Card Cubit
///
/// Cubit untuk state management Card feature
/// Mengelola state dan business logic untuk cards dengan operasi CRUD lengkap
///
class CardCubit extends Cubit<CardState> {
  final GetCardsUseCase getCardsUseCase;
  final CreateCardUseCase createCardUseCase;
  final UpdateCardUseCase updateCardUseCase;
  final DeleteCardUseCase deleteCardUseCase;

  CardCubit({
    required this.getCardsUseCase,
    required this.createCardUseCase,
    required this.updateCardUseCase,
    required this.deleteCardUseCase,
  }) : super(const CardInitial());

  /// Fetch semua cards dari API
  ///
  /// Method ini akan:
  /// 1. Emit CardLoading state untuk show loading indicator
  /// 2. Call use case untuk fetch data
  /// 3. Emit CardLoaded jika berhasil atau CardError jika gagal
  ///
  Future<void> fetchCards() async {
    try {
      // Emit loading state
      emit(const CardLoading());
      print('🔄 Memulai fetch cards...');

      // Call use case untuk get cards
      final cards = await getCardsUseCase();

      // Emit loaded state dengan data cards
      emit(CardLoaded(cards: cards));
      print('✅ Berhasil fetch ${cards.length} cards');
    } catch (e) {
      // Emit error state dengan error message
      final errorMessage = 'Gagal memuat cards: ${e.toString()}';
      emit(CardError(message: errorMessage));
      print('❌ Error saat fetch cards: $e');
    }
  }

  /// Refresh cards (fetch ulang dari API)
  ///
  /// Sama seperti fetchCards tapi digunakan untuk pull-to-refresh
  ///
  Future<void> refreshCards() async {
    await fetchCards();
  }

  /// Create card baru
  ///
  /// Method ini akan:
  /// 1. Call use case untuk create card
  /// 2. Emit CardLoading state saat proses
  /// 3. Refresh list cards jika berhasil atau emit CardError jika gagal
  ///
  /// [cardData] adalah Map yang berisi data card baru
  ///
  Future<void> createCard(Map<String, dynamic> cardData) async {
    try {
      // Emit loading state
      emit(const CardLoading());
      print('🔄 Memulai create card...');

      // Call use case untuk create card
      final newCard = await createCardUseCase(cardData);

      // Setelah berhasil create, refresh list cards
      await fetchCards();

      print('✅ Berhasil create card: ${newCard.cardTitle}');
    } catch (e) {
      // Emit error state dengan error message
      final errorMessage = 'Gagal membuat card: ${e.toString()}';
      emit(CardError(message: errorMessage));
      print('❌ Error saat create card: $e');
    }
  }

  /// Update card yang sudah ada
  ///
  /// Method ini akan:
  /// 1. Call use case untuk update card
  /// 2. Emit CardLoading state saat proses
  /// 3. Refresh list cards jika berhasil atau emit CardError jika gagal
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  ///
  Future<void> updateCard(int cardId, Map<String, dynamic> cardData) async {
    try {
      // Emit loading state
      emit(const CardLoading());
      print('🔄 Memulai update card ID $cardId...');

      // Call use case untuk update card
      final updatedCard = await updateCardUseCase(cardId, cardData);

      // Setelah berhasil update, refresh list cards
      await fetchCards();

      print('✅ Berhasil update card: ${updatedCard.cardTitle}');
    } catch (e) {
      // Emit error state dengan error message
      final errorMessage = 'Gagal update card: ${e.toString()}';
      emit(CardError(message: errorMessage));
      print('❌ Error saat update card: $e');
    }
  }

  /// Delete card
  ///
  /// Method ini akan:
  /// 1. Call use case untuk delete card
  /// 2. Emit CardLoading state saat proses
  /// 3. Refresh list cards jika berhasil atau emit CardError jika gagal
  ///
  /// [cardId] adalah ID card yang akan didelete
  ///
  Future<void> deleteCard(int cardId) async {
    try {
      // Emit loading state
      emit(const CardLoading());
      print('🔄 Memulai delete card ID $cardId...');

      // Call use case untuk delete card
      await deleteCardUseCase(cardId);

      // Setelah berhasil delete, refresh list cards
      await fetchCards();

      print('✅ Berhasil delete card ID $cardId');
    } catch (e) {
      // Emit error state dengan error message
      final errorMessage = 'Gagal delete card: ${e.toString()}';
      emit(CardError(message: errorMessage));
      print('❌ Error saat delete card: $e');
    }
  }

  /// Update status card (Tandai Selesai)
  ///
  /// PENTING: Status value adalah 'review' (bukan 'in_review')
  /// sesuai dengan API Laravel di TimeLogController.php
  ///
  /// Method ini akan:
  /// 1. Update status card ke 'review' via API
  /// 2. Refresh list cards untuk mendapatkan data terbaru
  /// 3. Emit CardError jika terjadi error (validasi gagal, dll)
  ///
  /// [cardId] adalah ID card yang akan diupdate statusnya (String, sesuai API layer)
  ///
  Future<void> markCardAsCompleted(String cardId) async {
    try {
      print('🔄 Memulai update status card $cardId ke review...');

      // Call repository untuk update status ke 'review' (sesuai API Laravel)
      // Method ini akan throw REFRESH_NEEDED jika berhasil
      try {
        await updateCardUseCase.repository.updateCardStatus(cardId, 'review');
      } catch (e) {
        // Jika REFRESH_NEEDED, berarti update berhasil, lanjut fetch
        if (e.toString().contains('REFRESH_NEEDED')) {
          print('✅ Update status berhasil, refreshing cards...');
        } else {
          // Error lain, rethrow
          rethrow;
        }
      }

      // Setelah berhasil update, refresh list cards
      await fetchCards();

      print('✅ Berhasil update status card $cardId ke review');
    } catch (e) {
      // Emit error state dengan error message
      final errorMessage = 'Gagal menandai selesai: ${e.toString()}';
      emit(CardError(message: errorMessage));
      print('❌ Error saat update status card: $e');
    }
  }
}
