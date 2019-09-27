import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  runApp(MyApp());
}

//Criação de temas p/ IOS e Android
final ThemeData KIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);
final ThemeData KDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400]
);

// Autenticação para o login
final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

//função para verificar se o usuario esta logado
Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser; //pega usuario atual logado
  //autentica user no google
  if(user == null)
    user = await googleSignIn.signInSilently();
  if(user == null)
    user = await googleSignIn.signIn();
  //autentica user no Firebase
  if(await auth.currentUser() == null){
    GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS ? //identifica o sistema e seta o tema
        KIOSTheme : KDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(   //SafeArea ignora ou nao o not ou a barra em baixo do iphone true ignora false nao
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
          centerTitle: true,
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0, //verificação do sistema para setar elevação da appBar
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ChatMessage()
                ],
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ?
          BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]))
          ) :
          null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: (){},
              ),
            ),
            Expanded(   //Expanded utiliza o espaço disponivel
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: "Enviar mensagem"),
                onChanged: (text){  //verifica se o campo de text tem caracteris para habilitar o btn de enviar
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?
                CupertinoButton(
                  child: Text("Enviar"),
                  onPressed: _isComposing ?
                  (){}
                  : null,
                )
                  : IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing ?
                (){}
                : null,
              )
            )
          ],
        ),
      ),
    );
  }
}

//widget q tera a imagem, nome e texto da mensagem
class ChatMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,   //alinha itens a esquerda
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            height: 20.0,
            width: 20.0,
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://www.publicdomainpictures.net/pictures/190000/nahled/young-business-woman-1470305665A9g.jpg",),
            ),
          ),
          Expanded(  //ocupa o maior espaço possivel
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Carlinhos",
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text("Ola, como vai?"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



