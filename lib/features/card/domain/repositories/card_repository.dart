import 'package:project_management/features/card/domain/entities/card.dart';

/// Card Repository
///
/// Interface repository untuk operasi data card
/// Repository bertanggung jawab untuk mengelola data dari berbagai sumber
///
abstract class CardRepository {
  /// Get semua cards dari data source
  ///
  /// Returns Future<List<Card>> berisi list cards
  /// Throws Exception jika terjadi error
  ///
  Future<List<Card>> getCards();

  /// Create card baru
  ///
  /// [cardData] adalah Map yang berisi data card baru
  /// Returns Future<Card> berisi card yang baru dibuat
  /// Throws Exception jika terjadi error
  ///
  Future<Card> createCard(Map<String, dynamic> cardData);

  /// Update card yang sudah ada
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  /// Returns Future<Card> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error
  ///
  Future<Card> updateCard(int cardId, Map<String, dynamic> cardData);

  /// Delete card
  ///
  /// [cardId] adalah ID card yang akan didelete
  /// Returns Future<void>
  /// Throws Exception jika terjadi error
  ///
  Future<void> deleteCard(int cardId);

  /// Update status card (tandai selesai/review)
  ///
  /// [cardId] adalah ID card yang akan diupdate statusnya
  /// [status] adalah status baru ('in_review' untuk tandai selesai)
  /// Returns Future<Card> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error atau validasi gagal
  ///
  Future<Card> updateCardStatus(String cardId, String status);
}
