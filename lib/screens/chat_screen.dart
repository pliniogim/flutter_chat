import 'package:flutter/material.dart';
import 'package:flutter_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//global
final _fcloud = FirebaseFirestore.instance;
late User loggedIn;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  initState() {
    super.initState();
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  final textMessageController = TextEditingController();

  void getCurrentUser() {
    try {
      final User? usuario = _auth.currentUser;
      if (usuario != null) {
        loggedIn = usuario;
        //print(loggedIn?.email);
      }
    } catch (e) {
      //print(e);
    }
  }

  late String messageText;

  //check new messages each time
  // void getMessages() async {
  //   final messages = await _fcloud.collection('messages').get();
  //   for(var message in messages.docs){
  //       print(message.data());
  //   }
  // }

  void messagesStream() async {
    _fcloud.collection('messages').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //messagesStream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textMessageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //bco messages fields text sender
                      //Implement send functionality.
                      textMessageController.clear();
                      _fcloud.collection('messages').add(
                          {'text': messageText, 'sender': loggedIn.email});
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fcloud.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          final messages = snapshot.data!.docs.reversed;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = loggedIn.email;

            final messageBubble = MessageBubble(
              messageSender: messageSender,
              messageText: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String? messageText;
  final String? messageSender;
  final bool isMe;

  const MessageBubble(
      {Key? key, this.messageText, this.messageSender, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
        Text(
          '$messageSender',
          style: const TextStyle(fontSize: 12.0),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Material(
          elevation: 10.0,
          borderRadius: BorderRadius.only(
            topRight: isMe ? const Radius.circular(1.0) : const Radius.circular(20.0),
            topLeft: isMe ? const Radius.circular(20) : const Radius.circular(1.0),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          color: isMe ? Colors.lightBlue : Colors.purpleAccent,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text(
              '$messageText',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
