<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
{
	String __mcreatorCommand = ${input$command};
	if (world instanceof WorldServer && !__mcreatorCommand.startsWith("data get block ") && !__mcreatorCommand.startsWith("data remove block "))
		world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(world, ${input$x}, ${input$y}, ${input$z}), __mcreatorCommand);
}