import 'package:capstone_front/models/helper_article_preview_model.dart';
import 'package:capstone_front/screens/helper/helper_board/helper_writing_json.dart';
import 'package:capstone_front/screens/helper/helper_board/helper_writing_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelperWritingCard extends StatefulWidget {
  final HelperArticlePreviewModel helperArticlePreviewModel;
  final List<HelperArticlePreviewModel> helperArticlePreviewModelList;
  const HelperWritingCard({
    super.key,
    required this.helperArticlePreviewModel,
    required this.helperArticlePreviewModelList,
  });

  @override
  State<HelperWritingCard> createState() => _HelperWritingCardState();
}

class _HelperWritingCardState extends State<HelperWritingCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final int? deletedId = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HelperWritingScreen(
              widget.helperArticlePreviewModel,
            ),
          ),
        );

        if (deletedId != null) {
          setState(() {
            widget.helperArticlePreviewModelList
                .removeWhere((article) => article.id == deletedId);
          });
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 6,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.helperArticlePreviewModel.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${widget.helperArticlePreviewModel.author} | ${widget.helperArticlePreviewModel.createdDate}',
                  style: const TextStyle(
                    fontFamily: 'pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff868e96),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
