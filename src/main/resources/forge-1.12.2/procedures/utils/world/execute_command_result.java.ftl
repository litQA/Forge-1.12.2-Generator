<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
private static String executeCommandGetResult(World world, double posX, double posY, double posZ, String command) {
	StringBuilder result = new StringBuilder();
	if (world instanceof WorldServer) {
		ICommandSender dataConsumer = executeCommand(world, posX, posY, posZ);
		world.getMinecraftServer().getCommandManager().executeCommand(dataConsumer, command);
	}
	return result.toString();
}