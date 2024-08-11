import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List messages = [
    {"message": "hello", "type": "user"},
    {"message": "how can i help you", "type": "assistant"}
  ];

  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "chat bot",
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          messages[index]['message'],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      String query = queryController.text;
                      //api.openai.com/v1/chat/completions
                      var openaiUri =
                          Uri.https("api.openai.com", "/v1/chat/completions");
                      Map<String, String> headres = {
                        "Content-Type": "application/json",
                        "Authorization": "Bearer "
                      };

                      var prompt = {
                        "model": "gpt-4o",
                        "messages": [
                          {"role": "user", "content": query}
                        ],
                        "temperature": 0
                      };
                      http
                          .post(openaiUri,
                              headers: headres, body: json.encode(prompt))
                          .then((result) {
                        var llmResponse = json.decode(result.body);
                        var responseContent =
                            llmResponse['choices'][0]['message']['content'];
                        setState(() {
                          messages.add({"message": query, "type": "user"});
                          messages.add({
                            "message": responseContent,
                            "type": "assistant"
                          });
                        });
                      }, onError: (error) {
                        print(("+++++++++ error +++++++++"));
                        print(error);
                      });
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
