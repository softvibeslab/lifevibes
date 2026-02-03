# LifeVibes Flutter App

## 🗿 Transforma tu talento en una empresa digital escalable

Aplicación de avatar personalizado con coaching AI, gamificación y metodología Softvibes1.

## 🚀 Tecnologías

- **Flutter 3.16+**: Framework principal para iOS y Android
- **Firebase**: Backend completo (Auth, Firestore, Storage, Cloud Functions, FCM, Realtime Database)
- **BLoC**: State management
- **PoppyAI**: ChatGPT entrenado con metodología Softvibes

## 📱 MVP Sprint 1-2

### Features implementadas:
- ✅ Flutter project setup
- ✅ Firebase configuration (Android + iOS)
- ✅ Firebase Auth integration (login, registro, logout)
- ✅ Onboarding screens (Ritual de Origen)
  - El Espejo del Alma: Selección de valores (Tinder-swipe)
  - La Forja del Superpoder: Selección de pasiones
  - Propósito del usuario
- ✅ Gamified theme (60fps animations)
- ✅ BLoC architecture

### Próximas features:
- ⏳ Avatar creation and visualization
- ⏳ PoppyAI integration (onboarding coach)
- ⏳ Cloud Functions integration

## 🏗️ Estructura del proyecto

```
lib/
├── core/
│   ├── constants/         # Constantes (Firebase, etc.)
│   ├── theme/             # Temas y colores
│   └── utils/             # Utilidades
├── features/
│   ├── auth/              # Autenticación
│   │   ├── bloc/
│   │   ├── data/
│   │   ├── models/
│   │   └── presentation/
│   ├── onboarding/        # Ritual de Origen
│   │   ├── bloc/
│   │   └── presentation/
│   │       └── pages/
│   ├── avatar/            # Avatar system
│   └── home/              # Home screen
└── main.dart             # Entry point
```

## 🔥 Metodología Softvibes1

### Fase 1: EL SER
- **El Espejo del Alma**: Tinder-swipe para valores y pasiones
- **La Forja del Superpoder**: Habilidades → Superpoderes con niveles 1-10
- **Alineación de Vibras**: Sistema de filtrado de resonancia

### Fase 2: EL HACER (Próximos sprints)
- **El Motor de Conexion**: Tinder de Conocimiento para networking
- **Misiones de Contenido**: Genera contenido guiado con PoppyAI
- **Construcción del Embudo**: Webinar funnel builder paso a paso

### Fase 3: EL TENER (Próximos sprints)
- **Escalera de Valor**: DBY → DWY → DFY
  - DBY ($7-$77): Curso Online o Ebook
  - DWY ($97-$497): Mentoria Grupal
  - DFY ($1,000-$10,000+): Servicio Premium

## 🎨 Colores y Tema

- **Primary**: #6C63FF (LifeVibes Purple)
- **Secondary**: #FF6B6B (Vibrant Red)
- **Background**: #1A1A2E (Dark Blue)
- **XP**: #FFD93D (Golden Yellow)
- **Level**: #6BCB77 (Success Green)

## 📝 Firebase Configuration

**Project ID**: lifevibes-e5915
**Package**: com.softvibes.lifevibes

### Services enabled:
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Cloud Messaging (FCM)
- Realtime Database

## 🚀 Running the app

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android
```

## 🛠️ Development

### Prerequisites
- Flutter 3.16+
- Android Studio / Xcode
- Firebase account

### Firebase Setup
1. Create Firebase project: lifevibes-e5915
2. Enable services (Auth, Firestore, Storage, FCM, Realtime Database)
3. Download `google-services.json` and place in `android/app/`
4. Download `GoogleService-Info.plist` and place in `ios/Runner/`
5. Update build.gradle files with Google Services plugin

## 👥 Equipo Softvibes

- **Roger Garcia Vital**: Visión y estrategia
- **Omar**: Desarrollo (Flutter)
- **Roberto**: Diseño UI/UX
- **Claudio** (🗿): Asistente AI personal

## 📄 License

Proprietary - Softvibes (c) 2026

---

**Construido con buena vibra en Cancun, Mexico** ✨
