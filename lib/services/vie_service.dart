import 'package:dio/dio.dart';
import '../models/vie_offer.dart';
import '../models/filters.dart';

class VieService {
  final Dio _dio;
  static const String baseUrl = 'https://civiweb-api-prd.azurewebsites.net/api';

  VieService() : _dio = Dio() {
    _dio.options.headers = {
      'accept': '*/*',
      'accept-language': 'en-US,en;q=0.9,fr-FR;q=0.8,fr;q=0.7',
      'content-type': 'application/json',
      'cache-control': 'no-cache',
      'pragma': 'no-cache',
      'sec-ch-ua': '"Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"macOS"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'cross-site',
    };
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<VieOffer>> searchOffers({
    int limit = 10,
    int skip = 0,
    String query = '',
    List<String> specializationsIds = const [],
    List<String> countriesIds = const [],
    List<String> sectorsIds = const [],
    List<int> durations = const [],
    List<int> studyLevelIds = const [],
    List<int> missionTypeIds = const [],
    List<int> entrepriseTypeIds = const [],
    List<String> geographicZoneIds = const [],
  }) async {
    try {
      final requestData = {
        'limit': limit,
        'skip': skip,
        'query': query,
        'activitySectorId': sectorsIds,
        'missionsTypesIds': missionTypeIds,
        'missionsDurations': durations,
        'gerographicZones': geographicZoneIds,
        'countriesIds': countriesIds,
        'studiesLevelId': studyLevelIds,
        'companiesSizes': entrepriseTypeIds,
        'specializationsIds': specializationsIds,
        'entreprisesIds': [0],
        'missionStartDate': null,
      };

      print('Sending request with data: $requestData');

      final response = await _dio.post(
        '$baseUrl/Offers/search',
        data: requestData,
      );

      final List<dynamic> results = response.data['result'];
      return results.map((json) => VieOffer.fromJson(json)).toList();
    } catch (e) {
      print('Error details: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Response headers: ${e.response?.headers}');
        print('Request data: ${e.requestOptions.data}');
      }
      throw Exception('Erreur lors de la recherche des offres VIE: $e');
    }
  }

  Future<VieOffer> getOfferDetails(int offerId) async {
    try {
      final response = await _dio.get('$baseUrl/Offers/details/$offerId');
      return VieOffer.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des détails de l\'offre: $e');
    }
  }

  Future<List<FilterOption>> getCountriesByZone(String zoneId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/Offers/repository/geographic-zones/countries',
        data: [int.parse(zoneId)],
      );

      return (response.data as List)
          .map((country) => FilterOption(
                id: country['countryId'].toString(),
                label: country['countryName'],
              ))
          .toList();
    } catch (e) {
      print('Error fetching countries: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
      }
      throw Exception('Erreur lors de la récupération des pays: $e');
    }
  }

  Future<VieFilters> getFilters() async {
    try {
      final filtersResponse = await _dio.get('$baseUrl/Offers/repository/search/dataset');
      final filtersData = filtersResponse.data;

      final geoZonesResponse =
          await _dio.get('$baseUrl/Offers/repository/geographic-zones', queryParameters: {'page': 1});
      final geoZonesData = geoZonesResponse.data;

      return VieFilters(
        studyLevels: (filtersData['studyLevels'] as List)
            .map((level) => FilterOption(
                  id: level['studyLevelId'].toString(),
                  label: level['studyLevelName'].toString().trim(),
                ))
            .toList(),
        missionTypes: (filtersData['missionTypes'] as List)
            .map((type) => FilterOption(
                  id: type['missionTypeId'].toString(),
                  label: type['missionTypeLabel'],
                ))
            .toList(),
        entrepriseTypes: (filtersData['entrepriseTypes'] as List)
            .map((type) => FilterOption(
                  id: type['entrepriseTypeId'].toString(),
                  label: type['typeEntreprise'],
                ))
            .toList(),
        sectors: (filtersData['activitySectors'] as List)
            .map((sector) => FilterOption(
                  id: sector['sectorId'].toString(),
                  label: sector['label'],
                ))
            .toList(),
        specializations: (filtersData['specializations'] as List)
            .map((spec) => FilterOption(
                  id: spec['specializationId'].toString(),
                  label: spec['specializationLabel'],
                ))
            .toList(),
        geographicZones: (geoZonesData['result'] as List)
            .map((zone) => FilterOption(
                  id: zone['geographicZoneId'].toString(),
                  label: zone['geographicZoneLabel'],
                ))
            .toList(),
        durations: [6, 12, 18, 24],
      );
    } catch (e) {
      print('Error fetching filters: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
      }
      throw Exception('Erreur lors de la récupération des filtres: $e');
    }
  }
}
