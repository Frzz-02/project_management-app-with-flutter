import 'package:project_management/features/card/data/models/card_model.dart';

/// Card Remote Data Source
///
/// Interface untuk operasi data card dari remote API
/// Interface ini mendefinisikan contract untuk implementasi konkret
///
abstract class CardRemoteDataSource {
  /// Fetch semua cards dari API
  ///
  /// Returns Future<List<CardModel>> berisi list cards dari server
  /// Throws Exception jika terjadi error saat fetch data
  ///
  Future<List<CardModel>> getCards();

  /// Create card baru ke API
  ///
  /// [cardData] adalah Map yang berisi data card baru
  /// Returns Future<CardModel> berisi card yang baru dibuat
  /// Throws Exception jika terjadi error saat create
  ///
  Future<CardModel> createCard(Map<String, dynamic> cardData);

  /// Update card yang sudah ada di API
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  /// Returns Future<CardModel> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error saat update
  ///
  Future<CardModel> updateCard(int cardId, Map<String, dynamic> cardData);

  /// Delete card dari API
  ///
  /// [cardId] adalah ID card yang akan didelete
  /// Returns Future<void>
  /// Throws Exception jika terjadi error saat delete
  ///
  Future<void> deleteCard(int cardId);

  /// Update status card via time-logs/card/status endpoint
  ///
  /// [cardId] adalah ID card yang akan diupdate statusnya
  /// [status] adalah status baru ('in_review', 'done', etc)
  /// Returns Future<CardModel> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error atau validasi gagal
  ///
  Future<CardModel> updateCardStatus(String cardId, String status);
}
