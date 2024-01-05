import 'package:chatapp/components/chat_buble.dart';
import 'package:chatapp/components/textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageConttroller = TextEditingController();

  final ChatService _chatService = ChatService();

  final Authservice _authservice = Authservice();

  FocusNode myfocusnode = FocusNode();
  @override
  void initState() {
    super.initState();
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrolldown(),
        );
      }
    });
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    _messageConttroller.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrolldown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void SendMessage() async {
    if (_messageConttroller.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageConttroller.text);
      _messageConttroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authservice.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authservice.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: Mytextfield(
                  hintText: 'Type a message',
                  obscureText: false,
                  controller: _messageConttroller)),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: SendMessage,
              icon: const Icon(
                Icons.arrow_upward,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
