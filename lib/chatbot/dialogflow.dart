import 'package:esprit/static.dart';
import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart' as df;
import 'package:flutter/material.dart';
import 'package:esprit/Home/AppTheme/appthemeColors.dart';
import 'package:esprit/SizeConfig.dart';

class ChatbotDialogflow extends StatefulWidget {
  ChatbotDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatbotDialogflowState createState() => new _ChatbotDialogflowState();
}

class _ChatbotDialogflowState extends State<ChatbotDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                style:
                    TextStyle(fontSize: 18.0, height: 1.7, color: Colors.black),
                decoration: new InputDecoration.collapsed(
                    hintText: '    Send a message'),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 5.0),
              child: new IconButton(
                  icon: new Icon(Icons.send_rounded),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void response(query) async {
    _textController.clear();
    df.AuthGoogle authGoogle =
        await df.AuthGoogle(fileJson: 'assets/images/learnly.json').build();
    df.Dialogflow dialogflow =
        df.Dialogflow(authGoogle: authGoogle, sessionId: '1234566');
    df.DetectIntentResponse response =
        await dialogflow.detectIntentFromText(query, "id");
    ChatMessage message = new ChatMessage(
      text: response.queryResult.fulfillmentText,
      name: 'LearnlyBot',
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: Userutils.name,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Welcome to Learnly Smart Chatbot",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  fontSize: 2.5 * SizeConfig1.textMultiplier,
                  color: AppThemeColors.darkBlue))),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
          backgroundImage: AssetImage("assets/images/bot.png"),
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // ignore: deprecated_member_use
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            backgroundImage: AssetImage("assets/images/defaultpic.png")),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
