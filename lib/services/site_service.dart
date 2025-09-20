import '../models/site.dart';
import '../models/site_stats.dart';
import 'api_service.dart';

class SiteService {
  final ApiService api;
  SiteService(this.api);

  Future<List<Site>> listSites() async {
    final res = await api.get('/api/sites/');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(Site.fromJson).toList();
  }

  Future<Site> createSite(
      {required String name,
      required String url,
      required SiteType type,
      String? clientName}) async {
    final res = await api.post('/api/sites/', data: {
      'name': name,
      'url': url,
      'type': type.name,
      'client_name': clientName,
    });
    return Site.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Site> updateSite(int id,
      {String? name, String? url, SiteType? type, String? clientName}) async {
    final res = await api.put('/api/sites/$id/', data: {
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (type != null) 'type': type.name,
      if (clientName != null) 'client_name': clientName,
    });
    return Site.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteSite(int id) async {
    await api.delete('/api/sites/$id/');
  }

  Future<SiteStatsResponse> stats(int id, {String range = 'weekly'}) async {
    final res = await api.get('/api/sites/$id/stats/', query: {'range': range});
    return SiteStatsResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
