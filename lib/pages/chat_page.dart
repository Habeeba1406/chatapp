import 'package:chatapp/components/chat_buble.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat&auth service
  final ChatService _chatService = ChatService();
  final Authservice _authservice = Authservice();

  //for tctfield focus
  FocusNode myfocusnode = FocusNode();
  @override
  void initState() {
    super.initState();

    //add listener to focus node
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrolldown(),
        );
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrolldown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

//send msg
  void sendmessage() async {
    //if there is something inside the txtfld
    if (_messageController.text.isNotEmpty) {
      //snd the msg
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrolldown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        //display all msg
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
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
          //error
          if (snapshot.hasError) {
            return const Text('Error');
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          //return listview
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //build msg item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //current user
    bool isCurrentUser = data['senderID'] == _authservice.getCurrentUser()!.uid;
    //align msg -> user -right,otherwise -left
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

  //build msg input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: 'Type a message',
              obscureText: false,
              controller: _messageController,
              focusNode: myfocusnode,
            ),
          ),
          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendmessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
