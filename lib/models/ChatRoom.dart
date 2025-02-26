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


/** This is an auto generated class representing the ChatRoom type in your schema. */
class ChatRoom extends amplify_core.Model {
  static const classType = const _ChatRoomModelType();
  final String id;
  final String? _name;
  final bool? _isGroupChat;
  final User? _admin;
  final List<ChatParticipant>? _participants;
  final List<Message>? _messages;
  final String? _lastMessage;
  final amplify_core.TemporalDateTime? _lastMessageTimestamp;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatRoomModelIdentifier get modelIdentifier {
      return ChatRoomModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  bool get isGroupChat {
    try {
      return _isGroupChat!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  User? get admin {
    return _admin;
  }
  
  List<ChatParticipant>? get participants {
    return _participants;
  }
  
  List<Message>? get messages {
    return _messages;
  }
  
  String? get lastMessage {
    return _lastMessage;
  }
  
  amplify_core.TemporalDateTime? get lastMessageTimestamp {
    return _lastMessageTimestamp;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ChatRoom._internal({required this.id, name, required isGroupChat, admin, participants, messages, lastMessage, lastMessageTimestamp, createdAt, updatedAt}): _name = name, _isGroupChat = isGroupChat, _admin = admin, _participants = participants, _messages = messages, _lastMessage = lastMessage, _lastMessageTimestamp = lastMessageTimestamp, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChatRoom({String? id, String? name, required bool isGroupChat, User? admin, List<ChatParticipant>? participants, List<Message>? messages, String? lastMessage, amplify_core.TemporalDateTime? lastMessageTimestamp, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return ChatRoom._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      isGroupChat: isGroupChat,
      admin: admin,
      participants: participants != null ? List<ChatParticipant>.unmodifiable(participants) : participants,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      lastMessage: lastMessage,
      lastMessageTimestamp: lastMessageTimestamp,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoom &&
      id == other.id &&
      _name == other._name &&
      _isGroupChat == other._isGroupChat &&
      _admin == other._admin &&
      DeepCollectionEquality().equals(_participants, other._participants) &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      _lastMessage == other._lastMessage &&
      _lastMessageTimestamp == other._lastMessageTimestamp &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatRoom {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("isGroupChat=" + (_isGroupChat != null ? _isGroupChat!.toString() : "null") + ", ");
    buffer.write("admin=" + (_admin != null ? _admin!.toString() : "null") + ", ");
    buffer.write("lastMessage=" + "$_lastMessage" + ", ");
    buffer.write("lastMessageTimestamp=" + (_lastMessageTimestamp != null ? _lastMessageTimestamp!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatRoom copyWith({String? name, bool? isGroupChat, User? admin, List<ChatParticipant>? participants, List<Message>? messages, String? lastMessage, amplify_core.TemporalDateTime? lastMessageTimestamp, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return ChatRoom._internal(
      id: id,
      name: name ?? this.name,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      admin: admin ?? this.admin,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  ChatRoom copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<bool>? isGroupChat,
    ModelFieldValue<User?>? admin,
    ModelFieldValue<List<ChatParticipant>?>? participants,
    ModelFieldValue<List<Message>?>? messages,
    ModelFieldValue<String?>? lastMessage,
    ModelFieldValue<amplify_core.TemporalDateTime?>? lastMessageTimestamp,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return ChatRoom._internal(
      id: id,
      name: name == null ? this.name : name.value,
      isGroupChat: isGroupChat == null ? this.isGroupChat : isGroupChat.value,
      admin: admin == null ? this.admin : admin.value,
      participants: participants == null ? this.participants : participants.value,
      messages: messages == null ? this.messages : messages.value,
      lastMessage: lastMessage == null ? this.lastMessage : lastMessage.value,
      lastMessageTimestamp: lastMessageTimestamp == null ? this.lastMessageTimestamp : lastMessageTimestamp.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  ChatRoom.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _isGroupChat = json['isGroupChat'],
      _admin = json['admin'] != null
        ? json['admin']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['admin']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['admin']))
        : null,
      _participants = json['participants']  is Map
        ? (json['participants']['items'] is List
          ? (json['participants']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatParticipant.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['participants'] is List
          ? (json['participants'] as List)
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
      _lastMessage = json['lastMessage'],
      _lastMessageTimestamp = json['lastMessageTimestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['lastMessageTimestamp']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'isGroupChat': _isGroupChat, 'admin': _admin?.toJson(), 'participants': _participants?.map((ChatParticipant? e) => e?.toJson()).toList(), 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'lastMessage': _lastMessage, 'lastMessageTimestamp': _lastMessageTimestamp?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'isGroupChat': _isGroupChat,
    'admin': _admin,
    'participants': _participants,
    'messages': _messages,
    'lastMessage': _lastMessage,
    'lastMessageTimestamp': _lastMessageTimestamp,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatRoomModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatRoomModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ISGROUPCHAT = amplify_core.QueryField(fieldName: "isGroupChat");
  static final ADMIN = amplify_core.QueryField(
    fieldName: "admin",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final PARTICIPANTS = amplify_core.QueryField(
    fieldName: "participants",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatParticipant'));
  static final MESSAGES = amplify_core.QueryField(
    fieldName: "messages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Message'));
  static final LASTMESSAGE = amplify_core.QueryField(fieldName: "lastMessage");
  static final LASTMESSAGETIMESTAMP = amplify_core.QueryField(fieldName: "lastMessageTimestamp");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatRoom";
    modelSchemaDefinition.pluralName = "ChatRooms";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["adminId", "createdAt"], name: "byAdmin")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.ISGROUPCHAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ChatRoom.ADMIN,
      isRequired: false,
      targetNames: ['adminId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ChatRoom.PARTICIPANTS,
      isRequired: false,
      ofModelName: 'ChatParticipant',
      associatedKey: ChatParticipant.CHATROOM
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ChatRoom.MESSAGES,
      isRequired: false,
      ofModelName: 'Message',
      associatedKey: Message.CHATROOM
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.LASTMESSAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.LASTMESSAGETIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ChatRoomModelType extends amplify_core.ModelType<ChatRoom> {
  const _ChatRoomModelType();
  
  @override
  ChatRoom fromJson(Map<String, dynamic> jsonData) {
    return ChatRoom.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatRoom';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatRoom] in your schema.
 */
class ChatRoomModelIdentifier implements amplify_core.ModelIdentifier<ChatRoom> {
  final String id;

  /** Create an instance of ChatRoomModelIdentifier using [id] the primary key. */
  const ChatRoomModelIdentifier({
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
  String toString() => 'ChatRoomModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatRoomModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}