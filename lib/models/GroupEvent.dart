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


/** This is an auto generated class representing the GroupEvent type in your schema. */
class GroupEvent extends amplify_core.Model {
  static const classType = const _GroupEventModelType();
  final String id;
  final String? _title;
  final String? _description;
  final String? _location;
  final double? _latitude;
  final double? _longitude;
  final amplify_core.TemporalDateTime? _startTime;
  final amplify_core.TemporalDateTime? _endTime;
  final String? _eventType;
  final List<String>? _mediaKeys;
  final Group? _group;
  final User? _creator;
  final List<EventAttendee>? _attendees;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GroupEventModelIdentifier get modelIdentifier {
      return GroupEventModelIdentifier(
        id: id
      );
  }
  
  String get title {
    try {
      return _title!;
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
  
  String get location {
    try {
      return _location!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get latitude {
    return _latitude;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  amplify_core.TemporalDateTime get startTime {
    try {
      return _startTime!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get endTime {
    try {
      return _endTime!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get eventType {
    try {
      return _eventType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get mediaKeys {
    return _mediaKeys;
  }
  
  Group get group {
    try {
      return _group!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  User get creator {
    try {
      return _creator!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<EventAttendee>? get attendees {
    return _attendees;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const GroupEvent._internal({required this.id, required title, required description, required location, latitude, longitude, required startTime, required endTime, required eventType, mediaKeys, required group, required creator, attendees, createdAt, updatedAt}): _title = title, _description = description, _location = location, _latitude = latitude, _longitude = longitude, _startTime = startTime, _endTime = endTime, _eventType = eventType, _mediaKeys = mediaKeys, _group = group, _creator = creator, _attendees = attendees, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory GroupEvent({String? id, required String title, required String description, required String location, double? latitude, double? longitude, required amplify_core.TemporalDateTime startTime, required amplify_core.TemporalDateTime endTime, required String eventType, List<String>? mediaKeys, required Group group, required User creator, List<EventAttendee>? attendees, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return GroupEvent._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      description: description,
      location: location,
      latitude: latitude,
      longitude: longitude,
      startTime: startTime,
      endTime: endTime,
      eventType: eventType,
      mediaKeys: mediaKeys != null ? List<String>.unmodifiable(mediaKeys) : mediaKeys,
      group: group,
      creator: creator,
      attendees: attendees != null ? List<EventAttendee>.unmodifiable(attendees) : attendees,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupEvent &&
      id == other.id &&
      _title == other._title &&
      _description == other._description &&
      _location == other._location &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _startTime == other._startTime &&
      _endTime == other._endTime &&
      _eventType == other._eventType &&
      DeepCollectionEquality().equals(_mediaKeys, other._mediaKeys) &&
      _group == other._group &&
      _creator == other._creator &&
      DeepCollectionEquality().equals(_attendees, other._attendees) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("GroupEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("location=" + "$_location" + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("startTime=" + (_startTime != null ? _startTime!.format() : "null") + ", ");
    buffer.write("endTime=" + (_endTime != null ? _endTime!.format() : "null") + ", ");
    buffer.write("eventType=" + "$_eventType" + ", ");
    buffer.write("mediaKeys=" + (_mediaKeys != null ? _mediaKeys!.toString() : "null") + ", ");
    buffer.write("group=" + (_group != null ? _group!.toString() : "null") + ", ");
    buffer.write("creator=" + (_creator != null ? _creator!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  GroupEvent copyWith({String? title, String? description, String? location, double? latitude, double? longitude, amplify_core.TemporalDateTime? startTime, amplify_core.TemporalDateTime? endTime, String? eventType, List<String>? mediaKeys, Group? group, User? creator, List<EventAttendee>? attendees, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return GroupEvent._internal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      eventType: eventType ?? this.eventType,
      mediaKeys: mediaKeys ?? this.mediaKeys,
      group: group ?? this.group,
      creator: creator ?? this.creator,
      attendees: attendees ?? this.attendees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  GroupEvent copyWithModelFieldValues({
    ModelFieldValue<String>? title,
    ModelFieldValue<String>? description,
    ModelFieldValue<String>? location,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<amplify_core.TemporalDateTime>? startTime,
    ModelFieldValue<amplify_core.TemporalDateTime>? endTime,
    ModelFieldValue<String>? eventType,
    ModelFieldValue<List<String>?>? mediaKeys,
    ModelFieldValue<Group>? group,
    ModelFieldValue<User>? creator,
    ModelFieldValue<List<EventAttendee>?>? attendees,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return GroupEvent._internal(
      id: id,
      title: title == null ? this.title : title.value,
      description: description == null ? this.description : description.value,
      location: location == null ? this.location : location.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      startTime: startTime == null ? this.startTime : startTime.value,
      endTime: endTime == null ? this.endTime : endTime.value,
      eventType: eventType == null ? this.eventType : eventType.value,
      mediaKeys: mediaKeys == null ? this.mediaKeys : mediaKeys.value,
      group: group == null ? this.group : group.value,
      creator: creator == null ? this.creator : creator.value,
      attendees: attendees == null ? this.attendees : attendees.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  GroupEvent.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _description = json['description'],
      _location = json['location'],
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _startTime = json['startTime'] != null ? amplify_core.TemporalDateTime.fromString(json['startTime']) : null,
      _endTime = json['endTime'] != null ? amplify_core.TemporalDateTime.fromString(json['endTime']) : null,
      _eventType = json['eventType'],
      _mediaKeys = json['mediaKeys']?.cast<String>(),
      _group = json['group'] != null
        ? json['group']['serializedData'] != null
          ? Group.fromJson(new Map<String, dynamic>.from(json['group']['serializedData']))
          : Group.fromJson(new Map<String, dynamic>.from(json['group']))
        : null,
      _creator = json['creator'] != null
        ? json['creator']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['creator']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['creator']))
        : null,
      _attendees = json['attendees']  is Map
        ? (json['attendees']['items'] is List
          ? (json['attendees']['items'] as List)
              .where((e) => e != null)
              .map((e) => EventAttendee.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['attendees'] is List
          ? (json['attendees'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => EventAttendee.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'description': _description, 'location': _location, 'latitude': _latitude, 'longitude': _longitude, 'startTime': _startTime?.format(), 'endTime': _endTime?.format(), 'eventType': _eventType, 'mediaKeys': _mediaKeys, 'group': _group?.toJson(), 'creator': _creator?.toJson(), 'attendees': _attendees?.map((EventAttendee? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'description': _description,
    'location': _location,
    'latitude': _latitude,
    'longitude': _longitude,
    'startTime': _startTime,
    'endTime': _endTime,
    'eventType': _eventType,
    'mediaKeys': _mediaKeys,
    'group': _group,
    'creator': _creator,
    'attendees': _attendees,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GroupEventModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GroupEventModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final LOCATION = amplify_core.QueryField(fieldName: "location");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final STARTTIME = amplify_core.QueryField(fieldName: "startTime");
  static final ENDTIME = amplify_core.QueryField(fieldName: "endTime");
  static final EVENTTYPE = amplify_core.QueryField(fieldName: "eventType");
  static final MEDIAKEYS = amplify_core.QueryField(fieldName: "mediaKeys");
  static final GROUP = amplify_core.QueryField(
    fieldName: "group",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Group'));
  static final CREATOR = amplify_core.QueryField(
    fieldName: "creator",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final ATTENDEES = amplify_core.QueryField(
    fieldName: "attendees",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'EventAttendee'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GroupEvent";
    modelSchemaDefinition.pluralName = "GroupEvents";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["groupId"], name: "byGroup"),
      amplify_core.ModelIndex(fields: const ["creatorId"], name: "byCreator")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.LOCATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.STARTTIME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.ENDTIME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.EVENTTYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.MEDIAKEYS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: GroupEvent.GROUP,
      isRequired: true,
      targetNames: ['groupId'],
      ofModelName: 'Group'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: GroupEvent.CREATOR,
      isRequired: true,
      targetNames: ['creatorId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: GroupEvent.ATTENDEES,
      isRequired: false,
      ofModelName: 'EventAttendee',
      associatedKey: EventAttendee.EVENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GroupEvent.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _GroupEventModelType extends amplify_core.ModelType<GroupEvent> {
  const _GroupEventModelType();
  
  @override
  GroupEvent fromJson(Map<String, dynamic> jsonData) {
    return GroupEvent.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'GroupEvent';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [GroupEvent] in your schema.
 */
class GroupEventModelIdentifier implements amplify_core.ModelIdentifier<GroupEvent> {
  final String id;

  /** Create an instance of GroupEventModelIdentifier using [id] the primary key. */
  const GroupEventModelIdentifier({
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
  String toString() => 'GroupEventModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GroupEventModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}