import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

//chat & auth service
  final ChatService _chatService = ChatService();
  final Authservice _authservice = Authservice();

  void logout() {
    //get auth service
    final auth = Authservice();
    auth.sigout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        } else {
          return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList());
        }
        //return list view
        // return ListView(
        //     children: snapshot.data!
        //         .map<Widget>(
        //             (userData) => _buildUserListItem(userData, context))
        //         .toList());
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all user
    if (userData['email'] != _authservice.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          //tapped on user =>chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
