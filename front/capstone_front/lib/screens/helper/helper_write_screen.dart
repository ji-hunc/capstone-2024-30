import 'package:capstone_front/services/helper_service.dart';
import 'package:capstone_front/utils/basic_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HelperWriteScreen extends StatefulWidget {
  const HelperWriteScreen({super.key});

  @override
  State<HelperWriteScreen> createState() => _HelperWriteScreenState();
}

class _HelperWriteScreenState extends State<HelperWriteScreen> {
  final List<String> _helperWriteList = [
    tr('helper.need_helper'),
    tr('helper.need_helpee'),
  ];
  int _selectedIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int _minLines = 1;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          tr('helper.write'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('helper.type'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      selectWriteType(context),
                      const SizedBox(height: 20),
                      Text(
                        tr('helper.title'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HelperWriteTextfield(
                        minLines: 1,
                        maxLines: 1,
                        isMultiline: false,
                        titleController: _titleController,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tr('helper.content'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HelperWriteTextfield(
                        minLines: 10,
                        maxLines: 10,
                        isMultiline: true,
                        titleController: _contentController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BasicButton(
              text: tr('helper.write_complete'),
              onPressed: () async {
                if (_titleController.text != "" &&
                    _contentController.text != "") {
                  FlutterSecureStorage storage = const FlutterSecureStorage();

                  var author = await storage.read(key: "userName");
                  var country = await storage.read(key: "userCountry");
                  var result = HelperService.createHelperPost({
                    "title": _titleController.text,
                    "author": author,
                    "country": country,
                    "context": _contentController.text,
                    "isHelper": _selectedIndex
                  });
                  Navigator.pop(context, result);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Row selectWriteType(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width - 40,
          height: 40,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            itemCount: _helperWriteList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    right: index == _helperWriteList.length - 1
                        ? 0
                        : 15), // 마지막 아이템에는 패딩을 적용하지 않음.
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? const Color(0xb4000000)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: _selectedIndex == index
                            ? Border.all(color: const Color(0x00000000))
                            : Border.all(
                                color: const Color(0xffE4E7EB),
                              )),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _helperWriteList[index],
                        style: _selectedIndex == index
                            ? const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              )
                            : const TextStyle(
                                color: Color(0xFF464D57),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HelperWriteTextfield extends StatelessWidget {
  const HelperWriteTextfield({
    super.key,
    required int minLines,
    required int maxLines,
    required bool isMultiline,
    required TextEditingController titleController,
  })  : _minLines = minLines,
        _maxLines = maxLines,
        _isMultiline = isMultiline,
        _titleController = titleController;

  final int _minLines;
  final int _maxLines;
  final bool _isMultiline;
  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: _isMultiline ? TextInputType.multiline : TextInputType.text,
      minLines: _minLines,
      maxLines: _maxLines,
      controller: _titleController,
      textInputAction:
          _isMultiline ? TextInputAction.newline : TextInputAction.next,
      onSubmitted: (value) {
        _isMultiline ? null : FocusScope.of(context).nextFocus();
      },
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE4E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(10)),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
