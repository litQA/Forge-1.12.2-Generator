{
	IInventory _inv = getEntityInventory(${input$entity});
	if (_inv != null) {
		for (int _idx = 0; _idx < _inv.getSizeInventory(); _idx++) {
			ItemStack itemstackiterator = _inv.getStackInSlot(_idx).copy();
			${statement$foreach}
		}
	}
}
