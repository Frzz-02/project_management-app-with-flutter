import 'package:project_management/features/card/domain/entities/card.dart';
import 'package:project_management/features/card/domain/repositories/card_repository.dart';

/// Update Card Use Case
///
/// Use case untuk mengupdate card yang sudah ada
/// Use case mengandung business logic dan merupakan single responsibility
///
class UpdateCardUseCase {
  final CardRepository repository;

  UpdateCardUseCase({required this.repository});

  /// Execute use case untuk update card
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  /// Returns Future<Card> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error
  ///
  Future<Card> call(int cardId, Map<String, dynamic> cardData) async {
    try {
      // Call repository untuk update card
      final card = await repository.updateCard(cardId, cardData);

      print('📦 Use case berhasil update card ID $cardId: ${card.cardTitle}');
      return card;
    } catch (e) {
      // Log error dan re-throw untuk dihandle di presentation layer
      print('❌ Error di UpdateCardUseCase: $e');
      rethrow;
    }
  }
}
