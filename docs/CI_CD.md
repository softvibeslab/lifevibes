# CI/CD con GitHub Actions

Guía de uso del pipeline automatizado de build para LifeVibes.

---

## Cómo Funciona

El workflow `.github/workflows/build-android.yml` se ejecuta automáticamente cuando:

| Evento | Trigger | Resultado |
|--------|---------|-----------|
| Push a `main` | `git push origin main` | Build APK Release + Debug |
| Pull Request | Crear PR a `main` | Build APK para validar |
| Manual | Click en "Run workflow" | Build a demanda |
| Tag Release | `git tag v1.0.0` | Release con APK descargable |

---

## Workflow: Qué Hace

```
┌──────────────────────────────────────────────────────────────────┐
│                     GitHub Actions Runner                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Checkout Code          → Clona el repositorio               │
│  2. Setup Java 17          → Configura JDK                      │
│  3. Setup Flutter 3.27     → Instala Flutter SDK                │
│  4. Flutter Doctor         → Verifica instalación               │
│  5. Flutter Pub Get        → Descarga dependencias              │
│  6. Flutter Test           → Ejecuta tests (si existen)         │
│  7. Flutter Build APK      → Genera APK release                 │
│  8. Rename APK             → Nombra con versión+commit         │
│  9. Upload Artifact        → Sube APK a GitHub (30 días)        │
│ 10. Build Debug APK        → Genera APK debug                  │
│ 11. Upload Debug Artifact  → Sube debug APK (7 días)            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Cómo Obtener el APK

### Método 1: Desde GitHub UI (Más Común)

1. Ir al repositorio: `https://github.com/softvibeslab/lifevibes`
2. Clic en la pestaña **Actions**
3. Seleccionar el workflow más reciente (check verde = éxito)
4. Scrollear hasta **Artifacts**
5. Descargar `lifevibes-apk-release`

### Método 2: Desde una Release (Para versiones oficiales)

```bash
# Crear tag de versión
git tag v1.0.0
git push origin v1.0.0

# GitHub crea automáticamente una release con el APK adjunto
```

---

## Ejecución Manual

Para ejecutar el build sin hacer push:

1. GitHub → Repositorio → **Actions**
2. Seleccionar "Build Android APK"
3. Clic en "Run workflow"
4. Seleccionar rama `main`
5. Clic en "Run workflow"

---

## Nomenclatura del APK

El archivo generado tiene el formato:

```
lifevibes-{VERSION}+{BUILD}-{COMMIT_SHA}.apk
```

Ejemplo:
```
lifevibes-1.0.0+1-a3f2b8c.apk
```

---

## Tiempos de Retención

| Artefacto | Retención | Uso |
|-----------|-----------|-----|
| Release APK | 30 días | Producción |
| Debug APK | 7 días | Desarrollo |
| Release (tag) | Permanente | Versiones oficiales |

---

## Monitoreo de Builds

### Ver Logs en Tiempo Real

1. GitHub → Actions
2. Seleccionar el workflow run
3. Clic en el job "Build APK"
4. Expandir cada paso para ver logs

### Status Badge

Agrega este badge a tu README.md:

```markdown
[![Build Android](https://github.com/softvibeslab/lifevibes/actions/workflows/build-android.yml/badge.svg)](https://github.com/softvibeslab/lifevibes/actions/workflows/build-android.yml)
```

---

## Futuro: Firebase App Distribution

Para cuando estés listo, estos son los cambios necesarios:

### 1. Crear Service Account en Firebase

```bash
# Ir a Firebase Console → Project Settings → Service Accounts
# Descargar JSON con credenciales
```

### 2. Agregar Secret a GitHub

1. GitHub → Repo → Settings → Secrets
2. New repository secret:
   - Name: `FIREBASE_SERVICECredentials`
   - Value: Contenido del JSON

### 3. Agregar step al workflow

```yaml
- name: Upload to Firebase App Distribution
  uses: wzieba/Firebase-Distribution-Github-Action@v1
  with:
    appId: ${{ secrets.FIREBASE_APP_ID }}
    serviceCredentialsFile: ${{ secrets.FIREBASE_SERVICE_CREDENTIALS }}
    groups: testers
    file: build/app/outputs/flutter-apk/app-release.apk
```

### Beneficios de Firebase App Distribution

- Testers reciben notificación por email
- Instalación con un clic desde el móvil
- Versionado automático
- Feedback integrado
- Soporte para iOS y Android

---

## Troubleshooting

### Build falla con "Gradle sync failed"

El workflow usa una versión específica de Flutter. Si hay problemas con dependencias:

```yaml
# En .github/workflows/build-android.yml
flutter-version: '3.27.0'  # Ajustar si es necesario
```

### Tests fallan y bloquean el build

El workflow continúa aunque los tests fallen (gracias al `|| echo "..."`). Para hacerlo estricto:

```yaml
- name: Run tests
  run: flutter test  # Sin el || echo
```

### APK no se puede instalar

Verifica que la versión mínima de Android sea compatible:

```gradle
// En android/app/build.gradle
minSdk = 21  // Android 5.0+
```

---

## Costos

| Recurso | Límite Gratis | Paid |
|---------|---------------|------|
| GitHub Actions (minutes/month) | 2000 | $0.008/min |
| Artifact storage | 500 MB | $0.25/GB/mes |
| Firebase App Distribution | 100 testers | $0/plan Spark |

Para este proyecto, el plan gratuito es más que suficiente.
