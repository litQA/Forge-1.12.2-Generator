private static int getBlockInventorySlotCount(World world, BlockPos pos) {
    TileEntity entity = world.getTileEntity(pos);
    if (entity instanceof IInventory) {
        return ((IInventory) entity).getSizeInventory();
    }

    return 0;
}
