import 'package:project_management/features/card/domain/entities/card.dart';
import 'package:project_management/features/card/domain/repositories/card_repository.dart';

/// Get Cards Use Case
///
/// Use case untuk mengambil semua cards dari repository
/// Use case mengandung business logic dan merupakan single responsibility
///
class GetCardsUseCase {
  final CardRepository repository;

  GetCardsUseCase({required this.repository});

  /// Execute use case untuk get cards
  ///
  /// Memanggil repository untuk fetch cards dari data source
  /// Returns Future<List<Card>> berisi list cards
  /// Throws Exception jika terjadi error
  ///
  Future<List<Card>> call() async {
    try {
      // Call repository untuk get cards
      final cards = await repository.getCards();

      print('📦 Use case berhasil get ${cards.length} cards');
      return cards;
    } catch (e) {
      // Log error dan re-throw untuk dihandle di presentation layer
      print('❌ Error di GetCardsUseCase: $e');
      rethrow;
    }
  }
}
