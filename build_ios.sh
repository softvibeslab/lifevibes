#!/bin/bash

# Script para build iOS IPA para LifeVibes
# Usage: ./build_ios.sh [debug|release]

BUILD_TYPE=${1:-release}

echo "🗿 LifeVibes iOS Build Script"
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

# Verificar que estamos en macOS o Linux
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Error: Este script requiere macOS para compilar iOS${NC}"
    echo "Para build iOS, usa Xcode en macOS"
    exit 1
fi

# 1. Verificar que Xcode esté instalado
print_info "Verificando Xcode installation..."
if command -v xcodebuild &> /dev/null; then
    print_success "Xcode encontrado: $(xcodebuild -version | head -1)"
else
    echo -e "${RED}❌ Error: Xcode NO encontrado${NC}"
    echo "Por favor instala Xcode desde App Store"
    exit 1
fi

# 2. Verificar CocoaPods
print_info "Verificando CocoaPods..."
if command -v pod &> /dev/null; then
    print_success "CocoaPods encontrado"
else
    echo -e "${YELLOW}⚠️  Warning: CocoaPods NO encontrado${NC}"
    echo "Instalando CocoaPods..."
    sudo gem install cocoapods
fi

# 3. Instalar dependencias de iOS (CocoaPods)
print_info "Instalando dependencias de iOS..."
cd ios
pod install
cd ..

# 4. Verificar Flutter doctor
print_info "Verificando Flutter doctor..."
flutter doctor -v

# 5. Limpiar build previo
print_info "Limpiando build previo..."
flutter clean

# 6. Obtener dependencias
print_info "Obteniendo dependencias..."
flutter pub get

# 7. Build iOS
print_info "Building iOS IPA..."
flutter build ios \
  --${BUILD_TYPE} \
  --dart-define=FLUTTER_WEB_CANVASK_SKIA=true \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --no-codesign

# Verificar si el build fue exitoso
if [ $? -eq 0 ]; then
    print_success "✅ iOS build exitoso!"
else
    echo -e "${RED}❌ Error: iOS build falló${NC}"
    exit 1
fi

# 8. Verificar si el workspace fue generado
WORKSPACE_PATH="ios/Runner.xcworkspace"
if [ -f "$WORKSPACE_PATH" ]; then
    print_success "Workspace generado: $WORKSPACE_PATH"
else
    echo -e "${YELLOW}⚠️  Warning: Workspace NO generado${NC}"
    echo "El build puede no haber completado correctamente"
fi

# 9. Generar IPA usando Xcode (opcional)
print_info "¿Quieres generar el archivo IPA usando Xcode? (y/n)"
read -r -p "> " GENERATE_IPA

if [[ "$GENERATE_IPA" == "y" || "$GENERATE_IPA" == "Y" ]]; then
    print_info "Abriendo Xcode para generar IPA..."
    open "$WORKSPACE_PATH"
    
    print_info ""
    print_info "Instrucciones para generar IPA en Xcode:"
    echo "  1. En Xcode, selecciona 'Runner' en el navegador del proyecto"
    echo "  2. Selecciona 'Any iOS Device (arm64)' como target"
    echo "  3. Product > Archive"
    echo "  4. Selecciona tu Team de desarrollo"
    echo "  5. Especifica 'DISTRIBUTION: App Store Connect / Ad Hoc'"
    echo "  6. Haz clic en 'Archive'"
    echo "  7. El archivo IPA se guardará en ~/Library/Developer/Xcode/Archives/"
else
    print_info "Para generar el IPA, usa Xcode:"
    echo "  1. Abre: $WORKSPACE_PATH"
    echo "  2. Product > Archive"
    echo "  3. Sigue las instrucciones de Xcode"
fi

# 10. Generar reporte
echo ""
echo "================================"
echo "📦 iOS Build Report"
echo "================================"
echo ""
print_info "Workspace: $WORKSPACE_PATH"
print_info "Build Type: $BUILD_TYPE"
echo ""
print_success "✅ iOS build completado!"
echo ""
echo "Próximos pasos:"
echo "  - Usa Xcode para generar el archivo IPA"
echo "  - Sube IPA a App Store Connect"
echo ""
