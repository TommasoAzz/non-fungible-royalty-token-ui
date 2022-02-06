import 'routing_data.dart';

extension StringExtension on String {
  RoutingData get routingData {
    final uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}
