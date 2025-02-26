// class Message {
//   String? messageId;
//   String? fromUserId;
//   String? toUserId;
//   String? textMessage;
//   DateTime? sendAt;
//   String? type;
//   bool? isSendNotification;

//   Message({
//     this.fromUserId,
//     this.messageId,
//     this.sendAt,
//     this.textMessage,
//     this.toUserId,
//     this.type,
//     this.isSendNotification,
//   });

//   Message.fromJson(json, id) {
//     this.messageId = id;
//     this.fromUserId = json["fromUserId"];
//     this.toUserId = json["toUserId"];
//     this.textMessage = json["textMessage"] ?? "";
//     this.sendAt = json["sendAt"].toDate();
//     this.type = json["type"];
//   }

//   toJson() {
//     return {
//       "fromUserId": this.fromUserId,
//       "toUserId": this.toUserId,
//       "textMessage": this.textMessage,
//       "sendAt": this.sendAt,
//       "type": this.type,
//       "isSendNotification": this.isSendNotification,
//     };
//   }
// }
