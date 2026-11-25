<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent instanceof IInventory) {
		IInventory _inv = (IInventory) _ent;
		final int _slotid = ${opt.toInt(input$slotid)};
		if (_slotid >= 0 && _slotid < _inv.getSizeInventory()) {
			ItemStack _stk = _inv.getStackInSlot(_slotid).copy();
			if (!_stk.isEmpty() && _stk.attemptDamageItem(${opt.toInt(input$amount)}, new Random(), null)) {
				_stk.shrink(1);
				_stk.setItemDamage(0);
			}
			_inv.setInventorySlotContents(_slotid, _stk);
		}
	}
}
<#-- @formatter:on -->
