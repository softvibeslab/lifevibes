# LifeVibes Android Build Guide

Guía completa para compilar y generar el APK de LifeVibes.

---

## Requisitos Previos

### 1. Instalar Flutter SDK

```bash
# Descargar Flutter desde https://docs.flutter.dev/get-started/install
# O usar snap en Linux:
sudo snap install flutter --classic

# Verificar instalación
flutter doctor
```

### 2. Instalar Android Studio

1. Descargar Android Studio desde https://developer.android.com/studio
2. Instalar Android SDK (API 33+ recomendado)
3. Instalar Android SDK Build-Tools
4. Configurar emulador o conectar dispositivo físico

### 3. Aceptar Licencias Android

```bash
flutter doctor --android-licenses
```

---

## Opción 1: Build desde Android Studio (Recomendado)

### Pasos:

1. **Abrir el Proyecto**
   ```
   File → Open → seleccionar /ruta/a/lifevibes
   ```

2. **Esperar Indexado**
   - Android Studio indexará el proyecto
   - Gradle sincronizará dependencias

3. **Ejecutar en Dispositivo/Emulador**
   - Presionar el botón "Run" (triángulo verde)
   - O presionar `Shift + F10`

4. **Generar APK Release**
   ```
   Build → Flutter → Build APK
   ```

5. **Ubicación del APK**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

---

## Opción 2: Build desde Línea de Comandos

### Paso 1: Navegar al proyecto

```bash
cd /ruta/a/lifevibes
```

### Paso 2: Obtener dependencias

```bash
flutter pub get
```

### Paso 3: Verificar dispositivos conectados

```bash
flutter devices
```

### Paso 4: Build Debug APK

```bash
flutter build apk --debug
```

### Paso 5: Build Release APK

```bash
flutter build apk --release
```

### Ubicación del APK generado

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Opción 3: Build App Bundle (para Google Play)

```bash
flutter build appbundle --release
```

Ubicación:
```
build/app/outputs/bundle/release/app-release.aab
```

---

## Crear Keystore para Release (Producción)

### 1. Generar Keystore

```bash
keytool -genkey -v -keystore ~/lifevibes-release.keystore -alias lifevibes -keyalg RSA -keysize 2048 -validity 10000
```

### 2. Crear archivo `android/key.properties`

```properties
storePassword=tu_contraseña_almacenamiento
keyPassword=tu_contraseña_llave
keyAlias=lifevibes
storeFile=/ruta/a/lifevibes-release.keystore
```

### 3. Agregar `key.properties` a `.gitignore`

```bash
echo "android/key.properties" >> .gitignore
```

### 4. Actualizar `android/app/build.gradle`

Descomentar la sección de release signing configurada.

---

## Instalar el APK en un Dispositivo

### Via USB (ADB)

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via Wireless

```bash
# Conectar dispositivo y computadora a misma red
adb tcpip 5555
adb connect <IP_DEL_DISPOSITIVO>:5555
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Solución de Problemas

### Error: "Flutter SDK not found"

En Android Studio: `File → Settings → Languages & Frameworks → Flutter`
Configurar la ruta del SDK de Flutter.

### Error: "Gradle sync failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error: "No connected devices"

- Habilitar "Developer Options" en el dispositivo
- Habilitar "USB Debugging"
- Aceptar prompt de autorización en el dispositivo

---

## Configuración del Proyecto

| Propiedad | Valor |
|-----------|-------|
| Package Name | `com.softvibes.lifevibes` |
| Min SDK | 21 (Android 5.0) |
| Target SDK | 34 (Android 14) |
| Compile SDK | 34 |
| Versión | 1.0.0+1 |

---

## Permisos Configurados

- `CAMERA` - Para seleccionar imágenes de cámara
- `READ_EXTERNAL_STORAGE` - Para imágenes (SDK ≤ 32)
- `READ_MEDIA_IMAGES` - Para imágenes (SDK ≥ 33)
- `READ_MEDIA_VIDEO` - Para videos (SDK ≥ 33)
- `INTERNET` - Conexión Firebase
- `WAKE_LOCK` - Notificaciones Firebase
- `VIBRATE` - Feedback háptico
- `POST_NOTIFICATIONS` - Notificaciones Android 13+

---

## Próximos Pasos

1. Generar APK de prueba
2. Instalar en dispositivo físico
3. Testing funcional completo
4. Crear keystore de producción
5. Generar release signed
6. Subir a Google Play Console
