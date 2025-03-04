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


/** This is an auto generated class representing the Message type in your schema. */
class Message extends amplify_core.Model {
  static const classType = const _MessageModelType();
  final String id;
  final ChatRoom? _chatRoom;
  final User? _sender;
  final Group? _group;
  final String? _content;
  final String? _mediaType;
  final String? _mediaKey;
  final List<ReadReceipt>? _readReceipts;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _messageGroupId;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MessageModelIdentifier get modelIdentifier {
      return MessageModelIdentifier(
        id: id
      );
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
  
  User get sender {
    try {
      return _sender!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Group? get group {
    return _group;
  }
  
  String? get content {
    return _content;
  }
  
  String? get mediaType {
    return _mediaType;
  }
  
  String? get mediaKey {
    return _mediaKey;
  }
  
  List<ReadReceipt>? get readReceipts {
    return _readReceipts;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get messageGroupId {
    return _messageGroupId;
  }
  
  const Message._internal({required this.id, required chatRoom, required sender, group, content, mediaType, mediaKey, readReceipts, createdAt, updatedAt, messageGroupId}): _chatRoom = chatRoom, _sender = sender, _group = group, _content = content, _mediaType = mediaType, _mediaKey = mediaKey, _readReceipts = readReceipts, _createdAt = createdAt, _updatedAt = updatedAt, _messageGroupId = messageGroupId;
  
  factory Message({String? id, required ChatRoom chatRoom, required User sender, Group? group, String? content, String? mediaType, String? mediaKey, List<ReadReceipt>? readReceipts, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, String? messageGroupId}) {
    return Message._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      chatRoom: chatRoom,
      sender: sender,
      group: group,
      content: content,
      mediaType: mediaType,
      mediaKey: mediaKey,
      readReceipts: readReceipts != null ? List<ReadReceipt>.unmodifiable(readReceipts) : readReceipts,
      createdAt: createdAt,
      updatedAt: updatedAt,
      messageGroupId: messageGroupId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
      id == other.id &&
      _chatRoom == other._chatRoom &&
      _sender == other._sender &&
      _group == other._group &&
      _content == other._content &&
      _mediaType == other._mediaType &&
      _mediaKey == other._mediaKey &&
      DeepCollectionEquality().equals(_readReceipts, other._readReceipts) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      _messageGroupId == other._messageGroupId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Message {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("chatRoom=" + (_chatRoom != null ? _chatRoom!.toString() : "null") + ", ");
    buffer.write("sender=" + (_sender != null ? _sender!.toString() : "null") + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("mediaType=" + "$_mediaType" + ", ");
    buffer.write("mediaKey=" + "$_mediaKey" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("messageGroupId=" + "$_messageGroupId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Message copyWith({ChatRoom? chatRoom, User? sender, Group? group, String? content, String? mediaType, String? mediaKey, List<ReadReceipt>? readReceipts, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, String? messageGroupId}) {
    return Message._internal(
      id: id,
      chatRoom: chatRoom ?? this.chatRoom,
      sender: sender ?? this.sender,
      group: group ?? this.group,
      content: content ?? this.content,
      mediaType: mediaType ?? this.mediaType,
      mediaKey: mediaKey ?? this.mediaKey,
      readReceipts: readReceipts ?? this.readReceipts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageGroupId: messageGroupId ?? this.messageGroupId);
  }
  
  Message copyWithModelFieldValues({
    ModelFieldValue<ChatRoom>? chatRoom,
    ModelFieldValue<User>? sender,
    ModelFieldValue<Group?>? group,
    ModelFieldValue<String?>? content,
    ModelFieldValue<String?>? mediaType,
    ModelFieldValue<String?>? mediaKey,
    ModelFieldValue<List<ReadReceipt>?>? readReceipts,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<String?>? messageGroupId
  }) {
    return Message._internal(
      id: id,
      chatRoom: chatRoom == null ? this.chatRoom : chatRoom.value,
      sender: sender == null ? this.sender : sender.value,
      group: group == null ? this.group : group.value,
      content: content == null ? this.content : content.value,
      mediaType: mediaType == null ? this.mediaType : mediaType.value,
      mediaKey: mediaKey == null ? this.mediaKey : mediaKey.value,
      readReceipts: readReceipts == null ? this.readReceipts : readReceipts.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      messageGroupId: messageGroupId == null ? this.messageGroupId : messageGroupId.value
    );
  }
  
  Message.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _chatRoom = json['chatRoom'] != null
        ? json['chatRoom']['serializedData'] != null
          ? ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']['serializedData']))
          : ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']))
        : null,
      _sender = json['sender'] != null
        ? json['sender']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['sender']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['sender']))
        : null,
      _group = json['group'] != null
        ? json['group']['serializedData'] != null
          ? Group.fromJson(new Map<String, dynamic>.from(json['group']['serializedData']))
          : Group.fromJson(new Map<String, dynamic>.from(json['group']))
        : null,
      _content = json['content'],
      _mediaType = json['mediaType'],
      _mediaKey = json['mediaKey'],
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
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _messageGroupId = json['messageGroupId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'chatRoom': _chatRoom?.toJson(), 'sender': _sender?.toJson(), 'group': _group?.toJson(), 'content': _content, 'mediaType': _mediaType, 'mediaKey': _mediaKey, 'readReceipts': _readReceipts?.map((ReadReceipt? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'messageGroupId': _messageGroupId
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'chatRoom': _chatRoom,
    'sender': _sender,
    'group': _group,
    'content': _content,
    'mediaType': _mediaType,
    'mediaKey': _mediaKey,
    'readReceipts': _readReceipts,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'messageGroupId': _messageGroupId
  };

  static final amplify_core.QueryModelIdentifier<MessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CHATROOM = amplify_core.QueryField(
    fieldName: "chatRoom",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoom'));
  static final SENDER = amplify_core.QueryField(
    fieldName: "sender",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final GROUP = amplify_core.QueryField(
    fieldName: "group",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Group'));
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final MEDIATYPE = amplify_core.QueryField(fieldName: "mediaType");
  static final MEDIAKEY = amplify_core.QueryField(fieldName: "mediaKey");
  static final READRECEIPTS = amplify_core.QueryField(
    fieldName: "readReceipts",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ReadReceipt'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final MESSAGEGROUPID = amplify_core.QueryField(fieldName: "messageGroupId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Message";
    modelSchemaDefinition.pluralName = "Messages";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["chatRoomId"], name: "byChatRoom"),
      amplify_core.ModelIndex(fields: const ["senderId"], name: "byUser")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Message.CHATROOM,
      isRequired: true,
      targetNames: ['chatRoomId'],
      ofModelName: 'ChatRoom'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Message.SENDER,
      isRequired: true,
      targetNames: ['senderId'],
      ofModelName: 'User'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Message.GROUP,
      isRequired: false,
      ofModelName: 'Group',
      associatedKey: Group.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.CONTENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.MEDIATYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.MEDIAKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Message.READRECEIPTS,
      isRequired: false,
      ofModelName: 'ReadReceipt',
      associatedKey: ReadReceipt.MESSAGE
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.MESSAGEGROUPID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _MessageModelType extends amplify_core.ModelType<Message> {
  const _MessageModelType();
  
  @override
  Message fromJson(Map<String, dynamic> jsonData) {
    return Message.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Message';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Message] in your schema.
 */
class MessageModelIdentifier implements amplify_core.ModelIdentifier<Message> {
  final String id;

  /** Create an instance of MessageModelIdentifier using [id] the primary key. */
  const MessageModelIdentifier({
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
  String toString() => 'MessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}