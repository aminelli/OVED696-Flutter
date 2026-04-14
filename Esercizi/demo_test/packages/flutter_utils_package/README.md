# Flutter Utils Package

Pacchetto riusabile Dart/Flutter con utilities comuni per semplificare lo sviluppo di applicazioni.

## Features

- ✅ **Validatori**: Email, Password con criteri personalizzabili
- ✅ **String Extensions**: Capitalize, truncate, validazioni
- ✅ **Date Formatting**: Formattatori date con supporto relative time
- ✅ **Pure Dart**: Nessuna dipendenza da piattaforme specifiche

## Installation

Aggiungi al tuo `pubspec.yaml`:

```yaml
dependencies:
  flutter_utils_package:
    path: packages/flutter_utils_package
```

## Usage

### Email Validation

```dart
import 'package:flutter_utils_package/flutter_utils_package.dart';

// Validazione semplice
bool isValid = EmailValidator.isValid('test@example.com'); // true

// Validazione con messaggio di errore
String? error = EmailValidator.validate('invalid-email'); 
// Returns: "Please enter a valid email address"
```

### Password Validation

```dart
import 'package:flutter_utils_package/flutter_utils_package.dart';

// Validazione completa
String? error = PasswordValidator.validate('Weak123');
// Returns: null se valida, messaggio di errore altrimenti

// Calcola forza password (0-100)
int strength = PasswordValidator.calculateStrength('StrongP@ss123'); // ~85

// Verifiche individuali
bool hasUpper = PasswordValidator.hasUppercase('Password'); // true
bool hasDigit = PasswordValidator.hasDigit('Pass123'); // true
```

### String Extensions

```dart
import 'package:flutter_utils_package/flutter_utils_package.dart';

// Capitalize
'hello world'.capitalize; // 'Hello world'
'hello world'.capitalizeWords; // 'Hello World'

// Truncate
'This is a long text'.truncate(10); // 'This is...'

// Validations
'test@example.com'.isEmail; // true
'123.45'.isNumeric; // true
'https://example.com'.isUrl; // true
```

### Date Formatting

```dart
import 'package:flutter_utils_package/flutter_utils_package.dart';

final now = DateTime.now();

// Format standard
DateFormatter.formatDate(now); // '14/04/2026'
DateFormatter.formatTime(now); // '10:30'
DateFormatter.formatDateTime(now); // '14/04/2026 10:30'

// Relative time
DateFormatter.formatRelative(DateTime.now().subtract(Duration(hours: 2))); 
// '2 hours ago'

// Checks
DateFormatter.isToday(now); // true
DateFormatter.isTomorrow(now.add(Duration(days: 1))); // true
```

## Testing

Run tests:

```bash
cd packages/flutter_utils_package
flutter test
```

## Publishing

Per pubblicare su pub.dev:

```bash
# Dry run per verificare
flutter pub publish --dry-run

# Publish reale (dopo review)
# flutter pub publish
```

## License

MIT License
