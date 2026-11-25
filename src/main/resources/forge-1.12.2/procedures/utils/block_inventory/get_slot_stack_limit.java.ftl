private static int getBlockInventorySlotStackLimit(World world, BlockPos pos, int slotId) {
    TileEntity entity = world.getTileEntity(pos);
    if (entity instanceof IInventory) {
        IInventory inventory = (IInventory) entity;
        if (slotId >= 0 && slotId < inventory.getSizeInventory()) {
            return inventory.getInventoryStackLimit();
        }
    }

    return 0;
}
