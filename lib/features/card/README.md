# Card Feature - Clean Architecture Flutter

Feature untuk menampilkan dan mengelola cards dari API dengan clean architecture.


## 📁 Struktur Folder

```
lib/features/card/
├── data/
│   ├── data_sources/
│   │   ├── card_remote_data_source.dart           # Interface untuk remote data source
│   │   └── card_remote_data_source_impl.dart      # Implementasi fetch cards dari API
│   ├── models/
│   │   ├── card_model.dart                        # Model utama card dengan parsing JSON
│   │   ├── user_model.dart                        # Model user
│   │   ├── board_model.dart                       # Model board
│   │   ├── project_model.dart                     # Model project
│   │   ├── assignment_model.dart                  # Model assignment
│   │   ├── subtask_model.dart                     # Model subtask
│   │   └── comment_model.dart                     # Model comment
│   └── repositories/
│       └── card_repository_impl.dart              # Implementasi repository
├── domain/
│   ├── entities/
│   │   ├── card.dart                              # Entity card (business object)
│   │   ├── user.dart                              # Entity user
│   │   ├── board.dart                             # Entity board
│   │   ├── project.dart                           # Entity project
│   │   ├── assignment.dart                        # Entity assignment
│   │   ├── subtask.dart                           # Entity subtask
│   │   └── comment.dart                           # Entity comment
│   ├── repositories/
│   │   └── card_repository.dart                   # Interface repository
│   └── use_cases/
│       └── get_cards_use_case.dart                # Use case untuk get cards
└── presentation/
    ├── cubits/
    │   ├── card_cubit.dart                        # Cubit untuk state management
    │   └── card_state.dart                        # States: Initial, Loading, Loaded, Error
    └── pages/
        └── cards_page.dart                        # UI halaman cards
```


## 🏗️ Arsitektur

### 1. **Data Layer**
- **Data Sources**: Menghandle komunikasi dengan API menggunakan Dio
- **Models**: Extend dari entities, menambahkan `fromJson()` dan `toJson()`
- **Repositories Implementation**: Bridge antara data sources dan domain layer


### 2. **Domain Layer**
- **Entities**: Pure business objects (immutable, no framework dependencies)
- **Repositories Interface**: Contract untuk data operations
- **Use Cases**: Single responsibility business logic


### 3. **Presentation Layer**
- **Cubits**: State management menggunakan flutter_bloc
- **States**: Sealed class untuk type-safe state handling
- **Pages**: UI widgets yang reactive terhadap state changes


## 🔄 Flow Data

```
UI (CardsPage) 
    ↓ fetchCards()
CardCubit 
    ↓ call()
GetCardsUseCase 
    ↓ getCards()
CardRepository 
    ↓ getCards()
CardRemoteDataSource 
    ↓ HTTP GET
API (http://127.0.0.1:8000/api/v1/card)
```


## 🚀 Cara Menggunakan

### 1. Setup Dependencies (sudah dilakukan di `main.dart`)

```dart
// Card dependencies sudah di-setup di main.dart
final cardRemoteDataSource = CardRemoteDataSourceImpl(dioClient.instance);
final cardRepository = CardRepositoryImpl(remoteDataSource: cardRemoteDataSource);
final getCardsUseCase = GetCardsUseCase(repository: cardRepository);

// CardCubit sudah di-provide menggunakan MultiBlocProvider
BlocProvider(
  create: (_) => CardCubit(getCardsUseCase: getCardsUseCase),
),
```


### 2. Gunakan di UI

```dart
// Fetch cards
context.read<CardCubit>().fetchCards();

// Listen to state changes
BlocBuilder<CardCubit, CardState>(
  builder: (context, state) {
    return switch (state) {
      CardInitial() => Text('Initial state'),
      CardLoading() => CircularProgressIndicator(),
      CardLoaded(:final cards) => ListView.builder(...),
      CardError(:final message) => Text('Error: $message'),
    };
  },
)
```


### 3. Tambahkan route (opsional)

Di `app_router.dart`:

```dart
GoRoute(
  path: CardsPage.routeName,
  builder: (context, state) => const CardsPage(),
),
```


## 📝 API Response Format

```json
{
  "title": "My Cards",
  "data": [
    {
      "id": 11,
      "board_id": 2,
      "card_title": "Write unit tests",
      "description": "Create comprehensive test coverage...",
      "position": 5,
      "created_by": 1,
      "created_at": "2025-10-29T07:43:04.000000Z",
      "due_date": "2025-11-19T00:00:00.000000Z",
      "status": "todo",
      "priority": "medium",
      "estimated_hours": "6.00",
      "actual_hours": "0.00",
      "creator": { ... },
      "board": { 
        "project": { ... }
      },
      "assignments": [ ... ],
      "subtasks": [ ... ],
      "comments": [ ... ]
    }
  ]
}
```


## ✅ Features

- ✅ Fetch semua cards dari API dengan authentication (Bearer token)
- ✅ Display cards dengan informasi lengkap (status, priority, due date, etc)
- ✅ Pull-to-refresh untuk reload data
- ✅ Error handling dengan user-friendly messages
- ✅ Loading states dengan indicators
- ✅ Reactive UI menggunakan BlocBuilder
- ✅ Clean Architecture dengan separation of concerns
- ✅ Type-safe state management dengan sealed classes


## 🔐 Authentication

Token Bearer otomatis ditambahkan ke setiap request oleh `AuthInterceptor` yang sudah di-setup di `DioClient`.


## 🎨 UI Features

- Card list dengan informasi lengkap
- Color-coded status dan priority chips
- Creator dan assignment information
- Board dan project context
- Pull-to-refresh support
- Error state dengan retry button
- Loading indicator


## 📦 Dependencies

- `dio`: ^5.9.0 - HTTP client untuk API calls
- `flutter_bloc`: ^9.1.1 - State management dengan Cubit
- `go_router`: ^16.2.1 - Navigation (opsional untuk routing)


## 🧪 Testing

Struktur clean architecture memudahkan testing:

```dart
// Mock repository untuk testing use case
class MockCardRepository extends Mock implements CardRepository {}

// Mock use case untuk testing cubit
class MockGetCardsUseCase extends Mock implements GetCardsUseCase {}
```


## 📚 Dokumentasi

Setiap file memiliki dokumentasi lengkap dengan:
- Description class/method
- Parameter explanations
- Return type explanations
- Error handling notes
- Jeda 4 baris antara komentar dan kode


## 🔧 Maintenance

Untuk menambahkan operasi baru (create, update, delete):

1. Tambahkan method di `CardRemoteDataSource`
2. Implement di `CardRemoteDataSourceImpl`
3. Tambahkan method di `CardRepository`
4. Implement di `CardRepositoryImpl`
5. Buat use case baru (misal: `CreateCardUseCase`)
6. Tambahkan method di `CardCubit`
7. Update UI sesuai kebutuhan


## 👨‍💻 Author

Dibuat dengan clean architecture pattern dan best practices Flutter.
