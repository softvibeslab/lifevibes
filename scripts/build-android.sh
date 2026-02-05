#!/bin/bash
# LifeVibes Android Build Script
# Uso: ./scripts/build-android.sh [debug|release]

set -e

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_step() {
    echo -e "${GREEN}➜${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✖${NC} $1"
}

# Determinar tipo de build
BUILD_TYPE=${1:-debug}
APK_OUTPUT="build/app/outputs/flutter-apk"

echo "🚀 LifeVibes Android Build Script"
echo "==================================="
echo ""

# Verificar Flutter instalado
print_step "Verificando instalación de Flutter..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter no está instalado o no está en PATH"
    echo "Instala Flutter desde: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Verificar dispositivos conectados (solo para debug)
if [ "$BUILD_TYPE" = "debug" ]; then
    print_step "Verificando dispositivos conectados..."
    DEVICES=$(flutter devices | grep -c "android" || true)
    if [ "$DEVICES" -eq 0 ]; then
        print_warning "No se detectaron dispositivos Android conectados"
        echo "Conecta un dispositivo o inicia un emulador para ejecutar la app"
    else
        echo "Dispositivos detectados:"
        flutter devices
    fi
fi

# Limpiar build anterior
print_step "Limpiando builds anteriores..."
flutter clean

# Obtener dependencias
print_step "Obteniendo dependencias..."
flutter pub get

# Ejecutar tests (opcional)
print_step "Ejecutando tests..."
flutter test || print_warning "Algunos tests fallaron o no existen"

# Build según tipo
if [ "$BUILD_TYPE" = "release" ]; then
    print_step "Generando APK Release..."
    flutter build apk --release

    echo ""
    echo "✅ Build Release completado!"
    echo "📦 APK ubicado en: $APK_OUTPUT/app-release.apk"
    echo ""
    echo "Para instalar en un dispositivo:"
    echo "  adb install $APK_OUTPUT/app-release.apk"

elif [ "$BUILD_TYPE" = "debug" ]; then
    print_step "Generando APK Debug..."
    flutter build apk --debug

    echo ""
    echo "✅ Build Debug completado!"
    echo "📦 APK ubicado en: $APK_OUTPUT/app-debug.apk"
    echo ""
    echo "Para instalar en un dispositivo:"
    echo "  adb install $APK_OUTPUT/app-debug.apk"
    echo ""
    echo "Para ejecutar directamente:"
    echo "  flutter run"

elif [ "$BUILD_TYPE" = "bundle" ]; then
    print_step "Generando App Bundle (para Google Play)..."
    flutter build appbundle --release

    echo ""
    echo "✅ App Bundle completado!"
    echo "📦 AAB ubicado en: build/app/outputs/bundle/release/app-release.aab"

else
    print_error "Tipo de build no válido: $BUILD_TYPE"
    echo "Uso: $0 [debug|release|bundle]"
    exit 1
fi

echo ""
echo "==================================="
echo "🎉 Build finalizado!"
