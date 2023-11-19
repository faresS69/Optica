import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/store.dart';
import '../../services/stores_service.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeId;

  const StoreDetailScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final StoreService _storeService = StoreService();

  Store? _store;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStore();
  }

  Future<void> _fetchStore() async {
    setState(() {
      _isLoading = true;
    });
    final store = await _storeService.fetchStoreById(widget.storeId);
    setState(() {
      _store = store;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_store?.name ?? ''),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(_store!.images[0], height: 200),
              const SizedBox(height: 16.0),
              Text(_store!.name, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8.0),
              Text(_store!.description),
              const SizedBox(height: 8.0),
              Text(_store!.address),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final phoneUrl = 'tel:${_store!.ownerId}';
                      if (await canLaunch(phoneUrl)) {
                        await launch(phoneUrl);
                      }
                    },
                    icon: const Icon(Icons.call),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Show command screen
                      Navigator.of(context).pushNamed('/command', arguments: _store!.id);
                    },
                    child: const Text('Send Command'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
