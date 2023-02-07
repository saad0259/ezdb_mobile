import 'package:flutter/material.dart';

class NumPad extends StatelessWidget {
  final void Function(String) onUpdate;
  final void Function() onSubmit;
  final void Function() onClear;
  final bool useBack;
  final bool isLoading;

  const NumPad({
    Key? key,
    required this.onUpdate,
    required this.onSubmit,
    required this.onClear,
    this.useBack = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int i) {
          //to loop from 1 to 12
          int index = i + 1;
          index = index == 11 ? 0 : index; // zero for middle bottom
          return index <= 12
              ? InkWell(
                  customBorder: const CircleBorder(),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.grey[100],
                    ),
                    child: Center(
                      child: index == 10
                          ? const Icon(
                              Icons.close,
                              size: 22,
                            )
                          : index == 12
                              ? isLoading
                                  ? const CircularProgressIndicator()
                                  : const Icon(
                                      Icons.check,
                                      size: 22,
                                    )
                              : Text(
                                  "$index",
                                  style: const TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 18,
                                  ),
                                ),
                    ),
                  ),
                  onTap: () {
                    if (index == 10) {
                      onClear();
                    } else if (index == 12) {
                      onSubmit();
                    } else {
                      onUpdate("$index");
                    }
                  },
                )
              : const SizedBox();
        },
      ),
    );
  }
}
