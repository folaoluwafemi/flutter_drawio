part of '../toolbar_widget.dart';

class ToolBarItemWidget extends StatelessWidget {
  final ToolBarItem item;
  final bool selected;
  final bool enabled;
  final String? vectorAsset;

  const ToolBarItemWidget({
    Key? key,
    required this.item,
    required this.selected,
    required this.enabled,
    this.vectorAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.r,
      width: 24.r,
      child: SvgPicture.asset(
        vectorAsset ?? item.vectorAssetPath,
        color: selected
            ? Colors.white
            : enabled
                ? Colors.blueGrey
                : Colors.grey,
      ),
    );
  }
}
