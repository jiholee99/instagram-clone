import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:intl/intl.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String username;
  final String description;
  const ExpandableTextWidget({required this.username, required this.description, Key? key}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableAnimationState();
}

class _ExpandableAnimationState extends State<ExpandableTextWidget> with SingleTickerProviderStateMixin {
  var height = 30.0;
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<String> splittedText = widget.description.split('\n');
    /*
    print("**************************************************");
    print("Original text: ${widget.description}");
    print("Splitted text : ${splittedText}");
    print("**************************************************");
    */

    return AnimatedSize(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
        child: _isExpanded
            ? RichText(
                text: TextSpan(children: [
                TextSpan(text: widget.username + " ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.description)
              ]))
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: constraints.maxWidth - (widget.username.length * 10),
                          child: AutoSizeText(
                            widget.description,
                            minFontSize: 14,
                            maxLines: 1,
                            overflowReplacement: InkWell(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                "...more",
                                style: commentFunctionStyle,
                              ),
                            ),
                          ))
                    ],
                  );
                },
              ));
  }
}
