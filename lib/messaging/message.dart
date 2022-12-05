import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.messageType,
    required this.text,
    required this.isCurrentUser,
    required this.name,
    required this.time,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final String name;
  final String messageType;
  final dynamic time;

  @override
  Widget build(BuildContext context) {
    if (messageType == "left") {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
        child: Text(
          "$name left",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return Padding(
        // asymmetric padding
        padding: EdgeInsets.fromLTRB(
          isCurrentUser ? 64.0 : 16.0,
          4,
          isCurrentUser ? 16.0 : 64.0,
          4,
        ),
        child: Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DecoratedBox(
                // chat bubble decoration
                decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.indigo[300] : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                        topLeft:
                            isCurrentUser ? const Radius.circular(20) : Radius.zero,
                        topRight:
                            isCurrentUser ? Radius.zero : const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                        bottomLeft: const Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isCurrentUser
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : Text(name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(time,
                    textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        fontSize: 10,
                        color: isCurrentUser
                            ? Colors.black87
                            : Colors.black87)),
              ),
            ],
          ),
        ),
      );
    }
  }
}



