import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/site.dart';
import '../models/site_stats.dart';
import '../services/site_service.dart';

class SiteProvider extends ChangeNotifier {
  SiteService? _service;
  bool _loading = false;
  List<Site> _sites = [];
  SiteStatsResponse? _currentStats;
  String? _error;
  Box? _sitesBox;
  Box? _statsBox;
  bool _initialized = false;

  bool get loading => _loading;
  List<Site> get sites => _sites;
  SiteStatsResponse? get currentStats => _currentStats;
  String? get error => _error;
  bool get initialized => _initialized;

  void attachService(SiteService service) {
    _service = service;
  }

  void attachCache({required Box sitesBox, required Box statsBox}) {
    _sitesBox = sitesBox;
    _statsBox = statsBox;
  }

  Future<void> loadFromCache() async {
    final raw = _sitesBox?.get('list');
    if (raw is List) {
      _sites = raw
          .whereType<Map>()
          .map((e) => Site.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      notifyListeners();
    }
    _initialized = true;
  }

  Future<void> fetchSites() async {
    if (_service == null) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _sites = await _service!.listSites();
      await _sitesBox?.put('list', _sites.map((s) => s.toJson()).toList());
    } catch (e) {
      _error = 'Failed to load sites';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadStats(int siteId) async {
    if (_service == null) return;
    try {
      _currentStats = await _service!.stats(siteId);
      await _statsBox?.put('stats_$siteId', _currentStats!.toJson());
      notifyListeners();
    } catch (_) {
      final cached = _statsBox?.get('stats_$siteId');
      if (cached is Map) {
        _currentStats =
            SiteStatsResponse.fromJson(cached.cast<String, dynamic>());
        notifyListeners();
      }
    }
  }

  Future<Site?> createSite(
      {required String name,
      required String url,
      required SiteType type,
      String? clientName}) async {
    if (_service == null) return null;
    try {
      final site = await _service!
          .createSite(name: name, url: url, type: type, clientName: clientName);
      _sites = [..._sites, site];
      await _sitesBox?.put('list', _sites.map((s) => s.toJson()).toList());
      notifyListeners();
      return site;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateSite(int id,
      {String? name, String? url, SiteType? type, String? clientName}) async {
    if (_service == null) return false;
    try {
      final site = await _service!.updateSite(id,
          name: name, url: url, type: type, clientName: clientName);
      _sites = _sites.map((s) => s.id == id ? site : s).toList();
      await _sitesBox?.put('list', _sites.map((s) => s.toJson()).toList());
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteSite(int id) async {
    if (_service == null) return false;
    try {
      await _service!.deleteSite(id);
      _sites = _sites.where((s) => s.id != id).toList();
      await _sitesBox?.put('list', _sites.map((s) => s.toJson()).toList());
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
