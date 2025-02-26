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


/** This is an auto generated class representing the ChatParticipant type in your schema. */
class ChatParticipant extends amplify_core.Model {
  static const classType = const _ChatParticipantModelType();
  final String id;
  final User? _user;
  final ChatRoom? _chatRoom;
  final String? _role;
  final amplify_core.TemporalDateTime? _lastReadAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatParticipantModelIdentifier get modelIdentifier {
      return ChatParticipantModelIdentifier(
        id: id
      );
  }
  
  User get user {
    try {
      return _user!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ChatRoom get chatRoom {
    try {
      return _chatRoom!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get role {
    return _role;
  }
  
  amplify_core.TemporalDateTime? get lastReadAt {
    return _lastReadAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ChatParticipant._internal({required this.id, required user, required chatRoom, role, lastReadAt, createdAt, updatedAt}): _user = user, _chatRoom = chatRoom, _role = role, _lastReadAt = lastReadAt, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChatParticipant({String? id, required User user, required ChatRoom chatRoom, String? role, amplify_core.TemporalDateTime? lastReadAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return ChatParticipant._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      chatRoom: chatRoom,
      role: role,
      lastReadAt: lastReadAt,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatParticipant &&
      id == other.id &&
      _user == other._user &&
      _chatRoom == other._chatRoom &&
      _role == other._role &&
      _lastReadAt == other._lastReadAt &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatParticipant {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("chatRoom=" + (_chatRoom != null ? _chatRoom!.toString() : "null") + ", ");
    buffer.write("role=" + "$_role" + ", ");
    buffer.write("lastReadAt=" + (_lastReadAt != null ? _lastReadAt!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatParticipant copyWith({User? user, ChatRoom? chatRoom, String? role, amplify_core.TemporalDateTime? lastReadAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return ChatParticipant._internal(
      id: id,
      user: user ?? this.user,
      chatRoom: chatRoom ?? this.chatRoom,
      role: role ?? this.role,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  ChatParticipant copyWithModelFieldValues({
    ModelFieldValue<User>? user,
    ModelFieldValue<ChatRoom>? chatRoom,
    ModelFieldValue<String?>? role,
    ModelFieldValue<amplify_core.TemporalDateTime?>? lastReadAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return ChatParticipant._internal(
      id: id,
      user: user == null ? this.user : user.value,
      chatRoom: chatRoom == null ? this.chatRoom : chatRoom.value,
      role: role == null ? this.role : role.value,
      lastReadAt: lastReadAt == null ? this.lastReadAt : lastReadAt.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  ChatParticipant.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _chatRoom = json['chatRoom'] != null
        ? json['chatRoom']['serializedData'] != null
          ? ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']['serializedData']))
          : ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']))
        : null,
      _role = json['role'],
      _lastReadAt = json['lastReadAt'] != null ? amplify_core.TemporalDateTime.fromString(json['lastReadAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'chatRoom': _chatRoom?.toJson(), 'role': _role, 'lastReadAt': _lastReadAt?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'chatRoom': _chatRoom,
    'role': _role,
    'lastReadAt': _lastReadAt,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatParticipantModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatParticipantModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final CHATROOM = amplify_core.QueryField(
    fieldName: "chatRoom",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoom'));
  static final ROLE = amplify_core.QueryField(fieldName: "role");
  static final LASTREADAT = amplify_core.QueryField(fieldName: "lastReadAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatParticipant";
    modelSchemaDefinition.pluralName = "ChatParticipants";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["userId"], name: "byUser"),
      amplify_core.ModelIndex(fields: const ["chatRoomId"], name: "byChatRoom")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ChatParticipant.USER,
      isRequired: true,
      targetNames: ['userId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ChatParticipant.CHATROOM,
      isRequired: true,
      targetNames: ['chatRoomId'],
      ofModelName: 'ChatRoom'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatParticipant.ROLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatParticipant.LASTREADAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatParticipant.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatParticipant.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ChatParticipantModelType extends amplify_core.ModelType<ChatParticipant> {
  const _ChatParticipantModelType();
  
  @override
  ChatParticipant fromJson(Map<String, dynamic> jsonData) {
    return ChatParticipant.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatParticipant';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatParticipant] in your schema.
 */
class ChatParticipantModelIdentifier implements amplify_core.ModelIdentifier<ChatParticipant> {
  final String id;

  /** Create an instance of ChatParticipantModelIdentifier using [id] the primary key. */
  const ChatParticipantModelIdentifier({
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
  String toString() => 'ChatParticipantModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatParticipantModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}