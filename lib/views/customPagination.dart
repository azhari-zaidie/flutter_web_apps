import 'package:flutter/material.dart';

class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  CustomPagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final page = index + 1;
        final isCurrentPage = page == currentPage;
        return GestureDetector(
          onTap: () {
            if (!isCurrentPage) {
              onPageChanged(page);
            }
          },
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrentPage ? Colors.blue : null,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              page.toString(),
              style: TextStyle(
                color: isCurrentPage ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
