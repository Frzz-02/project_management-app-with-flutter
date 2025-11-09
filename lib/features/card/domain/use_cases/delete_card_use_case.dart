import 'package:project_management/features/card/domain/repositories/card_repository.dart';

/// Delete Card Use Case
///
/// Use case untuk menghapus card
/// Use case mengandung business logic dan merupakan single responsibility
///
class DeleteCardUseCase {
  final CardRepository repository;

  DeleteCardUseCase({required this.repository});

  /// Execute use case untuk delete card
  ///
  /// [cardId] adalah ID card yang akan didelete
  /// Returns Future<void>
  /// Throws Exception jika terjadi error
  ///
  Future<void> call(int cardId) async {
    try {
      // Call repository untuk delete card
      await repository.deleteCard(cardId);

      print('📦 Use case berhasil delete card ID $cardId');
    } catch (e) {
      // Log error dan re-throw untuk dihandle di presentation layer
      print('❌ Error di DeleteCardUseCase: $e');
      rethrow;
    }
  }
}
