import 'package:flutter/material.dart';

class BubblePainter2 extends CustomPainter {
  final Color bubbleColor;

  BubblePainter2({this.bubbleColor = const Color(0x00ffffff)});

  @override
  void paint(Canvas canvas, Size size) {
    var bodyPaint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill; // 말풍선 본체를 채우기 위해 fill 모드 사용

    var borderPaint = Paint()
      ..color = Colors.black // 검은색 테두리
      ..style = PaintingStyle.stroke // 테두리만 그림
      ..strokeWidth = 2; // 테두리 두께 설정

    var path = Path();

    // 말풍선 본체
    path.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft: const Radius.circular(16),
        bottomRight: const Radius.circular(16),
      ),
    );

    // 말풍선 본체 그리기
    canvas.drawPath(path, bodyPaint);

    // 말풍선 테두리 그리기
    canvas.drawPath(path, borderPaint);

    // 말풍선 꼬리 (왼쪽에 그리기)
    path = Path();
    path.moveTo(2, 10); // 시작점을 말풍선의 왼쪽 가장자리 근처로 옮김
    path.lineTo(-10, 10); // 왼쪽으로 향하는 꼬리의 중간점
    path.lineTo(0, 20); // 꼬리의 끝점을 아래로 조정

    // 말풍선 꼬리 본체 그리기
    canvas.drawPath(path, bodyPaint);

    // 말풍선 꼬리 테두리 그리기
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
