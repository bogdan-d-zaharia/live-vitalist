import 'package:live_vitalist/core/network/data/http_handler.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
INetwork network(Ref ref) {
  return HttpHandler(apiUrl);
}
