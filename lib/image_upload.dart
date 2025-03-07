import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage({required String imagePath, required List<String> folders, required String fileName}) async{
  String downloadUrl;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Reference reference = _storage.ref();
  for(String f in folders){
    reference = reference.child(f);
  }
  reference = reference.child(fileName);

  final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path':imagePath}
  );

  try{
    if(kIsWeb){
      await reference.putData(await XFile(imagePath).readAsBytes(), metadata);
    }
    else{
      await reference.putFile(File(imagePath), metadata);
    }
    downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }on FirebaseException catch(e){
    print("Lối upload ảnh lên firebase ${e.toString()}");
    return Future.error("Lỗi upload File");
  }


}
Future<void> deleteImage({required List<String> folders, required String fileName}){
  FirebaseStorage _storage = FirebaseStorage.instance;
  Reference reference = _storage.ref();
  for(String f in folders){
    reference = reference.child(f);
  }
  reference = reference.child(fileName);
  return reference.delete();
}