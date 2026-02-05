# Setup Codemagic + Firebase App Distribution

Guía paso a paso para configurar CI/CD con Codemagic y distribución automática via Firebase.

---

## Resumen del Flujo

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│ Push Code   │ ───► │ Codemagic   │ ───► │ Build APK   │ ───► │ Firebase    │
│ (GitHub)    │      │ (CI/CD)     │      │ (Automatic) │      │ Distribution│
└─────────────┘      └─────────────┘      └─────────────┘      └─────────────┘
                                                                           │
                                                                           ▼
                                                                  ┌─────────────┐
                                                                  │ Testers     │
                                                                  │ Notificados │
                                                                  └─────────────┘
```

---

## Paso 1: Crear Cuenta en Codemagic

1. Ir a: **https://codemagic.io**
2. Clic en **"Start building for free"**
3. Registrarse con **GitHub** (recomendado)
4. Autorizar Codemagic para acceder a `softvibeslab/lifevibes`

---

## Paso 2: Configurar el Proyecto en Codemagic

1. Dashboard de Codemagic → **"Add new application"**
2. Seleccionar **GitHub**
3. Seleccionar repositorio: `softvibeslab/lifevibes`
4. Branch: `main`
5. Build type: **Flutter application**
6. Clic en **"Create application"**

---

## Paso 3: Obtener Credenciales de Firebase

### 3.1 Crear Service Account

1. Ir a: **Firebase Console** → Project Settings → **Service accounts**
2. Clic en **"Generate new private key"**
3. Descargar el archivo JSON (guárdalo, no se puede recuperar)
4. Renombrar el archivo como `firebase-service-account.json`

### 3.2 Obtener App ID de Firebase

1. Ir a: **Firebase Console** → App Distribution
2. Seleccionar tu app Android
3. Copiar el **App ID** (formato: `1:123456789:android:abc123`)

---

## Paso 4: Configurar Variables en Codemagic

1. En el proyecto de Codemagic → **Settings** → **Environment variables**

2. Agregar las siguientes variables:

| Variable Name | Value | Protected |
|---------------|-------|-----------|
| `FCM_SERVICE_ACCOUNT` | Contenido completo del JSON de Firebase | ✅ Yes |
| `FIREBASE_APP_ID_ANDROID` | El App ID copiado del paso 3.2 | ✅ Yes |
| `TESTER_GROUPS` | `testers,beta-users` | ❌ No |

### Nota Importante

Para `FCM_SERVICE_ACCOUNT`:
- Abrir el JSON descargado
- Copiar **todo** el contenido
- Pegarlo en el valor de la variable
- El JSON debe estar en formato de una sola línea

---

## Paso 5: Agregar Testers en Firebase

1. Ir a: **Firebase Console** → App Distribution → **Testers & Groups**
2. Crear grupos:
   - `testers` - Para equipo interno
   - `beta-users` - Para beta testers externos
3. Agregar emails de los testers

---

## Paso 6: Ejecutar el Primer Build

1. Codemagic → Tu proyecto → **"Start new build"**
2. Seleccionar workflow: `android-workflow`
3. Clic en **"Start new build"**
4. Esperar a que termine (≈5-10 minutos primer build, 3-5 siguientes)

---

## Paso 7: Verificar en Firebase

1. Ir a: **Firebase Console** → App Distribution
2. Verás la nueva version del APK publicada
3. Los testers recibirán un email con enlace de descarga

---

## Cómo Recibir el APK (Como Tester)

### Opción 1: Email de Firebase

1. Recibirás email: "New version of LifeVibes available"
2. Clic en **"Download"** o **"Install"**
3. Abrir en dispositivo Android
4. Instalar APK

### Opción 2: App de Firebase App Distribution

1. Instalar "App Tester" de Google Play
2. Iniciar sesión con el email de tester
3. Ver todas las versiones disponibles
4. Instalar con un clic

---

## Workflows Disponibles

| Workflow | Trigger | Resultado |
|----------|---------|-----------|
| `android-workflow` | Push a main | APK Release → Firebase Distribution |
| `debug-workflow` | Manual desde UI | APK Debug → Descarga directa |

---

## Costos y Límites

| Servicio | Plan Gratis | Paid |
|----------|-------------|------|
| Codemagic | 500 builds/mes | Desde $29/mes |
| Firebase App Distribution | 100 testers | $0 (plan Spark) |
| Almacenamiento en Firebase | 1GB | Hasta 5GB gratis |

---

## Triggers Automáticos

El build se ejecuta automáticamente cuando:

- Haces push a la rama `main`
- Creas un pull request
- Ejecutas manualmente desde Codemagic UI

---

## Troubleshooting

### Error: "Firebase service account not found"

- Verifica que `FCM_SERVICE_ACCOUNT` esté configurada en Codemagic
- El JSON debe ser una sola línea (sin saltos de línea)

### Error: "App not found in Firebase"

- Verifica que `FIREBASE_APP_ID_ANDROID` sea correcto
- El ID debe coincidir con el proyecto de Firebase

### Build falla en "flutter build apk"

- Verifica que la versión de Flutter en `codemagic.yaml` coincida
- Revisar logs en Codemagic para ver el error específico

---

## Comandos Útiles

### Ver logs de build en tiempo real

```bash
# Desde Codemagic CLI (opcional)
codemagicctl build logs --build-id <BUILD_ID>
```

### Descargar artefactos manualmente

1. Codemagic → Build completado
2. Sección "Artifacts"
3. Descargar APK directamente

---

## Próximos Pasos

- [ ] Crear cuenta en Codemagic
- [ ] Generar service account de Firebase
- [ ] Configurar variables en Codemagic
- [ ] Ejecutar primer build
- [ ] Agregar testers en Firebase
- [ ] Probar instalación en dispositivo

---

## Contacto

Si tienes problemas:
- Documentación Codemagic: https://docs.codemagic.io
- Documentación Firebase App Distribution: https://firebase.google.com/docs/app-distribution
