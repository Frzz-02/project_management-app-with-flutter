import 'package:project_management/features/card/data/data_sources/card_remote_data_source.dart';
import 'package:project_management/features/card/domain/entities/card.dart';
import 'package:project_management/features/card/domain/repositories/card_repository.dart';

/// Card Repository Implementation
///
/// Implementasi konkret dari CardRepository
/// Menghubungkan domain layer dengan data layer
///
class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource remoteDataSource;

  CardRepositoryImpl({required this.remoteDataSource});

  /// Implementasi get cards dari remote data source
  ///
  /// Mengambil data dari API melalui remote data source
  /// Returns Future<List<Card>> berisi list cards
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<List<Card>> getCards() async {
    try {
      // Fetch cards dari remote data source
      final cardModels = await remoteDataSource.getCards();

      // CardModel sudah extends Card entity, jadi bisa langsung return
      // Tapi untuk lebih explicit, kita cast ke List<Card>
      return cardModels;
    } catch (e) {
      // Re-throw exception untuk dihandle di layer atas (use case/cubit)
      print('❌ Error di CardRepository: $e');
      rethrow;
    }
  }

  /// Implementasi create card
  ///
  /// [cardData] adalah Map yang berisi data card baru
  /// Returns Future<Card> berisi card yang baru dibuat
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<Card> createCard(Map<String, dynamic> cardData) async {
    try {
      // Create card melalui remote data source
      final cardModel = await remoteDataSource.createCard(cardData);

      // CardModel sudah extends Card entity
      return cardModel;
    } catch (e) {
      // Re-throw exception untuk dihandle di layer atas
      print('❌ Error di CardRepository createCard: $e');
      rethrow;
    }
  }

  /// Implementasi update card
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  /// Returns Future<Card> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<Card> updateCard(int cardId, Map<String, dynamic> cardData) async {
    try {
      // Update card melalui remote data source
      final cardModel = await remoteDataSource.updateCard(cardId, cardData);

      // CardModel sudah extends Card entity
      return cardModel;
    } catch (e) {
      // Re-throw exception untuk dihandle di layer atas
      print('❌ Error di CardRepository updateCard: $e');
      rethrow;
    }
  }

  /// Implementasi delete card
  ///
  /// [cardId] adalah ID card yang akan didelete
  /// Returns Future<void>
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<void> deleteCard(int cardId) async {
    try {
      // Delete card melalui remote data source
      await remoteDataSource.deleteCard(cardId);
    } catch (e) {
      // Re-throw exception untuk dihandle di layer atas
      print('❌ Error di CardRepository deleteCard: $e');
      rethrow;
    }
  }

  /// Implementasi update card status
  ///
  /// [cardId] adalah ID card yang akan diupdate statusnya
  /// [status] adalah status baru ('in_review' untuk tandai selesai)
  /// Returns Future<Card> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error atau validasi gagal
  ///
  @override
  Future<Card> updateCardStatus(String cardId, String status) async {
    try {
      // Update status melalui remote data source
      final cardModel = await remoteDataSource.updateCardStatus(cardId, status);

      // CardModel sudah extends Card entity
      return cardModel;
    } catch (e) {
      // Re-throw exception untuk dihandle di layer atas
      print('❌ Error di CardRepository updateCardStatus: $e');
      rethrow;
    }
  }
}
