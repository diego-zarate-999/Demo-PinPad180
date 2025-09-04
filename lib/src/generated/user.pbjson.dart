// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use displayUserRequestDescriptor instead')
const DisplayUserRequest$json = {
  '1': 'DisplayUserRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `DisplayUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displayUserRequestDescriptor = $convert.base64Decode(
    'ChJEaXNwbGF5VXNlclJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgdhZGRyZXNzGAIgAS'
    'gJUgdhZGRyZXNz');

@$core.Deprecated('Use displayUserResponseDescriptor instead')
const DisplayUserResponse$json = {
  '1': 'DisplayUserResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DisplayUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displayUserResponseDescriptor =
    $convert.base64Decode(
        'ChNEaXNwbGF5VXNlclJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');
