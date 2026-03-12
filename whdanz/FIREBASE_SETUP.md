🎵 **WhDanz - Configuración de Firebase**

El script automático tuvo problemas. Por favor, configura Firebase manualmente:

---

### **Paso 1: Crear proyecto en Firebase Console**

1. Ve a: https://console.firebase.google.com/
2. Click en **"Añadir proyecto"**
3. Nombre del proyecto: `whdanz`
4. Desactiva Google Analytics (opcional)
5. Click **"Crear proyecto"** (espera ~1 minuto)

---

### **Paso 2: Agregar app Android**

1. En el proyecto, click en el ícono de Android
2. Package name: `com.danceai.whdanz`
3. Nickname (opcional): `WhDanz`
4. Click **"Registrar app"**

---

### **Paso 3: Descargar google-services.json**

1. Descarga el archivo `google-services.json`
2. Copia a: `whdanz/android/app/google-services.json`

---

### **Paso 4: Crear Firestore**

1. En Firebase Console → **Firestore Database**
2. Click **"Crear base de datos"**
3. Ubicación: us-central1 (o la más cercana)
4. Modo de producción: Start in test mode
5. Click **"Crear"**

---

### **Paso 5: Habilitar Auth**

1. Firebase Console → **Authentication**
2. Click **"Empezar"**
3. En "Proveedores", habilita **"Correo electrónico/contraseña"**
4. Activa "Correo electrónico/contraseña" 
5. Click **"Guardar"**

---

### **Credenciales de ejemplo** (para desarrollo)

CuandoTermines, descarga el json y reemplázalo en `android/app/google-services.json`

---

¿Necesitas ayuda con algún paso?
