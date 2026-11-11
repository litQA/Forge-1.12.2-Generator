<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.network;

import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.world.World;
import net.minecraftforge.fml.common.network.simpleimpl.IMessage;
import net.minecraftforge.fml.common.network.simpleimpl.IMessageHandler;
import net.minecraftforge.fml.common.network.simpleimpl.MessageContext;
import net.minecraftforge.fml.relauncher.Side;
import io.netty.buffer.ByteBuf;

import ${package}.${JavaModName};

public class ${name}Message implements IMessage {

	int type;
	int pressedms;

	public ${name}Message() {
	}

	public ${name}Message(int type, int pressedms) {
		this.type = type;
		this.pressedms = pressedms;
	}

	@Override public void fromBytes(ByteBuf buffer) {
		this.type = buffer.readInt();
		this.pressedms = buffer.readInt();
	}

	@Override public void toBytes(ByteBuf buffer) {
		buffer.writeInt(this.type);
		buffer.writeInt(this.pressedms);
	}

	<#if hasProcedure(data.onKeyPressed) || hasProcedure(data.onKeyReleased)>
	public static void pressAction(EntityPlayer entity, int type, int pressedms) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;

		if (!world.isBlockLoaded(entity.getPosition()))
			return;

		<#if hasProcedure(data.onKeyPressed)>
		if (type == 0) {
			<@procedureOBJToCode data.onKeyPressed/>
		}
		</#if>

		<#if hasProcedure(data.onKeyReleased)>
		if (type == 1) {
			<@procedureOBJToCode data.onKeyReleased/>
		}
		</#if>
	}
	</#if>

	public static class Handler implements IMessageHandler<${name}Message, IMessage> {
		@Override public IMessage onMessage(${name}Message message, MessageContext context) {
			EntityPlayerMP entity = context.getServerHandler().player;
			entity.getServerWorld().addScheduledTask(() -> {
				<#if hasProcedure(data.onKeyPressed) || hasProcedure(data.onKeyReleased)>
				pressAction(entity, message.type, message.pressedms);
				</#if>
			});
			return null;
		}
	}

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(Handler.class, ${name}Message.class, Side.SERVER);
	}

}
<#-- @formatter:on -->
