import 'package:dio/dio.dart';
import 'package:project_management/features/card/data/data_sources/card_remote_data_source.dart';
import 'package:project_management/features/card/data/models/card_model.dart';

/// Card Remote Data Source Implementation
///
/// Implementasi konkret dari CardRemoteDataSource
/// Menggunakan Dio untuk melakukan HTTP request ke API
///
class CardRemoteDataSourceImpl implements CardRemoteDataSource {
  final Dio dio;

  CardRemoteDataSourceImpl(this.dio);

  /// Implementasi fetch semua cards dari API endpoint /v1/card
  ///
  /// Melakukan GET request ke http://127.0.0.1:8000/api/v1/card
  /// Returns Future<List<CardModel>> berisi list cards dari server
  /// Throws Exception jika terjadi error saat fetch data
  ///
  @override
  Future<List<CardModel>> getCards() async {
    try {
      // Melakukan GET request ke endpoint card
      // Token akan otomatis ditambahkan oleh AuthInterceptor
      final response = await dio.get('/v1/card');

      // Check apakah response sukses (status code 200)
      if (response.statusCode == 200) {
        // Parse response body
        final data = response.data;

        // Extract data array dari response
        // Response format: {"title": "My Cards", "data": [...]}
        final List<dynamic> cardsJson = data['data'] as List<dynamic>;

        // Convert setiap item JSON menjadi CardModel
        final cards = cardsJson
            .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
            .toList();

        print('✅ Berhasil fetch ${cards.length} cards dari API');
        return cards;
      } else {
        // Jika status code bukan 200, throw exception
        throw Exception('Failed to load cards: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('❌ DioException saat fetch cards: ${e.message}');

      if (e.response != null) {
        // Server responded dengan error
        throw Exception(
          'Failed to load cards: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        // Network error atau timeout
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle general errors
      print('❌ Error saat fetch cards: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Implementasi create card baru ke API endpoint /v1/card
  ///
  /// [cardData] adalah Map yang berisi data card baru
  /// Returns Future<CardModel> berisi card yang baru dibuat
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<CardModel> createCard(Map<String, dynamic> cardData) async {
    try {
      // Melakukan POST request ke endpoint card
      final response = await dio.post('/v1/card', data: cardData);

      // Check apakah response sukses (status code 200 atau 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response body
        final data = response.data;

        // Extract card data dari response
        // Response format bisa: {"data": {...}} atau langsung {...}
        final cardJson = data['data'] ?? data;

        // Convert JSON menjadi CardModel
        final card = CardModel.fromJson(cardJson as Map<String, dynamic>);

        print('✅ Berhasil create card: ${card.cardTitle}');
        return card;
      } else {
        // Jika status code bukan 200/201, throw exception
        throw Exception('Failed to create card: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('❌ DioException saat create card: ${e.message}');

      if (e.response != null) {
        // Server responded dengan error
        throw Exception(
          'Failed to create card: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        // Network error atau timeout
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle general errors
      print('❌ Error saat create card: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Implementasi update card ke API endpoint /v1/card/{id}
  ///
  /// [cardId] adalah ID card yang akan diupdate
  /// [cardData] adalah Map yang berisi data card yang diupdate
  /// Returns Future<CardModel> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<CardModel> updateCard(
    int cardId,
    Map<String, dynamic> cardData,
  ) async {
    try {
      // Melakukan PUT/PATCH request ke endpoint card dengan ID
      final response = await dio.put('/v1/card/$cardId', data: cardData);

      // Check apakah response sukses (status code 200)
      if (response.statusCode == 200) {
        // Parse response body
        final data = response.data;

        // Extract card data dari response
        final cardJson = data['data'] ?? data;

        // Convert JSON menjadi CardModel
        final card = CardModel.fromJson(cardJson as Map<String, dynamic>);

        print('✅ Berhasil update card ID $cardId: ${card.cardTitle}');
        return card;
      } else {
        // Jika status code bukan 200, throw exception
        throw Exception('Failed to update card: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('❌ DioException saat update card: ${e.message}');

      if (e.response != null) {
        // Server responded dengan error
        throw Exception(
          'Failed to update card: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        // Network error atau timeout
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle general errors
      print('❌ Error saat update card: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Implementasi delete card dari API endpoint /v1/card/{id}
  ///
  /// [cardId] adalah ID card yang akan didelete
  /// Returns Future<void>
  /// Throws Exception jika terjadi error
  ///
  @override
  Future<void> deleteCard(int cardId) async {
    try {
      // Melakukan DELETE request ke endpoint card dengan ID
      final response = await dio.delete('/v1/card/$cardId');

      // Check apakah response sukses (status code 200 atau 204)
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Berhasil delete card ID $cardId');
        return;
      } else {
        // Jika status code bukan 200/204, throw exception
        throw Exception('Failed to delete card: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('❌ DioException saat delete card: ${e.message}');

      if (e.response != null) {
        // Server responded dengan error
        throw Exception(
          'Failed to delete card: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        // Network error atau timeout
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle general errors
      print('❌ Error saat delete card: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Implementasi update card status via time-logs/card/status endpoint
  ///
  /// Endpoint: PATCH /v1/time-logs/card/status
  /// Request body: {"card_id": int, "status": string}
  ///
  /// [cardId] adalah ID card yang akan diupdate statusnya
  /// [status] adalah status baru ('in_review' untuk tandai selesai)
  /// Returns Future<CardModel> berisi card yang sudah diupdate
  /// Throws Exception jika terjadi error atau validasi gagal
  ///
  @override
  Future<CardModel> updateCardStatus(String cardId, String status) async {
    try {
      print('🔄 Updating card $cardId status to $status...');

      // Convert cardId dari String ke int untuk API
      final cardIdInt = int.parse(cardId);

      // Melakukan PATCH request ke endpoint time-logs/card/status
      final response = await dio.patch(
        '/v1/time-logs/card/status',
        data: {
          'card_id': cardIdInt, // Kirim sebagai int (sesuai PHP validation)
          'status': status, // Kirim sebagai string
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Check apakah response sukses (status code 200)
      if (response.statusCode == 200) {
        // STRATEGY: Status berhasil diupdate, tapi GET endpoint bermasalah
        // Throw exception khusus yang akan di-catch di cubit untuk trigger fetchCards()
        print('✅ Status berhasil diupdate ke $status, throwing RefreshNeeded');

        // Throw exception khusus untuk signal bahwa perlu refresh
        throw Exception('REFRESH_NEEDED');
      } else {
        // Jika status code bukan 200, throw exception
        throw Exception(
          'Failed to update card status: Status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      print('❌ DioException saat update card status: ${e.message}');
      print('❌ Response data: ${e.response?.data}');

      if (e.response != null) {
        // Server responded dengan error
        final errorData = e.response?.data;
        String errorMessage = 'Failed to update card status';

        if (errorData is Map && errorData['message'] != null) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        }

        throw Exception(errorMessage);
      } else {
        // Network error atau timeout
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle general errors
      print('❌ Error saat update card status: $e');
      print('❌ Error type: ${e.runtimeType}');
      throw Exception('Unexpected error: $e');
    }
  }
}
