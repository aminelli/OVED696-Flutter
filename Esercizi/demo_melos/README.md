# Task Manager Monorepo

Progetto Flutter demo gestito con Melos che dimostra best practices per strutture monorepo scalabili, condivisione di codice tra applicazioni e gestione efficiente delle dipendenze.

## 📋 Prerequisiti

- **Flutter** 3.27.x o superiore
- **Dart** 3.6.x o superiore
- **Melos** installato globalmente: `dart pub global activate melos`

## 🏗️ Struttura del Progetto

```
task_manager_monorepo/
├── apps/                      # Applicazioni
│   ├── app_mobile/           # App mobile per gestione task
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   └── screens/
│   │   │       └── home_screen.dart
│   │   └── pubspec.yaml
│   └── app_admin/            # App admin dashboard
│       ├── lib/
│       │   └── main.dart
│       └── pubspec.yaml
├── packages/                 # Packages condivisi
│   ├── core/                # Modelli e utilities
│   │   ├── lib/
│   │   │   ├── core.dart
│   │   │   ├── models/
│   │   │   │   ├── task.dart
│   │   │   │   └── user.dart
│   │   │   └── utils/
│   │   │       ├── date_formatter.dart
│   │   │       └── validators.dart
│   │   └── pubspec.yaml
│   └── ui_components/       # Widget e tema condivisi
│       ├── lib/
│       │   ├── ui_components.dart
│       │   ├── widgets/
│       │   │   ├── primary_button.dart
│       │   │   ├── task_card.dart
│       │   │   └── user_avatar.dart
│       │   └── theme/
│       │       └── app_theme.dart
│       └── pubspec.yaml
├── melos.yaml               # Configurazione Melos
├── pubspec.yaml             # Root pubspec
├── prompting.md             # Prompt e linee guida del progetto
└── README.md                # Questo file
```

## 🚀 Setup e Installazione

### 1. Clona il repository
```bash
cd D:\Temp\Flutter\App\demo_melos
```

### 2. Bootstrap con Melos
```bash
melos bootstrap
```

Questo comando:
- Installa le dipendenze per tutti i packages
- Collega i packages locali tra loro
- Genera i file necessari

### 3. Esegui un'app

**App Mobile:**
```bash
cd apps/app_mobile
flutter run
```

**App Admin:**
```bash
cd apps/app_admin
flutter run
```

Oppure usando Melos:
```bash
melos run:mobile
melos run:admin
```

## 📦 Packages

### Core
**Path**: `packages/core`  
**Descrizione**: Package con modelli di dominio, utilities e logica business condivisa.

**Contenuto**:
- **Models**: 
  - `Task`: Modello immutabile per i task con gestione dello stato (completato/non completato)
  - `User`: Modello utente con ruoli (admin, moderator, user)
- **Utils**: 
  - `DateFormatter`: Formattazione date in formato italiano con supporto date relative
  - `Validators`: Validazione input (email, password, nomi, telefono, URL)

**Dipendenze**: 
- `intl`: Per formattazione date localizzate

### UI Components
**Path**: `packages/ui_components`  
**Descrizione**: Componenti UI riusabili e tema Material Design 3 condiviso.

**Contenuto**:
- **Widgets**:
  - `PrimaryButton` / `SecondaryButton`: Button con stati loading e disabled
  - `TaskCard`: Card per visualizzare task con checkbox e dettagli
  - `UserAvatar` / `UserAvatarWithName`: Avatar utente con iniziali o immagine
- **Theme**:
  - `AppTheme`: Tema light/dark Material Design 3 consistente

**Dipendenze**:
- `core`: Package locale per i modelli

## 🚀 Apps

### App Mobile
**Path**: `apps/app_mobile`  
**Descrizione**: Applicazione mobile per la gestione personale dei task.

**Features**:
- Visualizzazione lista task con filtri (tutti, attivi, completati)
- Aggiunta nuovi task con titolo e descrizione
- Completamento/decomple tamento task con tap
- Visualizzazione dettagli task
- UI responsive con Material Design 3
- Stato vuoto con messaggi contestuali

**Schermate**:
- `HomeScreen`: Lista task con filtri e dialog per aggiunta/dettagli

### App Admin
**Path**: `apps/app_admin`  
**Descrizione**: Dashboard amministrativa per visualizzare statistiche aggregate.

**Features**:
- Card statistiche (totale task, completati, attivi, utenti)
- Barra di progresso per percentuale completamento
- Lista utenti registrati con avatar e ruoli
- Badge colorati per ruoli utente (Admin, Moderator, User)
- Dashboard responsive con layout adattivo

**Schermate**:
- `DashboardScreen`: Vista principale con statistiche e utenti

## 🛠️ Comandi Utili

### Gestione Melos

```bash
# Bootstrap del progetto (prima volta)
melos bootstrap

# Pulisci tutti i packages
melos run clean

# Analizza il codice
melos run analyze

# Formatta il codice
melos run format

# Verifica formattazione senza modificare
melos run format:check

# Esegui i test
melos run test

# Ottieni le dipendenze
melos run get

# Aggiorna le dipendenze
melos run upgrade
```

### Sviluppo App

```bash
# Esegui app mobile
melos run:mobile
# oppure
cd apps/app_mobile && flutter run

# Esegui app admin
melos run:admin
# oppure
cd apps/app_admin && flutter run

# Build APK app mobile
melos build:mobile

# Build APK app admin
melos build:admin
```

### Sviluppo Packages

```bash
# Lavora su un package specifico
cd packages/core
flutter pub get
dart analyze

# Esegui test per un package
cd packages/core
flutter test
```

## 🧪 Testing

Il progetto è configurato per supportare test unitari e widget. Struttura suggerita:

```
packages/core/
└── test/
    ├── models/
    │   ├── task_test.dart
    │   └── user_test.dart
    └── utils/
        ├── date_formatter_test.dart
        └── validators_test.dart
```

Esegui tutti i test:
```bash
melos run test
```

## 📖 Architettura

### Pattern e Best Practices

- **Immutability**: Tutti i modelli sono immutabili con metodi `copyWith()`
- **Null Safety**: Codice completamente null-safe
- **File Barrel**: Ogni package espone API pubbliche tramite file barrel principale
- **Material Design 3**: Tema consistente con supporto light/dark mode
- **Responsive Design**: Layout adattivo per diverse dimensioni schermo

### Dipendenze tra Package

```
apps/app_mobile → packages/ui_components → packages/core
apps/app_admin → packages/ui_components → packages/core
```

**Note**:
- `core` non ha dipendenze da altri package locali (massima riusabilità)
- `ui_components` dipende da `core` per i modelli 
- Le app dipendono da entrambi i packages

## 🎨 Tema e Stile

Il progetto usa Material Design 3 con:
- **Colore Primario**: Viola Material (`#6750A4`)
- **Supporto Dark Mode**: Automatico basato su impostazioni sistema
- **Bordi Arrotondati**: 12px per card e button
- **Spacing Consistente**: 4, 8, 16, 24, 32px

Personalizza in `packages/ui_components/lib/theme/app_theme.dart`

## 🤝 Contribuire

1. Fork il progetto
2. Crea un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Esegui `melos run analyze` e `melos run format` prima del commit
4. Commit le modifiche (`git commit -m 'Add some AmazingFeature'`)
5. Push al branch (`git push origin feature/AmazingFeature`)
6. Apri una Pull Request

### Linee Guida

- Mantieni il codice null-safe
- Aggiungi commenti in italiano per documentazione
- Usa nomi in inglese per classi, variabili e metodi
- Esegui `melos run analyze` senza errori
- Formatta il codice con `melos run format`

## 📝 Convenzioni di Codifica

### Naming
- **Packages**: `snake_case` (es: `ui_components`, `core`)
- **Classi**: `UpperCamelCase` (es: `Task`, `HomeScreen`)
- **Variabili/Metodi**: `lowerCamelCase` (es: `userName`, `fetchData`)
- **Costanti**: `lowerCamelCase` (es: `maxRetries`, `defaultTimeout`)
- **File**: `snake_case.dart` (es: `home_screen.dart`, `user_avatar.dart`)

### Commenti
- **Documentazione**: Commenti `///` in italiano sopra classi e metodi pubblici
- **Codice**: Nomi in inglese, commenti esplicativi in italiano se necessari
- **TODO**: Usa `// TODO: descrizione` per miglioramenti futuri

## 🐛 Troubleshooting

### Problema: `melos bootstrap` fallisce
**Soluzione**:
1. Verifica che Melos sia installato: `melos --version`
2. Controlla i path dependencies nei pubspec.yaml
3. Esegui `melos clean` e riprova

### Problema: Errori di import tra packages
**Soluzione**:
1. Verifica che i package siano dichiarati correttamente nei pubspec.yaml
2. Assicurati di importare dal file barrel (es: `import 'package:core/core.dart'`)
3. Esegui `melos bootstrap` per aggiornare i link

### Problema: Hot reload non funziona
**Soluzione**:
1. Modifiche ai packages richiedono hot restart invece di hot reload
2. Premi `R` nel terminale o usa il pulsante hot restart nell'IDE
3. Se persiste, ferma l'app e rilancia con `flutter run`

### Problema: Dipendenze circolari
**Soluzione**:
1. Rivedi l'architettura: `core` non deve dipendere da altri packages locali
2. Estrai codice condiviso in un package separato se necessario
3. Usa dependency injection per invertire le dipendenze

### Problema: Errori di compilazione dopo bootstrap
**Soluzione**:
1. Esegui `melos clean` per pulire tutte le build
2. Esegui `melos get` per scaricare le dipendenze
3. Esegui `melos bootstrap` nuovamente
4. Se necessario, riavvia l'IDE

## 📚 Risorse Utili

- **Melos Documentation**: https://melos.invertase.dev/
- **Flutter Monorepo Best Practices**: https://docs.flutter.dev/packages-and-plugins/developing-packages
- **Dart Packages**: https://dart.dev/guides/packages
- **Effective Dart**: https://dart.dev/guides/language/effective-dart
- **Material Design 3**: https://m3.material.io/

## 📄 License

Questo è un progetto demo per scopi educativi.

## 👥 Autori

Creato come demo di monorepo Flutter con Melos.

---

**Versione**: 1.0.0  
**Data Creazione**: Aprile 2026  
**Compatibilità**: Flutter 3.27.x, Dart 3.6.x, Melos 6.x
