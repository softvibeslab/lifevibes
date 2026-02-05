# LifeVibes 🗿

> Transforma tu talento en una empresa digital escalable con gamificación y coaching AI.

**Metodología:** Softvibes1 (SER → HACER → TENER)

---

## Vision

LifeVibes es una aplicación de avatar personalizado que funciona como coach para mejorar vida personal y negocios. Inspirada en Tamagotchi, The Sims y Need for Speed.

**Core Concept:**
Un avatar personalizado que:
- Se cuida como un Tamagotchi (nutrición, crecimiento)
- Se personaliza como en The Sims (apariencia, habilidades)
- Se mejora como en Need for Speed (ramificaciones, upgrades)

## Metodología Softvibes1: SER → HACER → TENER

**SER (Be):** Introspección, identidad, propósito
**HACER (Do):** Comunicar, ejecutar, automatizar
**TENER (Have):** Resultados, monetización, éxito

## 🎯 Features Principales

### ✅ MVP COMPLETADO (100%)

1. **Avatar Personalizable** 🗿
   - 15+ opciones de personalización
   - Sistema de niveles y XP
   - Badges y gamificación

2. **Coach AI Virtual** 🤖
   - Chat con PoppyAI
   - Metodología Softvibes1
   - Generador de manifiesto
   - Generador de estrategia de contenido

3. **Match System** 💜
   - Algoritmo Softvibes
   - Tinder-like swipe UI
   - Breakdown detallado

4. **Quest System** ⚔️
   - 15+ misiones predefinidas
   - Fases: SER, HACER, TENER
   - XP y badges

5. **Funnel System** 🚀
   - Webinar funnels
   - Lead magnet funnels
   - Product launch funnels

6. **Product System** 💰
   - Escalera de Valor: DBY → DWY → DFY
   - Precios configurables
   - Estadísticas de ventas

7. **Gamification Engine** 🎮
   - 11 niveles de progreso
   - 16+ badges con rarezas
   - Sistema de recompensas

8. **Haptic Feedback** 📳
   - Feedback contextual
   - Patrones específicos

9. **Animation System** ✨
   - 20+ animaciones predefinidas
   - Performance optimizado

## Stack Tecnológico

### Frontend Mobile
- **Flutter 3.27.0** para iOS y Android
- **Animaciones fluidas 60fps** (flutter_animate)
- **UI gamificada tipo videojuego**
- **BLoC** (Business Logic Component) para state management
- **Vibration** para feedback háptico

### Backend & Database
- **Firebase completo:**
  - Firestore: NoSQL database
  - Firebase Auth: Autenticación y 2FA
  - Firebase Storage: Archivos
  - Cloud Functions: Backend serverless
  - FCM: Push notifications
  - Realtime Database: Chat del Match

### AI & Machine Learning
- **PoppyAI** (ChatGPT entrenado con metodología Softvibes)
  - Coach virtual
  - Generador de guiones de video
  - Entrevistador para descubrir propósito
  - Redacta Manifiesto de Marca

## Roadmap de Desarrollo

### ✅ Sprint 1-2 (4 semanas): MVP SER
- ✅ Flutter project setup
- ✅ Firebase Auth implementation
- ✅ Onboarding screens
- ✅ Avatar creation and visualization
- ✅ PoppyAI integration

### ✅ Sprint 3-4 (4 semanas): Match & Quests
- ✅ Match algorithm implementation
- ✅ Tinder-like swipe UI
- ✅ Quest system completo
- ✅ Gamification engine

### ✅ Sprint 5-6 (4 semanas): Funnels & Monetization
- ✅ Webinar funnel builder
- ✅ Products listing and management
- ✅ Funnel metrics
- ✅ Product metrics

### ✅ Sprint 7-8 (4 semanas): Polish & Gamification
- ✅ Gamification engine mejorado
- ✅ Haptic feedback system
- ✅ Animation system mejorado
- ✅ Performance optimization

## Documentación

- `MEMORY.md` - Memoria completa del proyecto
- `SPRINT_7_8_COMPLETE.md` - Progreso Sprint 7-8
- `SPRINT_5_6_COMPLETE.md` - Progreso Sprint 5-6
- `SPRINT_3_4_COMPLETE.md` - Progreso Sprint 3-4
- `IMPLEMENTATION_PROGRESS.md` - Progreso Sprint 1-2
- `docs/BUILD_ANDROID.md` - Guía de compilación Android

## 📱 Build & Deployment

### Compilar APK Android

```bash
# Opción 1: Usar el script automatizado
./scripts/build-android.sh debug

# Opción 2: Comando directo
flutter build apk --release

# El APK se genera en:
# build/app/outputs/flutter-apk/app-release.apk
```

### Instalar en Dispositivo

```bash
# Via ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# O ejecutar directamente
flutter run
```

### Instrucciones Detalladas

Ver `docs/BUILD_ANDROID.md` para guía completa de:
- Configuración de Android Studio
- Creación de keystore para release
- Generación de App Bundle (Google Play)
- Solución de problemas

## Equipo

- **Roger Garcia Vital**: Visión y estrategia
- **Omar**: Desarrollo (Flutter)
- **Roberto**: Diseño UI/UX

---

**Construido con buena vibra en Cancun, Mexico** ✨

**Version:** 1.0.0  
**Estado:** MVP COMPLETADO - 100%  
**Fecha:** 2026-02-03
