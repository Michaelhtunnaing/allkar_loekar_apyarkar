import 'package:allkar_loekar_apyarkar/controller/watchlink_generate.dart';
import 'package:allkar_loekar_apyarkar/ui/watch_ui/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialog extends StatefulWidget {
  final String link;
  const MyDialog({super.key, required this.link});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final WatchGenerate controller = Get.find<WatchGenerate>();
  @override
  void initState() {
    controller.watchLinkGenerate(widget.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          height: 150,
          width: 150,
          child: GetBuilder<WatchGenerate>(
            init: WatchGenerate(),
            builder: (_) {
              if (controller.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.isSuccess) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "!Sorry Server Error",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 70, left: 100),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text("Try Again")))
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Watch Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 70, left: 100),
                        child: ElevatedButton(
                            onPressed: () {
                              print(controller.watchLink);
                              Get.to(() => MyVlcPlayer(link: controller.watchLink, iswake:false,
                                      ))!
                                  .then((value) => Get.back());
                            },
                            child: const Text("Watch Now")))
                  ],
                );
              }
            },
          )),
    );
  }
}
