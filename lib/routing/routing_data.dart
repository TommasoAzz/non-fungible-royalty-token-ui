import 'package:collection/collection.dart';

class RoutingData {
  final String route;
  final Map<String, String> _queryParameters;

  const RoutingData({
    required this.route,
    required final Map<String, String> queryParameters,
  }) : _queryParameters = queryParameters;

  String? operator [](String key) => _queryParameters[key];

  @override
  String toString() => 'RoutingData(route: $route, _queryParameters: $_queryParameters)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;
  
    return other is RoutingData &&
      other.route == route &&
      mapEquals(other._queryParameters, _queryParameters);
  }

  @override
  int get hashCode => route.hashCode ^ _queryParameters.hashCode;
}
