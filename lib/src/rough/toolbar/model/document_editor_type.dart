import 'package:flutter_drawer/src/rough/toolbar/model/tool_bar_item.dart';

enum DocumentEditorType {
  general([
    ToolBarItem.undo,
    ToolBarItem.redo,
    ToolBarItem.roughPaper,
    ToolBarItem.calculator,
    ToolBarItem.pen,
    ToolBarItem.table,
    ToolBarItem.equation,
  ]),
  text([
    ToolBarItem.alignLeft,
    ToolBarItem.alignCenter,
    ToolBarItem.alignRight,
    ToolBarItem.bold,
    ToolBarItem.italic,
    ToolBarItem.color,
    ToolBarItem.subscript,
    ToolBarItem.superscript,
  ]),
  drawing([
    ToolBarItem.shapes,
    ToolBarItem.ruler,
    ToolBarItem.eraser,
    ToolBarItem.pen,
    ToolBarItem.roughPaper,
    ToolBarItem.color,
  ]),
  math([
    ToolBarItem.equation,
  ]),
  table([
    ToolBarItem.table,
  ]),
  ;

  final List<ToolBarItem> toolBarItems;

  const DocumentEditorType(this.toolBarItems);
}
