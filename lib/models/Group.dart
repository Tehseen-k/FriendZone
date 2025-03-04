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


/** This is an auto generated class representing the Group type in your schema. */
class Group extends amplify_core.Model {
  static const classType = const _GroupModelType();
  final String id;
  final String? _name;
  final String? _description;
  final List<String>? _interests;
  final List<String>? _hobbies;
  final double? _latitude;
  final double? _longitude;
  final double? _allowedRadius;
  final String? _locationName;
  final List<String>? _mediaKeys;
  final String? _groupImageKey;
  final User? _admin;
  final List<GroupMember>? _members;
  final List<GroupEvent>? _events;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GroupModelIdentifier get modelIdentifier {
      return GroupModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get interests {
    return _interests;
  }
  
  List<String>? get hobbies {
    return _hobbies;
  }
  
  double get latitude {
    try {
      return _latitude!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get longitude {
    try {
      return _longitude!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get allowedRadius {
    try {
      return _allowedRadius!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get locationName {
    return _locationName;
  }
  
  List<String>? get mediaKeys {
    return _mediaKeys;
  }
  
  String? get groupImageKey {
    return _groupImageKey;
  }
  
  User get admin {
    try {
      return _admin!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<GroupMember>? get members {
    return _members;
  }
  
  List<GroupEvent>? get events {
    return _events;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Group._internal({required this.id, required name, required description, interests, hobbies, required latitude, required longitude, required allowedRadius, locationName, mediaKeys, groupImageKey, required admin, members, events, createdAt, updatedAt}): _name = name, _description = description, _interests = interests, _hobbies = hobbies, _latitude = latitude, _longitude = longitude, _allowedRadius = allowedRadius, _locationName = locationName, _mediaKeys = mediaKeys, _groupImageKey = groupImageKey, _admin = admin, _members = members, _events = events, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Group({String? id, required String name, required String description, List<String>? interests, List<String>? hobbies, required double latitude, required double longitude, required double allowedRadius, String? locationName, List<String>? mediaKeys, String? groupImageKey, required User admin, List<GroupMember>? members, List<GroupEvent>? events, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Group._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      description: description,
      interests: interests != null ? List<String>.unmodifiable(interests) : interests,
      hobbies: hobbies != null ? List<String>.unmodifiable(hobbies) : hobbies,
      latitude: latitude,
      longitude: longitude,
      allowedRadius: allowedRadius,
      locationName: locationName,
      mediaKeys: mediaKeys != null ? List<String>.unmodifiable(mediaKeys) : mediaKeys,
      groupImageKey: groupImageKey,
      admin: admin,
      members: members != null ? List<GroupMember>.unmodifiable(members) : members,
      events: events != null ? List<GroupEvent>.unmodifiable(events) : events,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Group &&
      id == other.id &&
      _name == other._name &&
      _description == other._description &&
      DeepCollectionEquality().equals(_interests, other._interests) &&
      DeepCollectionEquality().equals(_hobbies, other._hobbies) &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _allowedRadius == other._allowedRadius &&
      _locationName == other._locationName &&
      DeepCollectionEquality().equals(_mediaKeys, other._mediaKeys) &&
      _groupImageKey == other._groupImageKey &&
      _admin == other._admin &&
      DeepCollectionEquality().equals(_members, other._members) &&
      DeepCollectionEquality().equals(_events, other._events) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Group {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("interests=" + (_interests != null ? _interests!.toString() : "null") + ", ");
    buffer.write("hobbies=" + (_hobbies != null ? _hobbies!.toString() : "null") + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("allowedRadius=" + (_allowedRadius != null ? _allowedRadius!.toString() : "null") + ", ");
    buffer.write("locationName=" + "$_locationName" + ", ");
    buffer.write("mediaKeys=" + (_mediaKeys != null ? _mediaKeys!.toString() : "null") + ", ");
    buffer.write("groupImageKey=" + "$_groupImageKey" + ", ");
    buffer.write("admin=" + (_admin != null ? _admin!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Group copyWith({String? name, String? description, List<String>? interests, List<String>? hobbies, double? latitude, double? longitude, double? allowedRadius, String? locationName, List<String>? mediaKeys, String? groupImageKey, User? admin, List<GroupMember>? members, List<GroupEvent>? events, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Group._internal(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      interests: interests ?? this.interests,
      hobbies: hobbies ?? this.hobbies,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      allowedRadius: allowedRadius ?? this.allowedRadius,
      locationName: locationName ?? this.locationName,
      mediaKeys: mediaKeys ?? this.mediaKeys,
      groupImageKey: groupImageKey ?? this.groupImageKey,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Group copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? description,
    ModelFieldValue<List<String>>? interests,
    ModelFieldValue<List<String>>? hobbies,
    ModelFieldValue<double>? latitude,
    ModelFieldValue<double>? longitude,
    ModelFieldValue<double>? allowedRadius,
    ModelFieldValue<String?>? locationName,
    ModelFieldValue<List<String>?>? mediaKeys,
    ModelFieldValue<String?>? groupImageKey,
    ModelFieldValue<User>? admin,
    ModelFieldValue<List<GroupMember>?>? members,
    ModelFieldValue<List<GroupEvent>?>? events,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return Group._internal(
      id: id,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      interests: interests == null ? this.interests : interests.value,
      hobbies: hobbies == null ? this.hobbies : hobbies.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      allowedRadius: allowedRadius == null ? this.allowedRadius : allowedRadius.value,
      locationName: locationName == null ? this.locationName : locationName.value,
      mediaKeys: mediaKeys == null ? this.mediaKeys : mediaKeys.value,
      groupImageKey: groupImageKey == null ? this.groupImageKey : groupImageKey.value,
      admin: admin == null ? this.admin : admin.value,
      members: members == null ? this.members : members.value,
      events: events == null ? this.events : events.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  Group.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _description = json['description'],
      _interests = json['interests']?.cast<String>(),
      _hobbies = json['hobbies']?.cast<String>(),
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _allowedRadius = (json['allowedRadius'] as num?)?.toDouble(),
      _locationName = json['locationName'],
      _mediaKeys = json['mediaKeys']?.cast<String>(),
      _groupImageKey = json['groupImageKey'],
      _admin = json['admin'] != null
        ? json['admin']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['admin']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['admin']))
        : null,
      _members = json['members']  is Map
        ? (json['members']['items'] is List
          ? (json['members']['items'] as List)
              .where((e) => e != null)
              .map((e) => GroupMember.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['members'] is List
          ? (json['members'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => GroupMember.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _events = json['events']  is Map
        ? (json['events']['items'] is List
          ? (json['events']['items'] as List)
              .where((e) => e != null)
              .map((e) => GroupEvent.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['events'] is List
          ? (json['events'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => GroupEvent.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'description': _description, 'interests': _interests, 'hobbies': _hobbies, 'latitude': _latitude, 'longitude': _longitude, 'allowedRadius': _allowedRadius, 'locationName': _locationName, 'mediaKeys': _mediaKeys, 'groupImageKey': _groupImageKey, 'admin': _admin?.toJson(), 'members': _members?.map((GroupMember? e) => e?.toJson()).toList(), 'events': _events?.map((GroupEvent? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'description': _description,
    'interests': _interests,
    'hobbies': _hobbies,
    'latitude': _latitude,
    'longitude': _longitude,
    'allowedRadius': _allowedRadius,
    'locationName': _locationName,
    'mediaKeys': _mediaKeys,
    'groupImageKey': _groupImageKey,
    'admin': _admin,
    'members': _members,
    'events': _events,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GroupModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GroupModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final INTERESTS = amplify_core.QueryField(fieldName: "interests");
  static final HOBBIES = amplify_core.QueryField(fieldName: "hobbies");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final ALLOWEDRADIUS = amplify_core.QueryField(fieldName: "allowedRadius");
  static final LOCATIONNAME = amplify_core.QueryField(fieldName: "locationName");
  static final MEDIAKEYS = amplify_core.QueryField(fieldName: "mediaKeys");
  static final GROUPIMAGEKEY = amplify_core.QueryField(fieldName: "groupImageKey");
  static final ADMIN = amplify_core.QueryField(
    fieldName: "admin",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final MEMBERS = amplify_core.QueryField(
    fieldName: "members",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GroupMember'));
  static final EVENTS = amplify_core.QueryField(
    fieldName: "events",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GroupEvent'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Group";
    modelSchemaDefinition.pluralName = "Groups";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["adminId"], name: "byAdmin")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.INTERESTS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.HOBBIES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.LATITUDE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.LONGITUDE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.ALLOWEDRADIUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.LOCATIONNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.MEDIAKEYS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.GROUPIMAGEKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Group.ADMIN,
      isRequired: true,
      targetNames: ['adminId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Group.MEMBERS,
      isRequired: false,
      ofModelName: 'GroupMember',
      associatedKey: GroupMember.GROUP
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Group.EVENTS,
      isRequired: false,
      ofModelName: 'GroupEvent',
      associatedKey: GroupEvent.GROUP
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Group.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _GroupModelType extends amplify_core.ModelType<Group> {
  const _GroupModelType();
  
  @override
  Group fromJson(Map<String, dynamic> jsonData) {
    return Group.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Group';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Group] in your schema.
 */
class GroupModelIdentifier implements amplify_core.ModelIdentifier<Group> {
  final String id;

  /** Create an instance of GroupModelIdentifier using [id] the primary key. */
  const GroupModelIdentifier({
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
  String toString() => 'GroupModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GroupModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}