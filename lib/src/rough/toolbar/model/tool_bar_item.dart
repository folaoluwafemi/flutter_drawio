import 'package:flutter_drawer/src/rough/toolbar/model/toolbar_item_position.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';

enum ToolBarItem {
  pen(ToolBarItemPosition.top, VectorAssets.penIcon),
  eraser(ToolBarItemPosition.top, VectorAssets.eraserIcon),
  ruler(ToolBarItemPosition.top, VectorAssets.rulerIcon),
  shapes(ToolBarItemPosition.top, VectorAssets.shapesIcon),
  calculator(ToolBarItemPosition.top, VectorAssets.calculatorIcon),
  table(ToolBarItemPosition.top, VectorAssets.tableIcon),
  fourFigTable(ToolBarItemPosition.top, VectorAssets.fourFigTableIcon),
  color(ToolBarItemPosition.top, VectorAssets.textColorIcon),
  undo(ToolBarItemPosition.top, VectorAssets.undoIcon),
  redo(ToolBarItemPosition.top, VectorAssets.redoIcon),

  ///
  alignLeft(ToolBarItemPosition.bottom, VectorAssets.alignLeftIcon),
  alignCenter(ToolBarItemPosition.bottom, VectorAssets.alignCenterIcon),
  alignRight(ToolBarItemPosition.bottom, VectorAssets.alignRightIcon),
  bold(ToolBarItemPosition.bottom, VectorAssets.boldIcon),
  italic(ToolBarItemPosition.bottom, VectorAssets.italicIcon),
  underline(ToolBarItemPosition.bottom, VectorAssets.underlineIcon),
  equation(ToolBarItemPosition.bottom, VectorAssets.squareRootIcon),
  subscript(ToolBarItemPosition.bottom, VectorAssets.subscriptIcon),
  superscript(ToolBarItemPosition.bottom, VectorAssets.superscriptIcon),
  roughPaper(ToolBarItemPosition.bottom, VectorAssets.roughPaperIcon),
  ;

  final ToolBarItemPosition position;
  final String vectorAssetPath;

  const ToolBarItem(this.position, this.vectorAssetPath);
}
