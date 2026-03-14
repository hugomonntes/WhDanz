const express = require('express');
const { body, validationResult } = require('express-validator');
const admin = require('firebase-admin');

const router = express.Router();

const verifyToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Token no proporcionado' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decodedToken = await req.admin.auth().verifyIdToken(idToken);
    req.userUid = decodedToken.uid;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Token inválido o expirado' });
  }
};

router.get('/profile', verifyToken, async (req, res) => {
  try {
    const userDoc = await req.db.collection('users').doc(req.userUid).get();
    
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({
      success: true,
      profile: userDoc.data()
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: error.message });
  }
});

router.put('/profile',
  verifyToken,
  body('displayName').optional().trim().notEmpty(),
  body('bio').optional().trim(),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { displayName, bio, photoURL } = req.body;

    try {
      const updateData = {
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      };

      if (displayName) {
        updateData.displayName = displayName;
        await req.admin.auth().updateUser(req.userUid, { displayName });
      }

      if (bio !== undefined) {
        updateData.bio = bio;
      }

      if (photoURL !== undefined) {
        updateData.photoURL = photoURL;
        await req.admin.auth().updateUser(req.userUid, { photoURL });
      }

      await req.db.collection('users').doc(req.userUid).update(updateData);

      const updatedDoc = await req.db.collection('users').doc(req.userUid).get();

      res.json({
        success: true,
        profile: updatedDoc.data()
      });
    } catch (error) {
      console.error('Update profile error:', error);
      res.status(500).json({ error: error.message });
    }
  }
);

router.get('/:uid', verifyToken, async (req, res) => {
  try {
    const userDoc = await req.db.collection('users').doc(req.params.uid).get();
    
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({
      success: true,
      user: userDoc.data()
    });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
