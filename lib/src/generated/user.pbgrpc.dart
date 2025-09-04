// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $0;

export 'user.pb.dart';

@$pb.GrpcServiceName('DisplayMessageService')
class DisplayMessageServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DisplayMessageServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.DisplayUserResponse> displayMessage(
    $0.DisplayUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$displayMessage, request, options: options);
  }

  // method descriptors

  static final _$displayMessage =
      $grpc.ClientMethod<$0.DisplayUserRequest, $0.DisplayUserResponse>(
          '/DisplayMessageService/DisplayMessage',
          ($0.DisplayUserRequest value) => value.writeToBuffer(),
          $0.DisplayUserResponse.fromBuffer);
}

@$pb.GrpcServiceName('DisplayMessageService')
abstract class DisplayMessageServiceBase extends $grpc.Service {
  $core.String get $name => 'DisplayMessageService';

  DisplayMessageServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.DisplayUserRequest, $0.DisplayUserResponse>(
            'DisplayMessage',
            displayMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DisplayUserRequest.fromBuffer(value),
            ($0.DisplayUserResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.DisplayUserResponse> displayMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DisplayUserRequest> $request) async {
    return displayMessage($call, await $request);
  }

  $async.Future<$0.DisplayUserResponse> displayMessage(
      $grpc.ServiceCall call, $0.DisplayUserRequest request);
}
