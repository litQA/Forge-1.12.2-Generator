<#include "mcitems.ftl">
{
	ItemStack _isc = ${mappedMCItemToItemStackCode(input$item, 1)};
	final int _sltid = ${opt.toInt(input$slotid)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	if (_isc.getItem() instanceof IInventory) {
		IInventory _inv = (IInventory) _isc.getItem();
		if (_sltid >= 0 && _sltid < _inv.getSizeInventory()) {
			_inv.setInventorySlotContents(_sltid, _setstack);
		}
	}
}
