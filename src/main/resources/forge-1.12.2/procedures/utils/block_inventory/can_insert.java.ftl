public static boolean canInsertInBlockInventory(World world, BlockPos pos, int slotId, int amount, ItemStack itemstack) {
    TileEntity entity = world.getTileEntity(pos);
    if (entity instanceof IInventory) {
        IInventory inventory = (IInventory) entity;
        if (slotId >= 0 && slotId < inventory.getSizeInventory()) {
            return inventory.isItemValidForSlot(slotId, itemstack);
        }
    }

    return false;
}
