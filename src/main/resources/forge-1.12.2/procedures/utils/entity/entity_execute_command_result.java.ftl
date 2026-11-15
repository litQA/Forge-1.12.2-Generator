<@addTemplate file="utils/entity/entity_execute_command.java.ftl"/>
private static String executeCommandGetResult(Entity entity, String command) {
	StringBuilder result = new StringBuilder();
	if(!entity.world.isRemote && entity.getMinecraftServer() != null) {
		ICommandSender dataConsumer = new ICommandSender() {
			@Override public String getName() {
				return entity.getName();
			}

			@Override public boolean canUseCommand(int permission, String command) {
				return true;
			}

			@Override public World getEntityWorld() {
				return entity.world;
			}

			@Override public MinecraftServer getServer() {
				return entity.world.getMinecraftServer();
			}

			@Override public void sendMessage(ITextComponent message) {
				result.append(message.getUnformattedText());
			}
		};
		entity.getMinecraftServer().getCommandManager().executeCommand(dataConsumer, command);
	}
	return result.toString();
}