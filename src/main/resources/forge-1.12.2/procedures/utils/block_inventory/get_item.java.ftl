private static ItemStack itemFromBlockInventory(World world, BlockPos pos, int slot) {
    TileEntity entity = world.getTileEntity(pos);
    if (entity instanceof IInventory) {
        IInventory inventory = (IInventory) entity;
        if (slot >= 0 && slot < inventory.getSizeInventory()) {
            return inventory.getStackInSlot(slot);
        }
    }

    return ItemStack.EMPTY;
}
