<#-- @formatter:off -->
package ${package}.command;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.minecraft.command.CommandBase;
import net.minecraft.command.CommandException;
import net.minecraft.command.ICommandSender;
import net.minecraft.entity.Entity;
import net.minecraft.server.MinecraftServer;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.event.FMLServerStartingEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

<#if data.type == "CLIENTSIDE">
@net.minecraftforge.fml.relauncher.SideOnly(net.minecraftforge.fml.relauncher.Side.CLIENT)
<#else>
@Mod.EventBusSubscriber
</#if>
public class ${name}Command extends CommandBase {

	<#if data.type != "CLIENTSIDE">
	@SubscribeEvent
	public static void registerCommand(FMLServerStartingEvent event) {
		<#if data.type == "MULTIPLAYER_ONLY">
		if (event.getServer().isDedicatedServer())
			event.registerServerCommand(new ${name}Command());
		<#elseif data.type == "SINGLEPLAYER_ONLY">
		if (!event.getServer().isDedicatedServer())
			event.registerServerCommand(new ${name}Command());
		<#else>
		event.registerServerCommand(new ${name}Command());
		</#if>
	}
	</#if>

	<#if data.type == "CLIENTSIDE">
	public static void registerClientCommand() {
		net.minecraftforge.client.ClientCommandHandler.instance.registerCommand(new ${name}Command());
	}
	</#if>

	@Override
	public String getName() {
		return "${data.commandName}";
	}

	@Override
	public String getUsage(ICommandSender sender) {
		return "/${data.commandName}";
	}

	@Override
	public int getRequiredPermissionLevel() {
		return <#if data.permissionLevel == "No requirement">0<#else>${data.permissionLevel}</#if>;
	}

	@Override
	public void execute(MinecraftServer server, ICommandSender arguments, String[] args) throws CommandException {
		World world = arguments.getEntityWorld();
		double x = arguments.getPosition().getX();
		double y = arguments.getPosition().getY();
		double z = arguments.getPosition().getZ();
		Entity entity = arguments.getCommandSenderEntity();
		net.minecraft.util.EnumFacing direction = net.minecraft.util.EnumFacing.DOWN;
		if (entity != null)
			direction = entity.getHorizontalFacing();

		Map<String, String> cmdparams = new HashMap<>();
		for (int i = 0; i < args.length; i++)
			cmdparams.put(Integer.toString(i), args[i]);

		${argscode}

		// The 2026.3 command argument editor emits Brigadier syntax. The 1.12.2
		// backend exposes the shared x/y/z/world/entity/direction/cmdparams
		// variables and supports the call-procedure block.
	}

	@Override
	public List<String> getTabCompletions(MinecraftServer server, ICommandSender sender, String[] args, BlockPos targetPos) {
		return Collections.emptyList();
	}

	@Override
	public boolean isUsernameIndex(String[] args, int index) {
		return false;
	}
}
<#-- @formatter:on -->
