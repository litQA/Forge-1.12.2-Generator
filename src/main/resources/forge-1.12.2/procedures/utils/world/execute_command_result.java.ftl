<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
private static String executeCommandGetResult(World world, double posX, double posY, double posZ, String command) {
	if (command.startsWith("data get block ")) {
		TileEntity tile = world.getTileEntity(new BlockPos(posX, posY, posZ));
		if (tile instanceof IInventory) {
			IInventory inventory = (IInventory) tile;
			for (int i = 0; i < inventory.getSizeInventory(); i++) {
				ItemStack stack = inventory.getStackInSlot(i);
				if (!stack.isEmpty()) {
					ResourceLocation id = stack.getItem().getRegistryName();
					String result = "{count: " + stack.getCount() + ", id: \"" + (id == null ? "minecraft:air" : id.toString()) + "\"}";
					return result;
				}
			}
		}
		return "{count: 0, id: \"minecraft:air\"}";
	}
	if (command.startsWith("data remove block ")) {
		return "";
	}
	StringBuilder result = new StringBuilder();
	if (world instanceof WorldServer) {
		ICommandSender dataConsumer = executeCommand(world, posX, posY, posZ);
		world.getMinecraftServer().getCommandManager().executeCommand(dataConsumer, command);
	}
	return result.toString();
}