<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent instanceof IInventory) {
		IInventory _inv = (IInventory) _ent;
		final int _slotid = ${opt.toInt(input$slotid)};
		if (_slotid >= 0 && _slotid < _inv.getSizeInventory()) {
			_inv.decrStackSize(_slotid, ${opt.toInt(input$amount)});
		}
	}
}
<#-- @formatter:on -->
