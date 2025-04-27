//
//  Generated code. Do not modify.
//  source: pack.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use stickerDescriptor instead')
const Sticker$json = {
  '1': 'Sticker',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'emoji', '3': 2, '4': 1, '5': 9, '10': 'emoji'},
  ],
};

/// Descriptor for `Sticker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stickerDescriptor = $convert.base64Decode(
    'CgdTdGlja2VyEg4KAmlkGAEgASgNUgJpZBIUCgVlbW9qaRgCIAEoCVIFZW1vamk=');

@$core.Deprecated('Use packDescriptor instead')
const Pack$json = {
  '1': 'Pack',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    {'1': 'cover', '3': 3, '4': 1, '5': 11, '6': '.signalstickers.Sticker', '10': 'cover'},
    {'1': 'stickers', '3': 4, '4': 3, '5': 11, '6': '.signalstickers.Sticker', '10': 'stickers'},
  ],
};

/// Descriptor for `Pack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packDescriptor = $convert.base64Decode(
    'CgRQYWNrEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIWCgZhdXRob3IYAiABKAlSBmF1dGhvchItCg'
    'Vjb3ZlchgDIAEoCzIXLnNpZ25hbHN0aWNrZXJzLlN0aWNrZXJSBWNvdmVyEjMKCHN0aWNrZXJz'
    'GAQgAygLMhcuc2lnbmFsc3RpY2tlcnMuU3RpY2tlclIIc3RpY2tlcnM=');

