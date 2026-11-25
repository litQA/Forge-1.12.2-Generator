<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent instanceof IInventory) {
		IInventory _inv = (IInventory) _ent;
		final int _slotid = ${opt.toInt(input$slotid)};
		if (_slotid >= 0 && _slotid < _inv.getSizeInventory()) {
			final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
			_setstack.setCount(${opt.toInt(input$amount)});
			_inv.setInventorySlotContents(_slotid, _setstack);
		}
	}
}
<#-- @formatter:on -->
