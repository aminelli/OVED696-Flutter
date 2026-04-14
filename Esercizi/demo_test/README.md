# 🚀 Flutter Demo - Best Practices Complete

[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.x-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.11.x-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Demo completa di un'applicazione Flutter **production-ready** che implementa tutte le best practices di sviluppo professionale.

---

## 📋 Indice

- [Features](#-features)
- [Architettura](#-architettura)
- [Prerequisiti](#-prerequisiti)
- [Setup Progetto](#-setup-progetto)
- [Esecuzione App](#-esecuzione-app)
- [Testing](#-testing)
  - [Unit Tests](#unit-tests)
  - [Widget Tests](#widget-tests)
  - [Integration Tests](#integration-tests)
  - [Golden Tests](#golden-tests)
  - [Test Coverage](#test-coverage)
- [Flavors](#-flavors)
- [Build Produzione](#-build-produzione)
- [Code Quality](#-code-quality)
- [Struttura Progetto](#-struttura-progetto)
- [Troubleshooting](#-troubleshooting)
- [Risorse](#-risorse)

---

## ✨ Features

### Testing Completo
- ✅ **Unit Tests** - Test della business logic e repository
- ✅ **Widget Tests** - Test dei componenti UI
- ✅ **Integration Tests** - Test end-to-end dei user flows
- ✅ **Golden Tests** - Screenshot testing per regression UI
- ✅ **Mocking con Mockito** - Mock di datasources e servizi
- ✅ **Test Coverage** - Reportistica copertura codice

### Build Configuration
- ✅ **3 Flavors** (Dev/Stage/Prod) - Ambienti separati
- ✅ **Environment Variables** - Configurazione sicura (.env files)
- ✅ **Obfuscation** - Protezione codice per release
- ✅ **Minification** - Riduzione dimensione app
- ✅ **Icone differenziate** - Per ogni ambiente

### Code Quality
- ✅ **Analisi Statica** - Lint rules strict e personalizzate
- ✅ **Null Safety** - Codice completamente null-safe
- ✅ **Clean Architecture** - Separazione responsabilità
- ✅ **Performance Optimization** - Widget const, lazy loading

### State Management
- ✅ **Provider** - Gestione stato reattiva
- ✅ **Dependency Injection** - Design pattern scalabile

### Tools & Utilities
- ✅ **FVM Support** - Version management Flutter
- ✅ **Build Runner** - Code generation automatica
- ✅ **Environment Config** - Configurazioni per ambiente

---

## 🏗️ Architettura

Il progetto segue i principi della **Clean Architecture** con separazione in layer:

```
lib/
├── core/                    # Codice condiviso
│   ├── config/             # Configurazioni app
│   ├── constants/          # Costanti globali
│   ├── theme/              # Temi e stili
│   └── utils/              # Utilities
├── features/               # Features modulari
│   ├── home/
│   │   └── presentation/  # UI layer
│   └── tasks/
│       ├── data/          # Data layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/        # Business logic layer
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/  # UI layer
│           ├── pages/
│           ├── providers/
│           └── widgets/
└── main.dart              # Entry point
```

**Principi applicati:**
- **Separation of Concerns** - Ogni layer ha responsabilità specifiche
- **Dependency Rule** - Le dipendenze puntano verso l'interno
- **Testability** - Ogni layer è testabile indipendentemente
- **Scalability** - Facile aggiungere nuove features

---

## 📦 Prerequisiti

Prima di iniziare, assicurati di avere installato:

- **Flutter SDK** `>= 3.41.0`
- **Dart SDK** `>= 3.11.0`
- **Android Studio** o **VS Code** con Flutter extensions
- **Xcode** (per iOS, solo su macOS)
- **Git**
- **FVM** (opzionale, consigliato) - `dart pub global activate fvm`

Verifica l'installazione:
```bash
flutter doctor -v
```

---

## 🚀 Setup Progetto

### 1. Clona il Repository

```bash
git clone <repository-url>
cd demo_test
```

### 2. Setup Flutter Version (con FVM - Opzionale)

Se usi FVM per gestire le versioni Flutter:

```bash
# Installa la versione richiesta
fvm install 3.41.0

# Usa la versione per questo progetto
fvm use 3.41.0

# Usa fvm flutter invece di flutter
fvm flutter --version
```

### 3. Installa le Dipendenze

```bash
flutter pub get
```

### 4. Genera il Codice (Mocks, Serialization)

```bash
# Genera i file .mocks.dart e altri file generati
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Setup Environment Files

I file `.env` sono già inclusi nel progetto, ma verifica il contenuto:

- `.env.dev` - Configurazione Development
- `.env.stage` - Configurazione Staging
- `.env.prod` - Configurazione Production

**⚠️ IMPORTANTE**: Non committare mai chiavi API reali nei file .env!

---

## 🏃 Esecuzione App

### Development Mode (Default)

```bash
# Esegui con configurazione development
flutter run

# Oppure specificando il flavor
flutter run --flavor dev -t lib/main.dart
```

### Staging Mode

```bash
# Esegui con configurazione staging
flutter run --flavor stage -t lib/main.dart
```

### Production Mode

```bash
# Esegui con configurazione production
flutter run --flavor prod -t lib/main.dart
```

### Con Dart Defines (Variabili Custom)

```bash
flutter run \
  --dart-define=API_BASE_URL=https://custom-api.com \
  --dart-define=APP_NAME="Custom App Name"
```

### Debug su Device Specifico

```bash
# Lista dispositivi disponibili
flutter devices

# Esegui su dispositivo specifico
flutter run -d <device-id>
```

---

## 🧪 Testing

Il progetto include una suite di test completa per garantire qualità e affidabilità.

### Test Structure

```
test/
├── core/                          # Test core utilities
├── features/
│   └── tasks/
│       ├── data/
│       │   ├── models/           # Test dei models
│       │   └── repositories/     # Test repository con mocks
│       └── presentation/
│           └── widgets/          # Widget tests
├── widget_test.dart              # Test app widget
integration_test/
└── app_test.dart                 # Integration tests E2E
```

---

### Unit Tests

Test della business logic, models, e repositories.

```bash
# Esegui tutti gli unit tests
flutter test

# Esegui test specifici
flutter test test/features/tasks/data/models/task_model_test.dart

# Esegui test di una categoria
flutter test test/features/tasks/data/
```

**Esempi di Unit Tests inclusi:**
- ✅ Task Model serialization/deserialization
- ✅ Repository con datasource mockato
- ✅ CRUD operations

---

### Widget Tests

Test dei componenti UI senza necessità di un device.

```bash
# Esegui tutti i widget tests
flutter test test/features/tasks/presentation/

# Test specifico
flutter test test/features/tasks/presentation/widgets/add_task_dialog_test.dart
```

**Widget Tests inclusi:**
- ✅ AddTaskDialog rendering e validazione
- ✅ TaskListItem interazioni
- ✅ Form validation

**Esegui con verbose output:**
```bash
flutter test --reporter expanded
```

---

### Integration Tests

Test end-to-end che simulano il comportamento utente reale.

```bash
# Esegui integration tests
flutter test integration_test/app_test.dart

# Su device reale/emulatore
flutter drive \
  --driver=test_driver/integration_test_driver.dart \
  --target=integration_test/app_test.dart
```

**User Flows testati:**
1. ✅ Navigazione a Tasks e creazione task
2. ✅ Completamento task
3. ✅ Eliminazione task con conferma
4. ✅ Pull-to-refresh lista

**Con device specifico:**
```bash
flutter test integration_test/app_test.dart -d <device-id>
```

---

### Golden Tests

Screenshot testing per verificare regressioni visive.

#### Generare Golden Files (Prima Esecuzione)

```bash
# Genera i golden files di riferimento
flutter test --update-goldens

# Genera solo per test specifici
flutter test --update-goldens test/features/tasks/presentation/widgets/
```

#### Eseguire Golden Tests

```bash
# Verifica che l'UI corrisponda ai golden files
flutter test

# Se i test falliscono, controlla le differenze e rigenera se necessario
flutter test --update-goldens
```

**⚠️ Nota**: I golden tests sono sensibili alla piattaforma. Usa sempre lo stesso OS per generarli.

---

### Test Coverage

Genera report di copertura del codice.

```bash
# Esegui test con coverage
flutter test --coverage

# Genera report HTML (richiede lcov)
# Su Windows con Chocolatey:
# choco install lcov

# Genera HTML
genhtml coverage/lcov.info -o coverage/html

# Apri report nel browser
start coverage/html/index.html
```

**Target Coverage**: 80%+ per codice production-ready

**Visualizza coverage inline in VS Code:**
- Installa extension "Coverage Gutters"
- Esegui test con coverage
- Clicca su "Watch" nella status bar

---

### Eseguire TUTTI i Test

Script per eseguire l'intera suite di testing:

```bash
# 1. Unit e Widget Tests
flutter test

# 2. Integration Tests
flutter test integration_test/

# 3. Con Coverage
flutter test --coverage

# 4. Analisi statica
flutter analyze

# 5. Format check
dart format --set-exit-if-changed lib/ test/
```

---

## 🎨 Flavors

Il progetto supporta 3 ambienti (flavors) separati.

### Configurazione Flavors

| Flavor | App Name | Package ID | API URL | Features |
|--------|----------|------------|---------|----------|
| **Dev** | [DEV] Demo App | com.example.demo.dev | api-dev.example.com | Debug logging, Dev tools |
| **Stage** | [STAGE] Demo App | com.example.demo.stage | api-stage.example.com | Analytics, Crashlytics |
| **Prod** | Demo App | com.example.demo | api.example.com | Obfuscation, Minification |

### Eseguire con Flavors

```bash
# Development
flutter run --flavor dev -t lib/main.dart

# Staging
flutter run --flavor stage -t lib/main.dart

# Production
flutter run --flavor prod -t lib/main.dart
```

### Cambiare Configurazione

Modifica i file `.env.*` per personalizzare:
- API endpoints
- Feature flags
- Timeout values
- Analytics settings

---

## 📦 Build Produzione

### Android

#### APK (Debug Build)

```bash
flutter build apk --flavor prod -t lib/main.dart
```

#### APK (Release with Obfuscation)

```bash
flutter build apk \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

#### App Bundle (Play Store)

```bash
flutter build appbundle \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Output**: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

### iOS

```bash
# Build IPA
flutter build ipa \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/ios/symbols
```

**Output**: `build/ios/ipa/demo_test.ipa`

### Web

```bash
flutter build web --release
```

**Output**: `build/web/`

---

## 📊 Code Quality

### Analisi Statica

```bash
# Esegui analyzer
flutter analyze

# Con output dettagliato
flutter analyze --verbose
```

### Lint Rules

Il progetto usa `analysis_options.yaml` con regole strict:
- Null safety enforced
- Prefer const constructors
- Avoid print statements
- Required documentation
- Custom naming conventions

### Code Formatting

```bash
# Formatta il codice
dart format lib/ test/

# Check senza modificare
dart format --set-exit-if-changed lib/ test/

# Formatta file specifico
dart format lib/main.dart
```

### Auto-fix Issues

```bash
# Applica fix automatici
dart fix --apply

# Dry-run (vedi cosa verrebbe cambiato)
dart fix --dry-run
```

---

## 📁 Struttura Progetto

```
demo_test/
├── .env.dev                    # Env variables development
├── .env.stage                  # Env variables staging
├── .env.prod                   # Env variables production
├── .fvmrc                      # FVM configuration
├── analysis_options.yaml       # Lint rules
├── pubspec.yaml               # Dependencies
├── README.md                  # Questo file
│
├── lib/
│   ├── main.dart              # Entry point
│   ├── app.dart               # App widget
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart           # Configurazioni app
│   │   ├── constants/
│   │   │   └── app_constants.dart        # Costanti
│   │   ├── theme/
│   │   │   └── app_theme.dart            # Temi Material
│   │   └── utils/
│   │       └── app_logger.dart           # Logging utility
│   │
│   └── features/
│       ├── home/
│       │   └── presentation/
│       │       └── pages/
│       │           └── home_page.dart    # Home screen
│       │
│       └── tasks/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── task_local_datasource.dart
│           │   ├── models/
│           │   │   └── task_model.dart
│           │   └── repositories/
│           │       └── task_repository_impl.dart
│           │
│           ├── domain/
│           │   ├── entities/
│           │   │   └── task.dart
│           │   └── repositories/
│           │       └── task_repository.dart
│           │
│           └── presentation/
│               ├── pages/
│               │   └── tasks_page.dart
│               ├── providers/
│               │   └── task_provider.dart
│               └── widgets/
│                   ├── add_task_dialog.dart
│                   └── task_list_item.dart
│
├── test/                       # Unit & Widget tests
│   ├── core/
│   ├── features/
│   │   └── tasks/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   └── task_model_test.dart
│   │       │   └── repositories/
│   │       │       └── task_repository_test.dart
│   │       └── presentation/
│   │           └── widgets/
│   │               └── add_task_dialog_test.dart
│   └── widget_test.dart
│
├── integration_test/           # Integration tests
│   └── app_test.dart
│
├── android/                    # Android native
├── ios/                        # iOS native
├── web/                        # Web
├── windows/                    # Windows
├── linux/                      # Linux
└── macos/                      # macOS
```

---

## 🔧 Troubleshooting

### 1. Errore: "Target of URI doesn't exist"

**Problema**: File generati mancanti (`.mocks.dart`, `.g.dart`)

**Soluzione**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Errore: "Waiting for another flutter command to release the startup lock"

**Soluzione**:
```bash
# Windows
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe

# macOS/Linux
killall -9 dart
killall -9 flutter
```

### 3. Build fallisce con flavor

**Soluzione**:
```bash
# Pulisci build cache
flutter clean
flutter pub get
# Rebuild
flutter build apk --flavor prod -t lib/main.dart
```

### 4. Golden tests falliscono

**Problema**: Differenze piattaforma o risoluzione

**Soluzione**:
```bash
# Rigenera golden files sulla tua piattaforma
flutter test --update-goldens
```

### 5. Integration tests non partono

**Verifica**:
```bash
# Assicurati che il device/emulatore sia avviato
flutter devices

# Reinstalla app
flutter clean
flutter pub get
flutter test integration_test/
```

### 6. Dependency conflicts

**Soluzione**:
```bash
# Risolvi conflitti dipendenze
flutter pub upgrade --major-versions

# Oppure
flutter pub outdated
flutter pub upgrade
```

---

## 📚 Risorse

### Documentazione Ufficiale
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Mockito Guide](https://pub.dev/packages/mockito)

### Best Practices
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Testing Flutter Apps](https://flutter.dev/docs/testing)

### Tools
- [FVM - Flutter Version Management](https://fvm.app/)
- [Build Runner](https://pub.dev/packages/build_runner)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)

---

## 🤝 Contribuire

Questo è un progetto educational/demo. Per contribuire:

1. Fork il repository
2. Crea un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Commit le modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

---

## 📝 License

Questo progetto è distribuito sotto licenza MIT. Vedi file `LICENSE` per dettagli.

---

## 👥 Autori

- **Demo Project** - Progetto educational per best practices Flutter

---

## 🎯 Checklist Completamento

- [x] Clean Architecture implementata
- [x] Unit tests con coverage
- [x] Widget tests
- [x] Integration tests
- [x] Golden tests setup
- [x] Mocking con Mockito
- [x] 3 Flavors configurati (Dev/Stage/Prod)
- [x] Environment variables
- [x] Analisi statica configurata
- [x] Theme customizzato
- [x] State management con Provider
- [x] Performance optimizations
- [x] Documentazione completa

---

## 📞 Supporto

Per domande o problemi:
- Apri una [Issue](../../issues)
- Consulta la [Documentazione Flutter](https://flutter.dev/docs)
- Community: [Flutter Community](https://flutter.dev/community)

---

**Buon coding! 🚀**
