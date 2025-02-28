import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuditoriumsPage extends StatefulWidget {
  const AuditoriumsPage({super.key});
  @override
  State<AuditoriumsPage> createState() => _AuditoriumsPageState();
}

class _AuditoriumsPageState extends State<AuditoriumsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 56, 65),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 48, 56, 65),
        title: const Text(
          "Restaurants",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Get.offNamed("/central_hub");
          },
        ),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 548, 56, 65)),
                color: const Color.fromARGB(255, 58, 71, 80)),
            height: 100,
            child: const Center(
                child: Column(
              children: [
                Text(
                  "1966",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                Text(
                  "Restaurantes parac cocteles y eventos institucionales",
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Ubicado en el segundo pido del bloque F",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
          ),
        ],
      )),
    );
  }
}
