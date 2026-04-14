/// Package core dell'applicazione.
///
/// Contiene i modelli di dominio, utilities condivise e logica business
/// utilizzata da tutte le app del monorepo.
///
/// ## Models
/// - [Task]: Modello per i task dell'applicazione
/// - [User]: Modello per gli utenti
/// - [UserRole]: Enumerazione dei ruoli utente
///
/// ## Utils
/// - [DateFormatter]: Formattazione date
/// - [Validators]: Validazione input utente
library;

// Models
export 'models/task.dart';
export 'models/user.dart';

// Utils
export 'utils/date_formatter.dart';
export 'utils/validators.dart';
