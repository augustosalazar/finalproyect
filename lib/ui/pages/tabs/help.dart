import 'package:finalproyect/data/model/message.dart';
import 'package:finalproyect/ui/controllers/auth_controller.dart';
import 'package:finalproyect/ui/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class HelpTab extends StatefulWidget {
  const HelpTab({super.key, required this.arguments});

  final List<String> arguments;
  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  // controlador para el text input
  late TextEditingController _controller;
  // controlador para el sistema de scroll de la lista
  late ScrollController _scrollController;
  late String remoteUserUid;
  late String remoteEmail;

  // obtenemos las instancias de los controladores
  ChatController chatController = Get.find();
  AuthenticationController authenticationController = Get.find();
  @override
  void initState() {
    super.initState();

    remoteUserUid = widget.arguments[0];
    remoteEmail = widget.arguments[1];

    // instanciamos los controladores
    _controller = TextEditingController();
    _scrollController = ScrollController();

    // Le pedimos al chatController que se suscriba los chats entre los dos usuarios
    chatController.subscribeToUpdated(remoteUserUid);
  }

  @override
  void dispose() {
    // proceso de limpieza
    _controller.dispose();
    _scrollController.dispose();
    chatController.unsubscribe();
    super.dispose();
  }

  Widget _item(Message element, int posicion, String uid) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      // cambiamos el color dependiendo de quién mandó el usuario
      color: uid == element.senderUid
          ? const Color.fromARGB(255, 48, 56, 65)
          : Colors.black,
      child: ListTile(
        title: Text(
          style: const TextStyle(color: Colors.white),
          element.msg,
          textAlign:
              // cambiamos el textAlign dependiendo de quién mandó el usuario
              uid == element.senderUid ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _list() {
    String uid = authenticationController.getUid();
    logInfo('Current user $uid');
    // Escuchamos la lista de mensajes entre los dos usuarios usando el ChatController
    return GetX<ChatController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      return ListView.builder(
        itemCount: chatController.messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var element = chatController.messages[index];
          return _item(element, index, uid);
        },
      );
    });
  }

  Future<void> _sendMsg(String text) async {
    // enviamos un nuevo mensaje usando el ChatController
    logInfo("Calling _sendMsg with $text");
    await chatController.sendChat(remoteUserUid, text);
  }

  Widget _textInput() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: TextField(
              key: const Key('MsgTextField'),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                labelText: 'Your message',
                labelStyle: TextStyle(color: Colors.white),
                floatingLabelStyle: TextStyle(color: Colors.white),
                counterStyle: TextStyle(color: Colors.white),
                fillColor: Color.fromARGB(255, 58, 71, 80),
                hoverColor: Color.fromARGB(255, 58, 71, 80),
                focusColor: Color.fromARGB(255, 58, 71, 80),
                iconColor: Color.fromARGB(255, 58, 71, 80),
                prefixIconColor: Color.fromARGB(255, 58, 71, 80),
                suffixIconColor: Color.fromARGB(255, 58, 71, 80),
              ),
              cursorColor: Colors.white,
              onSubmitted: (value) {
                if (_controller.text.isNotEmpty &
                    !stringVacio(_controller.text)) {
                  _sendMsg(_controller.text);
                  _controller.clear();
                }
              },
              controller: _controller,
            ),
          ),
        ),
        TextButton(
            key: const Key('sendButton'),
            child: const Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_controller.text.isNotEmpty &
                  !stringVacio(_controller.text)) {
                _sendMsg(_controller.text);
                _controller.clear();
              }
            })
      ],
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 58, 71, 80),
          title: const Text("Chat with Support",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        backgroundColor: const Color.fromARGB(255, 58, 71, 80),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
          child: Column(
            children: [Expanded(flex: 4, child: _list()), _textInput()],
          ),
        ));
  }
}

bool stringVacio(String cadena) {
  return cadena.trim().isEmpty;
}
