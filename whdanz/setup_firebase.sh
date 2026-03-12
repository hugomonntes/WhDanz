#!/bin/bash

# WhDanz Firebase Setup Script
# Ejecuta este script después de hacer: firebase login

echo "🎵 Configurando WhDanz Firebase..."

# Crear proyecto si no existe
echo "📁 Verificando proyectos existentes..."
firebase projects:list

# Crear nuevo proyecto
echo "🎯 Creando proyecto WhDanz..."
firebase projects:create whdanz "WhDanz - Baile con IA"

# Seleccionar proyecto
firebase use whdanz

# Habilitar servicios
echo "🔧 Habilitando servicios de Firebase..."

# Firestore
firebase firestore:init --project whdanz

# Storage
firebase apps:create android whdanz-android --project whdanz --package-name com.danceai.whdanz

# Descargar google-services.json
echo "📥 Descargando google-services.json..."
firebase apps:sdkconfig android com.danceai.whdanz --project whdanz

echo "✅ Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Copia el google-services.json descargado a android/app/"
echo "2. Ejecuta: firebase deploy --only firestore:rules"
