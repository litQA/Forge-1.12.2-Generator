<#include "mcitems.ftl">
{
	final int _slotid = ${opt.toInt(input$slotid)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	IInventory _inv = getEntityInventory(${input$entity});
	if (_inv != null && _slotid >= 0 && _slotid < _inv.getSizeInventory()) {
		_inv.setInventorySlotContents(_slotid, _setstack);
	}
}
