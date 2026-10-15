---
name: flutter-apply-architecture-best-practices
description: Architects a Flutter application using a simple, clean layered approach (UI and Data). Optimized for lightweight apps without domain/use-case overhead.
metadata:
  model: models/gemini-3.1-pro-preview
---
# Architecting Flutter Applications (UI + Data Layer)

## Contents
- [Architectural Layers](#architectural-layers)
- [Project Structure](#project-structure)
- [Workflow: Implementing a New Feature](#workflow-implementing-a-new-feature)
- [Examples](#examples)

## Architectural Layers

Enforce a clean Separation of Concerns by dividing the application into two core layers:

### 1. UI Layer (Presentation)
Implement the MVVM (Model-View-ViewModel) pattern to manage UI state and presentation logic.
*   **Views:** Lean widgets focused purely on presentation, user inputs, animations, and layouts. Views do not contain network or raw business logic.
*   **ViewModels:** Manage UI state and user actions. Extend `ChangeNotifier` (or use `Listenable`). Expose state to the View and interact directly with Repositories.

### 2. Data Layer
Implement the Repository pattern to isolate data sources, caching, and serialization.
*   **Models:** Data classes representing entities, JSON serialization (`fromJson`/`toJson`).
*   **Services:** Stateless client classes that interface with external APIs, databases, WebSockets, or local storage.
*   **Repositories:** The single source of truth for the UI layer. Repositories consume Services, manage data caching/persistence, and provide models directly to ViewModels.

## Project Structure

Organize the codebase with a simple feature-based UI structure and a centralized Data layer:

```text
lib/
├── data/
│   ├── models/         # Data models & entities
│   ├── repositories/   # Repository implementations
│   └── services/       # API clients, local storage, network wrappers
└── ui/
    ├── core/           # Shared widgets, themes, constants
    └── features/
        └── [feature_name]/
            ├── view_models/
            └── views/
```

## Workflow: Implementing a New Feature

Follow this sequential workflow when adding a feature:

### Task Progress
- [ ] **Step 1: Define Data Models.** Create data classes in `lib/data/models/` with JSON serialization.
- [ ] **Step 2: Implement Services.** Create or update API/client services in `lib/data/services/`.
- [ ] **Step 3: Implement Repositories.** Create the repository in `lib/data/repositories/` to coordinate data from services.
- [ ] **Step 4: Implement the ViewModel.** Create the ViewModel extending `ChangeNotifier` in `lib/ui/features/[feature]/view_models/` with repository dependency.
- [ ] **Step 5: Implement the View.** Create the UI widget in `lib/ui/features/[feature]/views/` listening to the ViewModel (via `ListenableBuilder`).
- [ ] **Step 6: Inject Dependencies & Wire Up.** Provide the ViewModel and Repositories via dependency injection (e.g., `Provider`).

## Examples

### Data Layer: Model, Service, and Repository

```dart
// 1. Model (lib/data/models/chat_message.dart)
class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        sender: json['sender'] as String,
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

// 2. Service (lib/data/services/chat_api_service.dart)
class ChatDioHelper {
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    // API or WebSocket call...
    return [];
  }

  Future<void> sendMessage(String text) async {
    // API or WebSocket send...
  }
}

// 3. Repository (lib/data/repositories/chat_repository.dart)
class ChatRepository {
  final ChatDioHelper _dioHelper;
  final List<ChatMessage> _messagesCache = [];

  ChatRepository({required ChatDioHelper DioHelper}) : _dioHelper = DioHelper;

  Future<List<ChatMessage>> getMessages() async {
    final rawData = await _dioHelper.fetchMessages();
    _messagesCache.clear();
    _messagesCache.addAll(rawData.map((json) => ChatMessage.fromJson(json)));
    return List.unmodifiable(_messagesCache);
  }

  Future<void> sendMessage(String text) async {
    await _dioHelper.sendMessage(text);
  }
}
```

### UI Layer: ViewModel and View

```dart
// 4. ViewModel (lib/ui/features/chat/view_models/chat_view_model.dart)
class ChatViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;

  ChatViewModel({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _chatRepository.getMessages();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    await _chatRepository.sendMessage(text);
    await loadMessages();
  }
}

// 5. View (lib/ui/features/chat/views/chat_view.dart)
class ChatView extends StatelessWidget {
  final ChatViewModel viewModel;

  const ChatView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: viewModel.messages.length,
          itemBuilder: (context, index) {
            final message = viewModel.messages[index];
            return ListTile(
              title: Text(message.sender),
              subtitle: Text(message.text),
            );
          },
        );
      },
    );
  }
}
```
