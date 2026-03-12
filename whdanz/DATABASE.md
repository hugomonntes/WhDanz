# WhDanz - Base de Datos Configurada

## Colecciones de Firestore

### 1. `users` - Usuarios
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "displayName": "Juan Pérez",
  "photoURL": null,
  "bio": "Bailarín de salsa",
  "followersCount": 0,
  "followingCount": 0,
  "postsCount": 0,
  "createdAt": timestamp,
  "updatedAt": timestamp
}
```

### 2. `posts` - Publicaciones
```json
{
  "id": "post_id",
  "userId": "user_id",
  "userName": "Juan Pérez",
  "userPhotoURL": null,
  "videoURL": "https://...",
  "thumbnailURL": "https://...",
  "caption": "Practcando salsa",
  "poseScore": 85.5,
  "likesCount": 0,
  "commentsCount": 0,
  "createdAt": timestamp,
  "isLiked": false
}
```

### 3. `places` - Lugares (ya poblado con 3 lugares de ejemplo)
- Salsa Club Latina
- Academia de Baile Madrid
- Parque de la Danza

### 4. `practice_sessions` - Sesiones de práctica
```json
{
  "id": "session_id",
  "userId": "user_id",
  "poseId": "salsa_paso_basico",
  "poseName": "Salsa - Paso básico",
  "score": 85.0,
  "durationSeconds": 120,
  "createdAt": timestamp
}
```

### 5. `reference_poses` - Poses de referencia
```json
{
  "id": "salsa_paso_basico",
  "name": "Salsa - Paso básico",
  "style": "salsa",
  "difficulty": "principiante"
}
```

---

## Datos ya incluidos:
✅ 4 lugares en la colección `places`
✅ 6 poses de referencia en `reference_poses`

---

## Para agregar más datos:

1. Ve a https://console.firebase.google.com/project/whdanz/firestore
2. Click en "Iniciar colección"
3. Agrega los datos manualmente o importa JSON
