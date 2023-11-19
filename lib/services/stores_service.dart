import '../../classes/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Store>> fetchAllStores() async {
    final storesCollection = _firestore.collection('stores');
    final querySnapshot = await storesCollection.get();
    final storesData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final stores = storesData.map((data) => Store.fromJson(data)).toList();
    return stores;
  }

  Future<Store?> fetchStoreById(String storeId) async {
    final storesCollection = _firestore.collection('stores');
    final docSnapshot = await storesCollection.doc(storeId).get();
    if (!docSnapshot.exists) {
      return null;
    }
    final storeData = docSnapshot.data();
    final store = Store.fromJson(storeData!);
    return store;
  }

}
