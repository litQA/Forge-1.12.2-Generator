private static ItemStack getItemStackFromItemStackSlot(int slotID, ItemStack itemStack) {
	if (itemStack.getItem() instanceof IInventory) {
		IInventory inventory = (IInventory) itemStack.getItem();
		if (slotID >= 0 && slotID < inventory.getSizeInventory()) {
			return inventory.getStackInSlot(slotID).copy();
		}
	}

	return ItemStack.EMPTY;
}
