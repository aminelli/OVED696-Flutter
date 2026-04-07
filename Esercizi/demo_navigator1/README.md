# Task Manager - Demo Navigator 1.0

## 📱 Descrizione

**Task Manager** è un'applicazione completa di gestione task sviluppata in Flutter che dimostra l'utilizzo professionale di **Navigator 1.0** (imperative navigation) in uno scenario reale e pratico.

L'applicazione permette di creare, visualizzare, modificare ed eliminare task con diverse priorità, implementando un sistema di navigazione robusto e ben strutturato che segue le best practices di Flutter.

## 🎯 Obiettivo

Il progetto nasce per dimostrare in modo concreto e didattico come implementare correttamente il sistema di navigazione Navigator 1.0 in Flutter, includendo:
- Named routes con gestione centralizzata
- Passaggio sicuro di argomenti tipizzati tra schermate
- Gestione dello stack di navigazione
- Controllo del back button con conferme utente
- Validazione delle route e gestione degli errori

## ✨ Caratteristiche

### Funzionalità Principali
- ✅ **Gestione Completa Task**: Creazione, visualizzazione, modifica ed eliminazione
- ✅ **Sistema di Priorità**: Tre livelli (bassa, media, alta) con indicatori visivi
- ✅ **Filtri e Ordinamento**: Filtra per stato e ordina per data o priorità
- ✅ **Validazione Form**: Validazione completa con messaggi di errore chiari
- ✅ **Conferme Utente**: Dialog di conferma per azioni critiche
- ✅ **Stato Vuoto**: UI appropriata quando non ci sono dati
- ✅ **Feedback Visivo**: SnackBar e animazioni per feedback immediato
- ✅ **Statistiche**: Contatori real-time dei task

### Navigazione Navigator 1.0
- 🧭 **Named Routes**: Tutte le route definite con nomi costanti
- 🧭 **onGenerateRoute**: Gestione centralizzata con validazione argomenti
- 🧭 **Route Arguments**: Classi tipizzate per passaggio parametri sicuro
- 🧭 **Push & Pop**: Navigazione standard con ritorno dati
- 🧭 **Push Replacement**: Sostituzione route quando necessario
- 🧭 **WillPopScope**: Controllo back button per conferme
- 🧭 **PushAndRemoveUntil**: Reset completo dello stack di navigazione

## 🏗️ Architettura

### Pattern Utilizzati

Il progetto utilizza una **separazione chiara delle responsabilità** con:
- **Modelli**: Classi immutabili per rappresentare i dati
- **Schermate**: Widget che rappresentano intere pagine
- **Widget riutilizzabili**: Componenti UI condivisi
- **Routing centralizzato**: Gestione unica di tutte le route

Pur non utilizzando un pattern architetturale complesso (come BLoC o Provider), il codice è organizzato in modo scalabile e manutenibile, perfetto per progetti di media dimensione o per scopi didattici.

### Navigator 1.0 - Implementazione

L'applicazione implementa Navigator 1.0 con un approccio professionale:

#### 1. **Definizione Route Centralizzata** (`routes.dart`)
Tutte le route sono definite come costanti in un'unica classe:
```dart
class AppRoutes {
  static const String home = '/';
  static const String taskDetail = '/task-detail';
  static const String taskForm = '/task-form';
  static const String settings = '/settings';
}
```

#### 2. **Generatore di Route**
Il `RouteGenerator` gestisce la creazione di tutte le route:
- Valida il nome della route
- Controlla la tipologia degli argomenti
- Gestisce errori di routing
- Fornisce route di fallback

#### 3. **Argomenti Tipizzati**
Classi dedicate per ogni tipo di argomento:
```dart
class TaskDetailArguments {
  final String taskId;
}

class TaskFormArguments {
  final Task? task;
  final bool isEditing;
}
```

#### 4. **Navigazione con Risultato**
Tutte le navigazioni possono restituire risultati:
```dart
final result = await Navigator.pushNamed(
  context,
  AppRoutes.taskForm,
  arguments: TaskFormArguments.create(),
);
```

### Struttura delle Route

```
/                    → HomeScreen (Lista task)
│
├── /task-detail     → TaskDetailScreen (Dettagli singolo task)
│   └── Richiede: TaskDetailArguments(taskId)
│
├── /task-form       → TaskFormScreen (Creazione/Modifica task)
│   └── Opzionale: TaskFormArguments(task, isEditing)
│
└── /settings        → SettingsScreen (Impostazioni app)
    └── Nessun argomento richiesto
```

## 📁 Struttura del Progetto

```
lib/
├── main.dart                    # Entry point e configurazione app
├── routes.dart                  # Definizione route e generatore
│
├── models/                      # Modelli di dati
│   ├── task.dart               # Modello Task e enum Priority
│   └── route_arguments.dart    # Classi per argomenti route
│
├── screens/                     # Schermate dell'applicazione
│   ├── home_screen.dart        # Schermata principale con lista task
│   ├── task_detail_screen.dart # Dettaglio completo di un task
│   ├── task_form_screen.dart   # Form creazione/modifica task
│   └── settings_screen.dart    # Impostazioni e info app
│
└── widgets/                     # Widget riutilizzabili
    ├── task_card.dart          # Card per visualizzare un task
    └── empty_state.dart        # Widget per stato vuoto
```

### Descrizione Dettagliata

#### `main.dart`
Entry point dell'applicazione. Configura:
- Tema generale con Material Design 3
- Sistema di routing Navigator 1.0
- Initial route e gestori di route

#### `routes.dart`
Gestione centralizzata delle route:
- Classe `AppRoutes` con costanti per i nomi delle route
- `RouteGenerator` per creare le route con validazione
- Gestione di route sconosciute e argomenti non validi

#### `models/task.dart`
Modello immutabile del Task con:
- Proprietà: id, title, description, isCompleted, priority, createdAt
- Metodo `copyWith` per modifiche immutabili
- Serializzazione/deserializzazione
- Enum `TaskPriority` con extension per UI

#### `models/route_arguments.dart`
Classi tipizzate per gli argomenti delle route:
- `TaskDetailArguments`: per la navigazione al dettaglio
- `TaskFormArguments`: per creazione/modifica task

#### `screens/home_screen.dart`
Schermata principale con:
- Lista scrollabile di task
- Filtri (tutti, completati, da completare)
- Ordinamento (per data, per priorità)
- Statistiche in tempo reale
- Navigazione: push verso dettaglio, form, impostazioni

#### `screens/task_detail_screen.dart`
Visualizzazione dettagliata task:
- Tutte le informazioni del task
- Azioni: modifica, elimina, condividi, toggle completamento
- WillPopScope per restituire risultato
- Loading state simulato

#### `screens/task_form_screen.dart`
Form per task:
- Validazione completa dei campi
- Modalità creazione/modifica
- WillPopScope per conferma uscita con modifiche non salvate
- Restituisce il task salvato via Navigator.pop

#### `screens/settings_screen.dart`
Impostazioni app:
- Toggle per preferenze utente
- Informazioni sull'app e Navigator 1.0
- Azioni pericolose con conferma
- Esempio di pushAndRemoveUntil per reset

#### `widgets/task_card.dart`
Widget riutilizzabile per visualizzare un task:
- Checkbox per completamento
- Badge priorità colorato
- Tap per navigare al dettaglio

#### `widgets/empty_state.dart`
Widget per stato vuoto:
- Icona e messaggio personalizzabili
- Call-to-action opzionale

## 🔧 Tecnologie e Dipendenze

### SDK
- **Flutter**: ^3.11.4
- **Dart**: ^3.11.4

### Dipendenze Principali

#### Runtime Dependencies
- `flutter` - SDK Flutter
- `cupertino_icons: ^1.0.8` - Icone iOS style
- `intl: ^0.19.0` - Internazionalizzazione e formattazione date/numeri

#### Dev Dependencies
- `flutter_test` - Framework per testing
- `flutter_lints: ^6.0.0` - Regole di linting raccomandate

### Perché Queste Dipendenze?

- **intl**: Necessaria per formattare le date in modo locale (es: `DateFormat('dd/MM/yyyy')`)
- **cupertino_icons**: Fornisce icone iOS utilizzate nell'app
- **flutter_lints**: Garantisce qualità del codice seguendo le best practices Flutter

## 🚀 Setup e Installazione

### Prerequisiti

Prima di iniziare, assicurati di avere:
- ✅ **Flutter SDK** installato (versione 3.11.4 o superiore)
- ✅ **Editor** configurato (VS Code, Android Studio, IntelliJ)
- ✅ **Emulatore** o dispositivo fisico connesso
- ✅ **Dart SDK** (incluso con Flutter)

Per verificare l'installazione di Flutter:
```bash
flutter doctor
```

### Passi di Installazione

1. **Clone o scarica il progetto**
   ```bash
   cd path/to/demo_navigator1
   ```

2. **Installa le dipendenze**
   ```bash
   flutter pub get
   ```
   Questo comando scarica tutte le dipendenze specificate in `pubspec.yaml`.

3. **Verifica che non ci siano errori**
   ```bash
   flutter analyze
   ```

4. **Esegui l'applicazione**
   ```bash
   flutter run
   ```
   
   Oppure, per una piattaforma specifica:
   ```bash
   flutter run -d windows    # Windows
   flutter run -d chrome     # Web
   flutter run -d android    # Android
   flutter run -d ios        # iOS (solo su macOS)
   ```

5. **(Opzionale) Esegui in modalità release**
   ```bash
   flutter run --release
   ```

### Troubleshooting Installazione

**Problema**: Errori durante `flutter pub get`
- **Soluzione**: Verifica la connessione internet e riprova. Se persiste: `flutter clean && flutter pub get`

**Problema**: L'app non si avvia
- **Soluzione**: Controlla che ci sia almeno un dispositivo/emulatore disponibile con `flutter devices`

**Problema**: Errori di compilazione
- **Soluzione**: Esegui `flutter clean` e poi ricompila

## 📱 Utilizzo dell'App

### Guida Passo-Passo

#### 1. **Schermata Principale (Home)**
All'avvio dell'app vedrai:
- Lista dei task esistenti (alcuni precaricati come esempio)
- Statistiche in alto (totali, completati, da fare)
- Barra di ricerca e filtri in alto
- Pulsante "Nuovo Task" in basso a destra

**Azioni disponibili:**
- Tap su un task → Vai ai dettagli
- Checkbox → Toggle completamento
- Icona filtro → Filtra per stato
- Icona ordinamento → Ordina per data/priorità
- Icona impostazioni → Vai alle impostazioni
- FAB "Nuovo Task" → Crea nuovo task

#### 2. **Creazione Nuovo Task**
Dalla home, premi "Nuovo Task":
1. Inserisci il titolo (obbligatorio, 3-100 caratteri)
2. Inserisci una descrizione (opzionale, max 500 caratteri)
3. Seleziona la priorità (bassa, media, alta)
4. Premi "Salva Task"
5. Torna automaticamente alla home con il nuovo task aggiunto

**Note:**
- Se provi a tornare indietro con modifiche non salvate, ricevi una conferma
- La validazione è in tempo reale

#### 3. **Visualizzazione Dettaglio Task**
Tap su un task per vedere:
- Titolo e descrizione completa
- Badge stato (completato/da completare)
- Badge priorità
- Data di creazione
- ID del task

**Azioni disponibili:**
- Pulsante "Completa/Segna come da fare" (FAB in basso)
- Icona condividi → Simula condivisione
- Icona modifica → Vai al form di modifica
- Menu tre puntini → Opzione elimina

#### 4. **Modifica Task**
Dal dettaglio, premi l'icona modifica:
- Il form si apre con i dati già compilati
- Modifica i campi che desideri
- Salva per applicare le modifiche
- Torna indietro per annullare

#### 5. **Eliminazione Task**
Dal dettaglio, menu → Elimina:
- Dialog di conferma
- Conferma → Task eliminato e ritorno alla home
- Annulla → Nessuna azione

#### 6. **Filtri e Ordinamento**
Dalla home:
- **Filtro** → Scegli: Tutti / Completati / Da completare
- **Ordinamento** → Scegli: Per data / Per priorità

#### 7. **Impostazioni**
Dalla home, premi l'icona impostazioni:
- Attiva/disattiva notifiche
- Attiva tema scuro (in arrivo)
- Mostra/nascondi task completati
- Info Navigator 1.0 → Spiega le funzionalità implementate
- Info App → Dialog con versione e credits
- Elimina tutti i task (con conferma)
- Reset app (con conferma)

## 🧭 Flow di Navigazione

### Diagramma del Flusso

```
┌─────────────┐
│    Home     │ (Route iniziale)
└──────┬──────┘
       │
       ├─────[Tap su Task]────────────┐
       │                               ▼
       │                      ┌─────────────────┐
       │                      │   Task Detail   │
       │                      └────────┬────────┘
       │                               │
       │                               ├─[Modifica]───┐
       │                               │               ▼
       │                               │        ┌─────────────┐
       ├─────[Nuovo Task]──────────────┼───────▶│  Task Form  │
       │                               │        └─────────────┘
       │                               │
       │                               └─[Elimina]──[Pop]──▶ Home
       │
       └─────[Impostazioni]────────────┐
                                       ▼
                              ┌──────────────┐
                              │   Settings   │
                              └──────┬───────┘
                                     │
                                     └─[Reset]─[PopAndRemoveUntil]─▶ Home
```

### Metodi Navigator Utilizzati

| Metodo | Dove Utilizzato | Scopo |
|--------|----------------|-------|
| `pushNamed` | Home → Dettaglio, Form, Settings | Navigazione standard con argomenti |
| `pop` | Tutte le schermate | Tornare indietro con opzionale risultato |
| `pushAndRemoveUntil` | Settings → Home (reset) | Pulire tutto lo stack e tornare alla home |

### Passaggio Dati

**Home → Dettaglio**
```dart
Navigator.pushNamed(
  context,
  AppRoutes.taskDetail,
  arguments: TaskDetailArguments(taskId: task.id),
);
```

**Home/Dettaglio → Form**
```dart
// Creazione
Navigator.pushNamed(
  context,
  AppRoutes.taskForm,
  arguments: TaskFormArguments.create(),
);

// Modifica
Navigator.pushNamed(
  context,
  AppRoutes.taskForm,
  arguments: TaskFormArguments.edit(task),
);
```

**Ritorno con Risultato**
```dart
// Nella schermata di destinazione
Navigator.pop(context, task);

// Nella schermata chiamante
final result = await Navigator.pushNamed(...);
if (result != null && result is Task) {
  // Usa il risultato
}
```

## 💡 Concetti Chiave di Navigator 1.0

### Cosa Imparerai da Questo Progetto

#### 1. **Named Routes vs Routes Inline**
Questo progetto usa **named routes** per:
- Centralizzazione della logica di routing
- Facilità di manutenzione
- Type-safe argument passing
- Riusabilità

#### 2. **onGenerateRoute**
Il cuore del routing. Permette di:
- Validare percorsi di navigazione
- Controllare accessi
- Iniettare dipendenze
- Gestire errori in modo centralizzato

#### 3. **Route Arguments**
Passaggio sicuro di dati tra schermate:
- Classi dedicate invece di `Map<String, dynamic>`
- Type-safety a compile-time
- Null-safety integrata
- Documentazione chiara dei requisiti

#### 4. **Stack Management**
Controllo preciso dello stack di navigazione:
- `push`: Aggiunge una route
- `pop`: Rimuove l'ultima route
- `pushReplacement`: Sostituisce la route corrente
- `pushAndRemoveUntil`: Sostituisce tutto lo stack

#### 5. **WillPopScope**
Controllo del back button:
- Conferme prima di uscire
- Salvare dati prima della chiusura
- Prevenire uscite accidentali

#### 6. **Returning Data**
Comunicazione bidirezionale:
- Schermata chiamante riceve risultati
- Pattern async/await per navigazione
- Handling di risultati nulli

### Confronto Navigator 1.0 vs 2.0

| Aspetto | Navigator 1.0 (Questo progetto) | Navigator 2.0 |
|---------|--------------------------------|---------------|
| Complessità | Semplice, imperativo | Più complesso, dichiarativo |
| Curva apprendimento | Bassa | Alta |
| Deep linking | Limitato | Completo |
| Web support | Basico | Avanzato |
| Uso consigliato | App mobile semplici/medie | App web, deep linking complesso |

## 🐛 Troubleshooting

### Problemi Comuni e Soluzioni

#### 1. **Errore: "Could not find a generator for route"**
**Causa**: La route non è definita in `RouteGenerator.generateRoute`
**Soluzione**: Verifica che la route sia presente nello switch case

#### 2. **Errore: "Type 'Null' is not a subtype of type 'TaskDetailArguments'"**
**Causa**: Navigazione senza passare gli argomenti richiesti
**Soluzione**: Passa sempre gli argomenti corretti:
```dart
Navigator.pushNamed(
  context,
  AppRoutes.taskDetail,
  arguments: TaskDetailArguments(taskId: 'id'),  // ← Non dimenticare!
);
```

#### 3. **L'app mostra la schermata di errore route**
**Causa**: Nome route errato o argomenti non validi
**Soluzione**: Usa sempre le costanti da `AppRoutes`:
```dart
// ✅ Corretto
Navigator.pushNamed(context, AppRoutes.home);

// ❌ Errato
Navigator.pushNamed(context, '/home-screen');
```

#### 4. **WillPopScope non previene il back**
**Causa**: Return `true` invece di `false` o mancato `await` sul dialog
**Soluzione**:
```dart
Future<bool> _onWillPop() async {
  final result = await showDialog(...);  // ← await è essenziale
  return result ?? false;  // ← false previene il pop
}
```

#### 5. **Hot reload non funziona dopo modifiche alle route**
**Causa**: Modifiche strutturali richiedono hot restart
**Soluzione**: Usa `flutter run` oppure `R` (hot restart) invece di `r` (hot reload)

#### 6. **Task non si aggiornano dopo modifica**
**Causa**: Mancata chiamata a `setState` o risultato non gestito
**Soluzione**: Gestisci sempre il risultato di `Navigator.pushNamed`:
```dart
final result = await Navigator.pushNamed(...);
if (result != null) {
  setState(() {
    // Aggiorna i dati
  });
}
```

## 📚 Risorse Utili

### Documentazione Ufficiale Flutter
- [Navigation and Routing](https://docs.flutter.dev/development/ui/navigation)
- [Named Routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
- [Pass Arguments to Named Routes](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments)
- [Return Data from Screen](https://docs.flutter.dev/cookbook/navigation/returning-data)
- [Navigator API Reference](https://api.flutter.dev/flutter/widgets/Navigator-class.html)

### Tutorial e Guide
- [Flutter Navigation Basics](https://flutter.dev/docs/development/ui/navigation)
- [Deep Dive into Navigator](https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31)
- [Navigation Codelabs](https://codelabs.developers.google.com/codelabs/flutter-navigation)

### Best Practices
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Material Design Guidelines](https://m3.material.io/)


## 👨‍💻 Autore

Progetto demo per l'apprendimento di Flutter e Navigator 1.0.


