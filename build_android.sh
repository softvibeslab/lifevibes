#!/bin/bash

# Script para build Android APK y App Bundle para LifeVibes
# Usage: ./build_android.sh [debug|release]

BUILD_TYPE=${1:-release}

echo "🗿 LifeVibes Android Build Script"
echo "================================"
echo "Build Type: $BUILD_TYPE"
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function para imprimir mensajes
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${NC}ℹ️  $1${NC}"
}

# 1. Verificar Flutter doctor
print_info "Verificando Flutter doctor..."
flutter doctor -v

# 2. Limpiar build previo
print_info "Limpiando build previo..."
flutter clean

# 3. Obtener dependencias
print_info "Obteniendo dependencias..."
flutter pub get

# 4. Build APK
print_info "Building Android APK..."
flutter build apk \
  --${BUILD_TYPE} \
  --dart-define=FLUTTER_WEB_CANVASK_SKIA=true \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --no-tree-shake-icons

# Verificar si el build fue exitoso
if [ $? -eq 0 ]; then
    print_success "✅ Android APK build exitoso!"
    
    # Mostrar ubicación del APK
    APK_PATH="build/app/outputs/flutter-apk/app-${BUILD_TYPE}.apk"
    if [ -f "$APK_PATH" ]; then
        print_info "APK generado en: $APK_PATH"
        
        # Mostrar tamaño del APK
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        print_info "Tamaño del APK: $APK_SIZE"
    fi
else
    echo -e "${RED}❌ Error: Android APK build falló${NC}"
    exit 1
fi

# 5. Build App Bundle (solo para release)
if [ "$BUILD_TYPE" = "release" ]; then
    print_info "Building Android App Bundle (AAB)..."
    flutter build appbundle \
      --${BUILD_TYPE} \
      --dart-define=FLUTTER_WEB_CANVASK_SKIA=true \
      --dart-define=FLUTTER_WEB_USE_SKIA=true \
      --no-tree-shake-icons \
      --target-platform android-arm64
    
    # Verificar si el build fue exitoso
    if [ $? -eq 0 ]; then
        print_success "✅ Android App Bundle build exitoso!"
        
        # Mostrar ubicación del AAB
        AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
        if [ -f "$AAB_PATH" ]; then
            print_info "AAB generado en: $AAB_PATH"
            
            # Mostrar tamaño del AAB
            AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
            print_info "Tamaño del AAB: $AAB_SIZE"
        fi
    else
        echo -e "${RED}❌ Error: Android App Bundle build falló${NC}"
        exit 1
    fi
fi

# 6. Generar hashes SHA256
print_info "Generando hashes SHA256..."

if [ -f "$APK_PATH" ]; then
    APK_SHA=$(sha256sum "$APK_PATH" | cut -d' ' -f1)
    print_info "APK SHA256: $APK_SHA"
fi

if [ -f "$AAB_PATH" ]; then
    AAB_SHA=$(sha256sum "$AAB_PATH" | cut -d' ' -f1)
    print_info "AAB SHA256: $AAB_SHA"
fi

# 7. Generar reporte
echo ""
echo "================================"
echo "📦 Android Build Report"
echo "================================"
echo ""
print_info "Artefacts generados:"
if [ -f "$APK_PATH" ]; then
    echo "  - APK: $APK_PATH"
    echo "    - Tamaño: $APK_SIZE"
    echo "    - SHA256: $APK_SHA"
fi
if [ -f "$AAB_PATH" ]; then
    echo "  - App Bundle: $AAB_PATH"
    echo "    - Tamaño: $AAB_SIZE"
    echo "    - SHA256: $AAB_SHA"
fi
echo ""
print_success "✅ Android build completado!"
echo ""
echo "Próximos pasos:"
echo "  - Instalar APK en dispositivo para testing"
echo "  - Subir AAB a Google Play Console"
echo ""
