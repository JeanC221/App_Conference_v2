import 'package:get/get.dart';
import '../../../data/services/web_service.dart';
import '../../../domain/entities/track.dart';

class TrackRemoteDatasource {
  final HttpService _httpService = Get.find<HttpService>();
  final String _endpoint = '/tracks';

  Future<List<Track>> getTracks() async {
    try {
      final response = await _httpService.get(_endpoint);
      return (response.data as List)
          .map((json) => Track.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load tracks: $e');
    }
  }

  Future<Track> getTrackById(String id) async {
    try {
      final response = await _httpService.get('$_endpoint/$id');
      return Track.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load track: $e');
    }
  }
}