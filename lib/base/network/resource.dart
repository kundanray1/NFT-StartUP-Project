import 'package:freezed_annotation/freezed_annotation.dart';
part 'resource.freezed.dart';

@freezed
abstract class Resource with _$Resource {
  const factory Resource.successState(String body) = Success;
  const factory Resource.errorState(String error) = Error;
}
