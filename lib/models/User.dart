/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _username;
  final String? _email;
  final String? _profileImageKey;
  final List<String>? _userImageKeys;
  final List<String>? _profileVideoKey;
  final List<String>? _interests;
  final List<String>? _hobbies;
  final String? _address;
  final double? _latitude;
  final double? _longitude;
  final double? _radius;
  final String? _introduction;
  final bool? _visible;
  final List<ChatParticipant>? _chatParticipant;
  final List<Message>? _messages;
  final List<ReadReceipt>? _readReceipts;
  final List<ChatRoom>? _chatRoomsAsAdmin;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String get username {
    try {
      return _username!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get profileImageKey {
    return _profileImageKey;
  }
  
  List<String>? get userImageKeys {
    return _userImageKeys;
  }
  
  List<String>? get profileVideoKey {
    return _profileVideoKey;
  }
  
  List<String>? get interests {
    return _interests;
  }
  
  List<String>? get hobbies {
    return _hobbies;
  }
  
  String? get address {
    return _address;
  }
  
  double? get latitude {
    return _latitude;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  double? get radius {
    return _radius;
  }
  
  String? get introduction {
    return _introduction;
  }
  
  bool? get visible {
    return _visible;
  }
  
  List<ChatParticipant>? get chatParticipant {
    return _chatParticipant;
  }
  
  List<Message>? get messages {
    return _messages;
  }
  
  List<ReadReceipt>? get readReceipts {
    return _readReceipts;
  }
  
  List<ChatRoom>? get chatRoomsAsAdmin {
    return _chatRoomsAsAdmin;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, required username, required email, profileImageKey, userImageKeys, profileVideoKey, interests, hobbies, address, latitude, longitude, radius, introduction, visible, chatParticipant, messages, readReceipts, chatRoomsAsAdmin, createdAt, updatedAt}): _username = username, _email = email, _profileImageKey = profileImageKey, _userImageKeys = userImageKeys, _profileVideoKey = profileVideoKey, _interests = interests, _hobbies = hobbies, _address = address, _latitude = latitude, _longitude = longitude, _radius = radius, _introduction = introduction, _visible = visible, _chatParticipant = chatParticipant, _messages = messages, _readReceipts = readReceipts, _chatRoomsAsAdmin = chatRoomsAsAdmin, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, required String username, required String email, String? profileImageKey, List<String>? userImageKeys, List<String>? profileVideoKey, List<String>? interests, List<String>? hobbies, String? address, double? latitude, double? longitude, double? radius, String? introduction, bool? visible, List<ChatParticipant>? chatParticipant, List<Message>? messages, List<ReadReceipt>? readReceipts, List<ChatRoom>? chatRoomsAsAdmin, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      username: username,
      email: email,
      profileImageKey: profileImageKey,
      userImageKeys: userImageKeys != null ? List<String>.unmodifiable(userImageKeys) : userImageKeys,
      profileVideoKey: profileVideoKey != null ? List<String>.unmodifiable(profileVideoKey) : profileVideoKey,
      interests: interests != null ? List<String>.unmodifiable(interests) : interests,
      hobbies: hobbies != null ? List<String>.unmodifiable(hobbies) : hobbies,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      introduction: introduction,
      visible: visible,
      chatParticipant: chatParticipant != null ? List<ChatParticipant>.unmodifiable(chatParticipant) : chatParticipant,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      readReceipts: readReceipts != null ? List<ReadReceipt>.unmodifiable(readReceipts) : readReceipts,
      chatRoomsAsAdmin: chatRoomsAsAdmin != null ? List<ChatRoom>.unmodifiable(chatRoomsAsAdmin) : chatRoomsAsAdmin,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _username == other._username &&
      _email == other._email &&
      _profileImageKey == other._profileImageKey &&
      DeepCollectionEquality().equals(_userImageKeys, other._userImageKeys) &&
      DeepCollectionEquality().equals(_profileVideoKey, other._profileVideoKey) &&
      DeepCollectionEquality().equals(_interests, other._interests) &&
      DeepCollectionEquality().equals(_hobbies, other._hobbies) &&
      _address == other._address &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _radius == other._radius &&
      _introduction == other._introduction &&
      _visible == other._visible &&
      DeepCollectionEquality().equals(_chatParticipant, other._chatParticipant) &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      DeepCollectionEquality().equals(_readReceipts, other._readReceipts) &&
      DeepCollectionEquality().equals(_chatRoomsAsAdmin, other._chatRoomsAsAdmin) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("username=" + "$_username" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("profileImageKey=" + "$_profileImageKey" + ", ");
    buffer.write("userImageKeys=" + (_userImageKeys != null ? _userImageKeys!.toString() : "null") + ", ");
    buffer.write("profileVideoKey=" + (_profileVideoKey != null ? _profileVideoKey!.toString() : "null") + ", ");
    buffer.write("interests=" + (_interests != null ? _interests!.toString() : "null") + ", ");
    buffer.write("hobbies=" + (_hobbies != null ? _hobbies!.toString() : "null") + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("radius=" + (_radius != null ? _radius!.toString() : "null") + ", ");
    buffer.write("introduction=" + "$_introduction" + ", ");
    buffer.write("visible=" + (_visible != null ? _visible!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? username, String? email, String? profileImageKey, List<String>? userImageKeys, List<String>? profileVideoKey, List<String>? interests, List<String>? hobbies, String? address, double? latitude, double? longitude, double? radius, String? introduction, bool? visible, List<ChatParticipant>? chatParticipant, List<Message>? messages, List<ReadReceipt>? readReceipts, List<ChatRoom>? chatRoomsAsAdmin, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return User._internal(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageKey: profileImageKey ?? this.profileImageKey,
      userImageKeys: userImageKeys ?? this.userImageKeys,
      profileVideoKey: profileVideoKey ?? this.profileVideoKey,
      interests: interests ?? this.interests,
      hobbies: hobbies ?? this.hobbies,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      introduction: introduction ?? this.introduction,
      visible: visible ?? this.visible,
      chatParticipant: chatParticipant ?? this.chatParticipant,
      messages: messages ?? this.messages,
      readReceipts: readReceipts ?? this.readReceipts,
      chatRoomsAsAdmin: chatRoomsAsAdmin ?? this.chatRoomsAsAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String>? username,
    ModelFieldValue<String>? email,
    ModelFieldValue<String?>? profileImageKey,
    ModelFieldValue<List<String>?>? userImageKeys,
    ModelFieldValue<List<String>?>? profileVideoKey,
    ModelFieldValue<List<String>>? interests,
    ModelFieldValue<List<String>>? hobbies,
    ModelFieldValue<String?>? address,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<double?>? radius,
    ModelFieldValue<String?>? introduction,
    ModelFieldValue<bool?>? visible,
    ModelFieldValue<List<ChatParticipant>?>? chatParticipant,
    ModelFieldValue<List<Message>?>? messages,
    ModelFieldValue<List<ReadReceipt>?>? readReceipts,
    ModelFieldValue<List<ChatRoom>?>? chatRoomsAsAdmin,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return User._internal(
      id: id,
      username: username == null ? this.username : username.value,
      email: email == null ? this.email : email.value,
      profileImageKey: profileImageKey == null ? this.profileImageKey : profileImageKey.value,
      userImageKeys: userImageKeys == null ? this.userImageKeys : userImageKeys.value,
      profileVideoKey: profileVideoKey == null ? this.profileVideoKey : profileVideoKey.value,
      interests: interests == null ? this.interests : interests.value,
      hobbies: hobbies == null ? this.hobbies : hobbies.value,
      address: address == null ? this.address : address.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      radius: radius == null ? this.radius : radius.value,
      introduction: introduction == null ? this.introduction : introduction.value,
      visible: visible == null ? this.visible : visible.value,
      chatParticipant: chatParticipant == null ? this.chatParticipant : chatParticipant.value,
      messages: messages == null ? this.messages : messages.value,
      readReceipts: readReceipts == null ? this.readReceipts : readReceipts.value,
      chatRoomsAsAdmin: chatRoomsAsAdmin == null ? this.chatRoomsAsAdmin : chatRoomsAsAdmin.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _username = json['username'],
      _email = json['email'],
      _profileImageKey = json['profileImageKey'],
      _userImageKeys = json['userImageKeys']?.cast<String>(),
      _profileVideoKey = json['profileVideoKey']?.cast<String>(),
      _interests = json['interests']?.cast<String>(),
      _hobbies = json['hobbies']?.cast<String>(),
      _address = json['address'],
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _radius = (json['radius'] as num?)?.toDouble(),
      _introduction = json['introduction'],
      _visible = json['visible'],
      _chatParticipant = json['chatParticipant']  is Map
        ? (json['chatParticipant']['items'] is List
          ? (json['chatParticipant']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatParticipant.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['chatParticipant'] is List
          ? (json['chatParticipant'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ChatParticipant.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _messages = json['messages']  is Map
        ? (json['messages']['items'] is List
          ? (json['messages']['items'] as List)
              .where((e) => e != null)
              .map((e) => Message.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['messages'] is List
          ? (json['messages'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Message.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _readReceipts = json['readReceipts']  is Map
        ? (json['readReceipts']['items'] is List
          ? (json['readReceipts']['items'] as List)
              .where((e) => e != null)
              .map((e) => ReadReceipt.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['readReceipts'] is List
          ? (json['readReceipts'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ReadReceipt.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _chatRoomsAsAdmin = json['chatRoomsAsAdmin']  is Map
        ? (json['chatRoomsAsAdmin']['items'] is List
          ? (json['chatRoomsAsAdmin']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatRoom.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['chatRoomsAsAdmin'] is List
          ? (json['chatRoomsAsAdmin'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ChatRoom.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'username': _username, 'email': _email, 'profileImageKey': _profileImageKey, 'userImageKeys': _userImageKeys, 'profileVideoKey': _profileVideoKey, 'interests': _interests, 'hobbies': _hobbies, 'address': _address, 'latitude': _latitude, 'longitude': _longitude, 'radius': _radius, 'introduction': _introduction, 'visible': _visible, 'chatParticipant': _chatParticipant?.map((ChatParticipant? e) => e?.toJson()).toList(), 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'readReceipts': _readReceipts?.map((ReadReceipt? e) => e?.toJson()).toList(), 'chatRoomsAsAdmin': _chatRoomsAsAdmin?.map((ChatRoom? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'username': _username,
    'email': _email,
    'profileImageKey': _profileImageKey,
    'userImageKeys': _userImageKeys,
    'profileVideoKey': _profileVideoKey,
    'interests': _interests,
    'hobbies': _hobbies,
    'address': _address,
    'latitude': _latitude,
    'longitude': _longitude,
    'radius': _radius,
    'introduction': _introduction,
    'visible': _visible,
    'chatParticipant': _chatParticipant,
    'messages': _messages,
    'readReceipts': _readReceipts,
    'chatRoomsAsAdmin': _chatRoomsAsAdmin,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERNAME = amplify_core.QueryField(fieldName: "username");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final PROFILEIMAGEKEY = amplify_core.QueryField(fieldName: "profileImageKey");
  static final USERIMAGEKEYS = amplify_core.QueryField(fieldName: "userImageKeys");
  static final PROFILEVIDEOKEY = amplify_core.QueryField(fieldName: "profileVideoKey");
  static final INTERESTS = amplify_core.QueryField(fieldName: "interests");
  static final HOBBIES = amplify_core.QueryField(fieldName: "hobbies");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final RADIUS = amplify_core.QueryField(fieldName: "radius");
  static final INTRODUCTION = amplify_core.QueryField(fieldName: "introduction");
  static final VISIBLE = amplify_core.QueryField(fieldName: "visible");
  static final CHATPARTICIPANT = amplify_core.QueryField(
    fieldName: "chatParticipant",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatParticipant'));
  static final MESSAGES = amplify_core.QueryField(
    fieldName: "messages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Message'));
  static final READRECEIPTS = amplify_core.QueryField(
    fieldName: "readReceipts",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ReadReceipt'));
  static final CHATROOMSASADMIN = amplify_core.QueryField(
    fieldName: "chatRoomsAsAdmin",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoom'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.USERNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PROFILEIMAGEKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.USERIMAGEKEYS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PROFILEVIDEOKEY,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.HOBBIES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ADDRESS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.RADIUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTRODUCTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.VISIBLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.CHATPARTICIPANT,
      isRequired: false,
      ofModelName: 'ChatParticipant',
      associatedKey: ChatParticipant.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.MESSAGES,
      isRequired: false,
      ofModelName: 'Message',
      associatedKey: Message.SENDER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.READRECEIPTS,
      isRequired: false,
      ofModelName: 'ReadReceipt',
      associatedKey: ReadReceipt.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.CHATROOMSASADMIN,
      isRequired: false,
      ofModelName: 'ChatRoom',
      associatedKey: ChatRoom.ADMIN
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}