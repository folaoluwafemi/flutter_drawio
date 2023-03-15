part of '../toolbar_widget.dart';

class ToolbarItemButton extends StatelessWidget {
  final ToolBarItem item;
  final bool selected;
  final bool enabled;
  final String? vectorAssetPath;
  final ValueChanged<ToolBarItem> onSelected;

  const ToolbarItemButton({
    Key? key,
    required this.item,
    required this.selected,
    required this.onSelected,
    required this.enabled,
    this.vectorAssetPath,
  }) : super(key: key);

  void onPressed() => onSelected(item);

  @override
  Widget build(BuildContext context) {
    final ToolBarItemWidget child = ToolBarItemWidget(
      item: item,
      selected: selected,
      enabled: enabled,
      vectorAsset: vectorAssetPath,
    );

    return selected
        ? MaterialButton(
            minWidth: 42.h,
            height: 42.h,
            color: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: Ui.allBorderRadius(4)),
            onPressed: onPressed,
            child: child,
          )
        : MaterialButton(
            minWidth: 42.w,
            height: 42.h,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: Ui.allBorderRadius(4)),
            onPressed: enabled ? onPressed : null,
            child: child,
          );
  }
}
