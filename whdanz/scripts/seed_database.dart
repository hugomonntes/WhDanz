import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  final firestore = FirebaseFirestore.instance;
  
  print('🌱 Starting database seed...');
  
  // Lugares de ejemplo
  final places = [
    {
      'id': 'place_1',
      'name': 'Salsa Club Latina',
      'address': 'Calle Gran Vía 25, Madrid',
      'description': 'El mejor lugar para bailar salsa en Madrid. Ambiente increíble y clases de salsa los jueves.',
      'type': 'discoteca',
      'latitude': 40.4203,
      'longitude': -3.7059,
      'rating': 4.5,
      'reviewsCount': 28,
      'addedBy': 'system',
      'createdAt': Timestamp.now(),
    },
    {
      'id': 'place_2',
      'name': 'Academia de Baile Madrid',
      'address': 'Plaza España 8, Madrid',
      'description': 'Academia de baile con clases de salsa, bachata, k-pop y más.',
      'type': 'academia',
      'latitude': 40.4237,
      'longitude': -3.7142,
      'rating': 4.8,
      'reviewsCount': 56,
      'addedBy': 'system',
      'createdAt': Timestamp.now(),
    },
    {
      'id': 'place_3',
      'name': 'Parque de la Danza',
      'address': 'Retiro Park, Madrid',
      'description': 'Espacio público perfecto para practicar baile urbano al aire libre.',
      'type': 'espacio_publico',
      'latitude': 40.4152,
      'longitude': -3.6834,
      'rating': 4.2,
      'reviewsCount': 15,
      'addedBy': 'system',
      'createdAt': Timestamp.now(),
    },
    {
      'id': 'place_4',
      'name': 'Underground Club',
      'address': 'Calle Alcalá 20, Madrid',
      'description': 'Club underground con música reggaeton y urbana. Las mejores fiestas.',
      'type': 'discoteca',
      'latitude': 40.4183,
      'longitude': -3.7001,
      'rating': 4.3,
      'reviewsCount': 42,
      'addedBy': 'system',
      'createdAt': Timestamp.now(),
    },
  ];
  
  for (final place in places) {
    await firestore.collection('places').doc(place['id'] as String).set(Map<String, dynamic>.from(place));
    print('✅ Added place: ${place['name']}');
  }
  
  // Poses de referencia (se guardan como assets, pero también，我们可以 crear un índice)
  final posesIndex = [
    {'id': 'salsa_paso_basico', 'name': 'Salsa - Paso básico', 'style': 'salsa', 'difficulty': 'principiante'},
    {'id': 'bachata_basic', 'name': 'Bachata - Basic Step', 'style': 'bachata', 'difficulty': 'principiante'},
    {'id': 'reggaeton_perreo', 'name': 'Reggaetón - Perreo', 'style': 'reggaeton', 'difficulty': 'intermedio'},
    {'id': 'kpop_basic', 'name': 'K-Pop - Coreografía', 'style': 'kpop', 'difficulty': 'avanzado'},
    {'id': 'hiphop_basic', 'name': 'Hip Hop - Basics', 'style': 'hiphop', 'difficulty': 'principiante'},
    {'id': 'salsa_turn', 'name': 'Salsa - Giro', 'style': 'salsa', 'difficulty': 'intermedio'},
  ];
  
  for (final pose in posesIndex) {
    await firestore.collection('reference_poses').doc(pose['id'] as String).set(Map<String, dynamic>.from(pose));
    print('✅ Added pose: ${pose['name']}');
  }
  
  print('🎉 Database seeded successfully!');
}
