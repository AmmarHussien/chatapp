import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/users/user_list.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Chat App',
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: SizedBox(
                  child: Row(children: const [
                    Icon(
                      Icons.exit_to_app,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Logout',
                    ),
                  ]),
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: const UserList(),
    );
  }
}
