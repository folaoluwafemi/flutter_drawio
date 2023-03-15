import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/rough/toolbar/controller/toolbar_controller.dart';
import 'package:flutter_drawer/src/rough/toolbar/model/document_editor_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/global/ui/ui_barrel.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';
import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/rough/toolbar/model/tool_bar_item.dart';
import 'package:flutter_drawer/src/rough/toolbar/model/toolbar_item_position.dart';
import 'package:flutter_drawer/src/rough/widgets/base_controller.dart';
import 'package:flutter_drawer/src/rough/widgets/drawing_controller.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';


part 'custom/color_wheel_dialog.dart';

part 'custom/hue_slider.dart';

part 'custom/knob.dart';

part 'custom/main_color_slider.dart';

part 'custom/shape_selector_dialog.dart';

part 'custom/tool_bar_item_widget.dart';

part 'custom/toolbar_item_button.dart';

part 'custom/transparency_slider.dart';

class ToolBarWidget extends StatefulWidget {
  final ToolbarController controller;

  const ToolBarWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ToolBarWidget> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBarWidget> {
  final List<ToolBarItem> topItems = ToolBarItem.values.where((element) {
    return element.position == ToolBarItemPosition.top;
  }).toList();

  final List<ToolBarItem> bottomItems = ToolBarItem.values.where((element) {
    return element.position == ToolBarItemPosition.bottom;
  }).toList();

  ToolbarController get controller {
    return widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 902.w,
          // height: 128.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Ui.allBorderRadius(8),
          ),
          child: ValueListenableBuilder<DocumentEditorType>(
            valueListenable: documentEditorTypeNotifier,
            builder: (_, documentEditorType, __) {
              return ValueListenableBuilder<List<ToolBarItem>>(
                valueListenable: selectedItemsNotifier,
                builder: (_, selectedItems, __) {
                  return ChangeNotifierBuilder<ToolbarController>(
                    listenable: controller,
                    builder: (_, controllerValue) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...topItems.map(
                                  (item) {
                                    bool enabled = DocumentEditorType
                                            .general.toolBarItems
                                            .contains(item) ||
                                        documentEditorType.toolBarItems
                                            .contains(item);

                                    if (item == ToolBarItem.undo) {
                                      enabled = controllerValue.canUndo;
                                    }
                                    if (item == ToolBarItem.redo) {
                                      enabled = controllerValue.canRedo;
                                    }

                                    final bool selected =
                                        selectedItems.contains(item);

                                    if (item == ToolBarItem.pen) {
                                      return documentEditorType ==
                                              DocumentEditorType.text
                                          ? ToolbarItemButton(
                                              item: item,
                                              selected: selected,
                                              enabled: enabled,
                                              vectorAssetPath:
                                                  VectorAssets.textIcon,
                                              onSelected: onSelected,
                                            )
                                          : ToolbarItemButton(
                                              item: item,
                                              selected: selected,
                                              enabled: enabled,
                                              vectorAssetPath:
                                                  VectorAssets.penIcon,
                                              onSelected: onSelected,
                                            );
                                    }

                                    return ToolbarItemButton(
                                      item: item,
                                      enabled: enabled,
                                      onSelected: onSelected,
                                      selected: selected,
                                    );
                                  },
                                )
                              ],
                            ),
                            11.boxHeight,
                            const Divider(
                              color: Colors.grey,
                              height: 1,
                              thickness: 1,
                            ),
                            11.boxHeight,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...bottomItems.map(
                                  (item) => ToolbarItemButton(
                                    item: item,
                                    enabled: DocumentEditorType
                                            .general.toolBarItems
                                            .contains(item) ||
                                        documentEditorType.toolBarItems
                                            .contains(item),
                                    onSelected: onSelected,
                                    selected: selectedItems.contains(item),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        32.boxWidth,
        Align(
          alignment: Alignment.centerRight,
          child: ValueListenableBuilder<ToolItemSelector>(
            valueListenable: toolItemSelectorNotifier,
            builder: (_, selector, __) {
              switch (selector) {
                case ToolItemSelector.shape:
                  return ShapeSelector(
                    onClose: closeToolItemSelector,
                    shape: controller.drawingController.shape,
                    onChanged: onShapeChanged,
                  );
                case ToolItemSelector.color:
                  return ColorSelector(
                    onClose: closeToolItemSelector,
                    color: controller.color,
                    onChanged: onColorChanged,
                  );
                case ToolItemSelector.none:
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  final DrawingController newDrawingController = DrawingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.addListener(controllerListener);
    onSelected(ToolBarItem.pen);
  }

  @override
  void didUpdateWidget(covariant ToolBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(controllerListener);
      controller.addListener(controllerListener);
    }
  }

  void changeShapeSelectionByController() {
    final DrawingMode currentDrawingMode =
        controller.drawingController.drawingMode;
    if (currentDrawingMode != DrawingMode.shape &&
        selectedItemsNotifier.value.contains(ToolBarItem.shapes)) {
      selectedItemsNotifier.value = List.from(selectedItemsNotifier.value)
        ..remove(ToolBarItem.shapes);
    }
    if (currentDrawingMode == DrawingMode.shape &&
        !selectedItemsNotifier.value.contains(ToolBarItem.shapes)) {
      selectedItemsNotifier.value = List.from(selectedItemsNotifier.value)
        ..add(ToolBarItem.shapes);
    }
  }

  void controllerListener() {
    if (documentEditorTypeNotifier.value == DocumentEditorType.drawing) {
      changeShapeSelectionByController();
    }
  }

  void closeToolItemSelector() => showSelector(ToolItemSelector.none);

  void redo() {
    controller.redo();
  }

  void undo() {
    controller.undo();
  }

  void showSelector(ToolItemSelector selector) {
    toolItemSelectorNotifier.value = selector;
  }

  void onSelected(ToolBarItem item) {
    if (item == ToolBarItem.undo) return undo();
    if (item == ToolBarItem.redo) return redo();

    if (item == ToolBarItem.pen) {
      documentEditorTypeNotifier.value =
          documentEditorTypeNotifier.value == DocumentEditorType.drawing
              ? DocumentEditorType.text
              : () {
                  performDrawingAction(ToolBarItem.pen);
                  return DocumentEditorType.drawing;
                }();
      clearSelectedItems();
      return;
    }

    if (item == ToolBarItem.color) {
      showSelector(ToolItemSelector.color);
      return;
    }

    if (selectedItemsNotifier.value.contains(item)) {
      if (item == ToolBarItem.shapes &&
          toolItemSelectorNotifier.value == ToolItemSelector.shape) {
        closeToolItemSelector();
      }

      if (DocumentEditorType.drawing.toolBarItems.contains(item)) {
        (item == ToolBarItem.pen &&
                documentEditorTypeNotifier.value == DocumentEditorType.text)
            ? null
            : reverseDrawingAction();
      }

      selectedItemsNotifier.value = List.from(selectedItemsNotifier.value)
        ..remove(item);
      return;
    }
    if (item == ToolBarItem.table) {
      documentEditorTypeNotifier.value = DocumentEditorType.table;
      addItemToSelected(item);
      return;
    }
    if (item == ToolBarItem.equation) {
      documentEditorTypeNotifier.value = DocumentEditorType.math;
      addItemToSelected(item);
      return;
    }

    final DocumentEditorType documentType = documentEditorTypeNotifier.value;

    switch (documentType) {
      case DocumentEditorType.general:
        return;
      case DocumentEditorType.drawing:
        {
          performDrawingAction(item);
          continue continuation;
        }
      continuation:
      case DocumentEditorType.math:
      case DocumentEditorType.table:
      case DocumentEditorType.text:
        {
          if (!documentType.toolBarItems.contains(item)) return;
          break;
        }
    }

    addItemToSelected(item);
  }

  void onColorChanged(Color color) {
    controller.dispatchColorChange(color);
  }

  void onShapeChanged(Shape shape) {
    controller.drawingController.changeShape(shape);
  }

  void reverseDrawingAction() {
    controller.drawingController.changeDrawingMode(DrawingMode.sketch);
  }

  void addItemToSelected(ToolBarItem item) {
    clearSelectedItems();
    selectedItemsNotifier.value = List.from(selectedItemsNotifier.value)
      ..add(item);
  }

  void clearSelectedItems() {
    final List<ToolBarItem> items = List.from(selectedItemsNotifier.value);
    final List<ToolBarItem> generalItems = items.where((element) {
      return DocumentEditorType.general.toolBarItems.contains(element);
    }).toList();

    items.clear();

    items.addAll(generalItems);
    selectedItemsNotifier.value = generalItems;
  }

  final Map<ToolBarItem, DrawingMode> toolbarItemToDrawingMode = {
    ToolBarItem.pen: DrawingMode.sketch,
    ToolBarItem.eraser: DrawingMode.erase,
    ToolBarItem.shapes: DrawingMode.shape,
    ToolBarItem.ruler: DrawingMode.line,
  };

  final Map<DrawingMode, ToolBarItem> drawingModeToToolbarItem = {
    DrawingMode.sketch: ToolBarItem.pen,
    DrawingMode.erase: ToolBarItem.eraser,
    DrawingMode.shape: ToolBarItem.shapes,
    DrawingMode.line: ToolBarItem.ruler,
  };

  void performDrawingAction(ToolBarItem item) {
    if (toolbarItemToDrawingMode[item] == null) return;
    final DrawingMode drawingAction = toolbarItemToDrawingMode[item]!;
    controller.drawingController.changeDrawingMode(drawingAction);
    if (drawingAction == DrawingMode.shape) {
      showSelector(ToolItemSelector.shape);
    }
  }

  final ValueNotifier<List<ToolBarItem>> selectedItemsNotifier =
      ValueNotifier<List<ToolBarItem>>(
    [],
  );

  Future showDialogPop() async {
    // showDialog(context: context, builder: builder )
  }

  final ValueNotifier<DocumentEditorType> documentEditorTypeNotifier =
      ValueNotifier<DocumentEditorType>(
    DocumentEditorType.drawing,
  );

  final ValueNotifier<ToolItemSelector> toolItemSelectorNotifier =
      ValueNotifier<ToolItemSelector>(
    ToolItemSelector.none,
  );

  @override
  void dispose() {
    super.dispose();
    selectedItemsNotifier.dispose();
    toolItemSelectorNotifier.dispose();
    documentEditorTypeNotifier.dispose();
  }
}

enum ToolItemSelector {
  none,
  shape,
  color,
  ;
}
