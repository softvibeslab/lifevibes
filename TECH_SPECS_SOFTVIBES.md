# LifeVibes - Especificaciones Tecnicas (Version Softvibes)

## Stack Tecnologico - Softvibes Edition

Esta version de LifeVibes se basa en las herramientas que el equipo de Softvibes (Roger, Omar, Roberto) ya domina.

### Frontend Mobile (Cross-Platform)
- **Flutter 3.16+**: Framework principal para iOS y Android
  - Beneficios: Performance nativa, UI consistente
  - Animaciones fluidas con Flutter Animation
  - Hot Reload para desarrollo rapido

### Backend & Database
- **Firebase**: Backend-as-a-Service completo
  - **Firestore**: NoSQL database en tiempo real
  - **Firebase Auth**: Autenticacion (email, social login, 2FA)
  - **Firebase Storage**: Archivos (fotos, videos, documentos)
  - **Cloud Functions**: Backend serverless
  - **Cloud Messaging (FCM)**: Push notifications
  - **Realtime Database**: Para el chat en tiempo real del Match

### AI & Machine Learning
- **PoppyAI (API ChatGPT entrenada)**
  - Asistente personalizado con metodologia Softvibes
  - Entrenado con prompts y frameworks de Softvibes
  - Funciones:
    - Entrevista al usuario (Ikigai framework)
    - Redacta Manifiesto de Marca
    - Genera guiones de video (basados en Buyer Persona)
    - Coach virtual cuando el usuario esta trabado

### UI/UX Design
- **Flutter widgets** personalizados
- **Animaciones 60fps** para experiencia gamificada
- **Haptic feedback** al completar hitos
- **Sound effects** para recompensas y logros
- **Diseno disruptivo**: Videojuego, NO gestor de tareas tipo Trello/Asana

---

## Arquitectura del Sistema



---

## Firebase Database Schema

### Colecciones Principales

#### users


#### avatars


#### quests (Misiones)


#### matches (Tinder de Conocimiento)


#### knowledge_chunks (Para RAG - opcional futuro)


#### content_pieces (Misiones de Contenido)


#### funnels (Webinars y Embudos)


#### products (Escalera de Valor)


---

## Firebase Cloud Functions

### Backend Endpoints

#### Authentication
- onUserCreate: Crear perfil inicial en avatars collection
- onUserLogin: Actualizar lastLoginTimestamp

#### Match Algorithm
- calculateMatch(data): 
  - Recibe: user1Id, user2Id
  - Calcula: compatibility score basado en algoritmo Softvibes
  - Retorna: compatibilityScore, algorithmScores

#### AI Services (integracion con PoppyAI)
- generateAvatarManifesto(data):
  - Recibe: userProfile, responses from onboarding
  - Llama: PoppyAI API
  - Retorna: Manifesto de marca, UVP, Buyer Persona
  
- generateVideoScript(data):
  - Recibe: buyerPersona, topic, platform
  - Llama: PoppyAI API
  - Retorna: 3 guiones de video
  
- coachChat(data):
  - Recibe: userId, conversationHistory
  - Llama: PoppyAI API con contexto del usuario
  - Retorna: respuesta del coach con metodologia Softvibes

#### Quest Management
- assignDailyQuest(userId): Asigna mision diaria basada en fase actual
- validateQuestCompletion(questId): Valida si quest se completo, otorga XP
- awardBadge(userId, badgeId): Otorga badge al avatar

#### Content & Funnels
- generateFunnelTemplates(userId): Genera plantillas de landing page
- connectEmailMarketing(data): Conecta con ActiveCampaign/ConvertKit
- trackFunnelProgress(funnelId, step): Actualiza progress del Quest

#### Products
- createProductListing(userId): Crea lista de productos
- trackSale(productId): Registra venta y calcula revenue

---

## PoppyAI Integration

### Endpoints de PoppyAI (ChatGPT entrenado)

#### 1. Onboarding Coach


#### 2. Video Script Generator


#### 3. Coach Chat


#### 4. Webinar Hook Generator


---

## Flutter Architecture

### Estructura de Directorios



### State Management
- **BLoC (Business Logic Component)**: Patrones recomendado para Flutter
- Separacion de UI y logica de negocio
- Streams para Firebase real-time updates

---

## Security & Privacy

### Firebase Auth
- Email/Password authentication
- Social login (Google, Apple)
- 2FA (SMS TOTP) para usuarios Pro/Enterprise
- Password hashing automático por Firebase

### Firestore Security Rules


### GDPR Compliance
- Right to be forgotten: Funcion cloud para borrar todos los datos del usuario
- Data export: Funcion para descargar todos los datos
- Consent management: UI para gestionar permisos

---

## Gamification System

### XP & Levels


### Badges System


---

## Performance Optimization

### Firebase Performance
- **Firestore indexes**: Para queries complejas (compatibility, etc.)
- **Pagination**: Para listas largas (matches, content, quests)
- **Caching**: Flutter cache para datos frecuentes

### Flutter Performance
- **Code splitting**: Solo carga lo necesario por pantalla
- **Lazy loading**: Imagenes y assets bajo demanda
- **Hero animations**: Skeletons mientras cargan datos
- **Performance overlay**: Flutter DevTools para monitorear FPS

---

## Push Notifications (FCM)

### Eventos que notifican
- Nuevo match disponible
- Mision diaria lista
- Quest deadline approaching
- Alguien acepto tu match
- Webinar en 1 hora
- Nueva venta registrada
- Badge desbloqueado

---

## Monitoring & Analytics

### Firebase Analytics
- User funnels (onboarding completion rate)
- Feature usage (matches, quests published)
- Retention metrics (DAU, WAU, MAU)
- Monetization metrics (conversion rates, revenue)

### Crashlytics
- Crash reports
- ANR (Application Not Responding) reports

---

## Roadmap Tecnico (Short-term)

### Sprint 1-2 (4 semanas)
- Flutter project setup
- Firebase Auth implementation
- Onboarding screens (Espejo del Alma)
- Avatar creation and visualization

### Sprint 3-4 (4 semanas)
- Match algorithm implementation
- Firebase Realtime Database for chat
- Quest system basic
- PoppyAI integration (onboarding coach)

### Sprint 5-6 (4 semanas)
- Content creation screens
- Video script generation with PoppyAI
- Webinar funnel builder (quest sequence)
- Gamification engine (XP, levels, badges)

### Sprint 7-8 (4 semanas)
- Products listing and management
- Monetization dashboard
- Stripe integration (pagos)
- Email marketing integration (ActiveCampaign, ConvertKit)

---

## Costos Estimados (Mensuales)

| Servicio | Costo | Notas |
|----------|--------|--------|
| Firebase Spark Plan | /bin/bash | Hasta 125K reads/mes |
| Firebase Blaze Plan | 5-50 | Escalando a 500K+ reads |
| PoppyAI (ChatGPT) | 0-200 | Depende de uso |
| OpenAI Embeddings (opcional) | 0-50 | Si se implementa RAG |
| Flutter Build Runner | /bin/bash | Gratuito |
| Stripe | 9/mes | Procesamiento pagos extra |

---

