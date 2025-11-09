import 'package:project_management/features/card/domain/entities/card.dart';
import 'package:project_management/features/card/domain/repositories/card_repository.dart';

/// Create Card Use Case
///
/// Use case untuk membuat card baru
/// Use case mengandung business logic dan merupakan single responsibility
///
class CreateCardUseCase {
  final CardRepository repository;

  CreateCardUseCase({required this.repository});

  /// Execute use case untuk create card
  ///
  /// [cardData] adalah Map yang berisi data card baru
  /// Returns Future<Card> berisi card yang baru dibuat
  /// Throws Exception jika terjadi error
  ///
  Future<Card> call(Map<String, dynamic> cardData) async {
    try {
      // Call repository untuk create card
      final card = await repository.createCard(cardData);

      print('📦 Use case berhasil create card: ${card.cardTitle}');
      return card;
    } catch (e) {
      // Log error dan re-throw untuk dihandle di presentation layer
      print('❌ Error di CreateCardUseCase: $e');
      rethrow;
    }
  }
}
