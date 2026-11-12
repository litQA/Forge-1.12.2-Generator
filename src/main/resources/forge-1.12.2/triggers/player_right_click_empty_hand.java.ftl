<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(net.minecraftforge.fml.relauncher.Side.CLIENT) public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onRightClick(net.minecraftforge.event.entity.player.PlayerInteractEvent.RightClickEmpty event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getWorld()",
				"entity": "event.getEntityPlayer()"
			}/>
		</#assign>
		<#-- fix #5491, event is fired for both hands always, so we can filter by either -->
		if (event.getHand() != EnumHand.MAIN_HAND) return;
		${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}Message());
		execute(${dependenciesCode});
	}

	public static class ${name}Message implements net.minecraftforge.fml.common.network.simpleimpl.IMessage {
		@Override public void toBytes(io.netty.buffer.ByteBuf buffer) {}

		@Override public void fromBytes(io.netty.buffer.ByteBuf buffer) {}
    }

	public static class ${name}MessageHandler implements net.minecraftforge.fml.common.network.simpleimpl.IMessageHandler<${name}Message, net.minecraftforge.fml.common.network.simpleimpl.IMessage> {
		@Override public net.minecraftforge.fml.common.network.simpleimpl.IMessage onMessage(${name}Message message, net.minecraftforge.fml.common.network.simpleimpl.MessageContext context) {
	    	net.minecraft.entity.player.EntityPlayerMP player = context.getServerHandler().player;
	    	player.getServerWorld().addScheduledTask(() -> {
				if (!player.world.isBlockLoaded(player.getPosition()))
					return;
				<#assign dependenciesCode>
					<@procedureDependenciesCode dependencies, {
						"x": "player.posX",
						"y": "player.posY",
						"z": "player.posZ",
						"world": "player.world",
						"entity": "player"
					}/>
				</#assign>
				execute(${dependenciesCode});
	    	});

            return null;
		}
	}

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(${name}MessageHandler.class, ${name}Message.class, net.minecraftforge.fml.relauncher.Side.SERVER);
	}


