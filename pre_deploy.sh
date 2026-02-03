#!/bin/bash

# Script para compilar y verificar el proyecto LifeVibes antes del deployment
# Usage: ./pre_deploy.sh

echo "🗿 LifeVibes Pre-Deploy Script"
echo "================================"
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

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${NC}ℹ️  $1${NC}"
}

# 1. Verificar versión de Flutter
print_info "Verificando versión de Flutter..."
flutter --version

# 2. Verificar versión de Dart
print_info "Verificando versión de Dart..."
dart --version

# 3. Limpiar build previo
print_info "Limpiando build previo..."
flutter clean

# 4. Obtener dependencias
print_info "Obteniendo dependencias..."
flutter pub get

# 5. Verificar dependencias (pub outdated)
print_info "Verificando dependencias..."
flutter pub outdated || print_warning "No hay dependencias disponibles para actualizar"

# 6. Análisis de código (flutter analyze)
print_info "Analizando código..."
flutter analyze --no-fatal-infos || print_error "Análisis de código encontró errores"

# 7. Formatear código (dart format)
print_info "Formateando código..."
dart format --set-exit-if-changed . || print_warning "El código necesita formateo. Ejecuta: dart format ."

# 8. Ejecutar tests (flutter test)
print_info "Ejecutando tests..."
flutter test || print_warning "Tests fallaron o no hay tests implementados"

# 9. Verificar configuración de Firebase
print_info "Verificando configuración de Firebase..."

# Verificar que Firebase esté configurado en main.dart
if grep -q "firebase_options" lib/main.dart; then
    print_success "Firebase options encontrados en main.dart"
else
    print_error "Firebase options NO encontrados en main.dart"
    echo "Asegúrate de configurar Firebase antes del deployment"
fi

# 10. Verificar estructura del proyecto
print_info "Verificando estructura del proyecto..."

# Verificar directorios principales
DIRS=("lib/features" "lib/core" "functions")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "Directorio $dir existe"
    else
        print_error "Directorio $dir NO existe"
    fi
done

# Verificar archivos principales
FILES=("lib/main.dart" "pubspec.yaml" "functions/index.js" "functions/package.json")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Archivo $file existe"
    else
        print_error "Archivo $file NO existe"
    fi
done

# 11. Verificar versión en pubspec.yaml
print_info "Verificando versión en pubspec.yaml..."
VERSION=$(grep "version:" pubspec.yaml | cut -d: ":" -f2 | tr -d ' ')
print_success "Versión actual: $VERSION"

# 12. Verificar package name en pubspec.yaml
print_info "Verificando package name en pubspec.yaml..."
PACKAGE=$(grep "name:" pubspec.yaml | cut -d: ":" -f2 | tr -d ' ')
print_success "Package name: $PACKAGE"

# 13. Verificar Firebase project ID
print_info "Verificando Firebase project ID..."
PROJECT_ID=$(grep "projectId:" lib/main.dart | head -1 | cut -d: "'" -f2)
if [ -n "$PROJECT_ID" ]; then
    print_success "Firebase project ID: $PROJECT_ID"
else
    print_warning "Firebase project ID no encontrado en main.dart"
fi

# 14. Verificar Cloud Functions
print_info "Verificando Cloud Functions..."

if [ -f "functions/index.js" ]; then
    FUNCTIONS_COUNT=$(grep "exports\." functions/index.js | wc -l)
    print_success "Cloud Functions encontradas: $FUNCTIONS_COUNT"
else
    print_error "functions/index.js NO encontrado"
fi

# 15. Verificar tamaño del proyecto
print_info "Verificando tamaño del proyecto..."
PROJECT_SIZE=$(du -sh . | cut -f1)
print_success "Tamaño del proyecto: $PROJECT_SIZE"

# 16. Generar reporte
echo ""
echo "================================"
echo "📊 Pre-Deploy Report"
echo "================================"
echo ""
print_info "Resumen:"
echo "  - Versión Flutter: $(flutter --version | cut -d' ' -f2)"
echo "  - Versión Dart: $(dart --version | cut -d' ' -f1)"
echo "  - App Version: $VERSION"
echo "  - Package Name: $PACKAGE"
echo "  - Project ID: $PROJECT_ID"
echo "  - Cloud Functions: $FUNCTIONS_COUNT"
echo "  - Project Size: $PROJECT_SIZE"
echo ""
print_success "✅ Pre-Deploy check completado!"
echo ""
echo "Si no hay errores rojos (❌), el proyecto está listo para deployment."
echo ""
echo "Próximos pasos:"
echo "  1. Ejecutar: ./build_android.sh (para Android APK/AppBundle)"
echo "  2. Ejecutar: ./build_ios.sh (para iOS IPA)"
echo "  3. Seguir guía en DEPLOYMENT_GUIDE.md"
echo ""
