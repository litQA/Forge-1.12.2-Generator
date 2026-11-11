<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 GUI registration and the lightweight GUI state channel used
 *    by text fields, checkboxes, sliders and GUI procedure blocks.
 */
package ${package}.init;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.world.World;
import net.minecraftforge.fml.common.network.simpleimpl.IMessage;
import net.minecraftforge.fml.common.network.simpleimpl.IMessageHandler;
import net.minecraftforge.fml.common.network.simpleimpl.MessageContext;
import net.minecraftforge.fml.common.network.ByteBufUtils;
import net.minecraftforge.fml.relauncher.Side;
import io.netty.buffer.ByteBuf;

import ${package}.${JavaModName};

public class ${JavaModName}GUIs {

	public static final int CHEST_BOAT_ID = 0;

	<#assign guiId = 1>
	<#list (types.guis![]) as gui>
	public static final int ${gui.getModElement().getRegistryNameUpper()}_ID = ${guiId};
	<#assign guiId += 1>
	</#list>

	public static void init() {
		${JavaModName}.addNetworkMessage(StateHandler.class, StateMessage.class, Side.SERVER);
		${JavaModName}.addNetworkMessage(StateUpdateHandler.class, StateUpdateMessage.class, Side.CLIENT);
		<#list (types.guis![]) as gui>
		${package}.network.${gui.getModElement().getName()}GuiMessages.register();
		</#list>
	}

	public static void open(EntityPlayer player, int id, World world, int x, int y, int z) {
		if (player instanceof EntityPlayerMP && id >= 0)
			((EntityPlayerMP) player).openGui(${JavaModName}.instance, id, world, x, y, z);
	}

	public static int idForName(String name) {
		<#list (types.guis![]) as gui>
		if ("${gui.getModElement().getName()}".equals(name))
			return ${gui.getModElement().getRegistryNameUpper()}_ID;
		</#list>
		return -1;
	}

	public static class State {

		private static final Map<UUID, Map<String, Object>> SERVER = new HashMap<>();
		private static final Map<String, Object> CLIENT = new HashMap<>();

		private static Map<String, Object> serverMap(EntityPlayer player) {
			return SERVER.computeIfAbsent(player.getUniqueID(), key -> new HashMap<>());
		}

		public static void clearServer(EntityPlayer player) {
			SERVER.remove(player.getUniqueID());
		}

		public static void clearClient() {
			CLIENT.clear();
		}

		public static void putServer(EntityPlayer player, String key, int type, Object value) {
			serverMap(player).put(key, value);
		}

		public static void putClient(String key, Object value) {
			CLIENT.put(key, value);
		}

		public static void setServerAndSync(EntityPlayer player, String key, int type, Object value) {
			putServer(player, key, type, value);
			if (player instanceof EntityPlayerMP)
				${JavaModName}.PACKET_HANDLER.sendTo(new StateUpdateMessage(key, type, value), (EntityPlayerMP) player);
		}

		public static void sendToServer(String key, int type, Object value) {
			${JavaModName}.PACKET_HANDLER.sendToServer(new StateMessage(key, type, value));
		}

		public static String getServerString(EntityPlayer player, String key, String fallback) {
			Object value = serverMap(player).get(key);
			return value instanceof String ? (String) value : fallback;
		}

		public static boolean getServerBoolean(EntityPlayer player, String key, boolean fallback) {
			Object value = serverMap(player).get(key);
			return value instanceof Boolean ? (Boolean) value : fallback;
		}

		public static double getServerDouble(EntityPlayer player, String key, double fallback) {
			Object value = serverMap(player).get(key);
			return value instanceof Number ? ((Number) value).doubleValue() : fallback;
		}

		public static String getClientString(String key, String fallback) {
			Object value = CLIENT.get(key);
			return value instanceof String ? (String) value : fallback;
		}

		public static Boolean getClientBoolean(String key) {
			Object value = CLIENT.get(key);
			return value instanceof Boolean ? (Boolean) value : null;
		}

		public static Double getClientDouble(String key) {
			Object value = CLIENT.get(key);
			return value instanceof Number ? ((Number) value).doubleValue() : null;
		}
	}

	public static class StateMessage implements IMessage {

		String key;
		int type;
		String sval;
		double dval;
		boolean bval;

		public StateMessage() {
		}

		public StateMessage(String key, int type, Object value) {
			this.key = key;
			this.type = type;
			if (value instanceof String)
				this.sval = (String) value;
			else if (value instanceof Number)
				this.dval = ((Number) value).doubleValue();
			else if (value instanceof Boolean)
				this.bval = (Boolean) value;
		}

		@Override public void fromBytes(ByteBuf buffer) {
			this.key = ByteBufUtils.readUTF8String(buffer);
			this.type = buffer.readInt();
			this.sval = ByteBufUtils.readUTF8String(buffer);
			this.dval = buffer.readDouble();
			this.bval = buffer.readBoolean();
		}

		@Override public void toBytes(ByteBuf buffer) {
			ByteBufUtils.writeUTF8String(buffer, this.key == null ? "" : this.key);
			buffer.writeInt(this.type);
			ByteBufUtils.writeUTF8String(buffer, this.sval == null ? "" : this.sval);
			buffer.writeDouble(this.dval);
			buffer.writeBoolean(this.bval);
		}

		public Object value() {
			if (this.type == 0)
				return this.sval;
			if (this.type == 1)
				return this.bval;
			return this.dval;
		}
	}

	public static class StateUpdateMessage extends StateMessage {
		public StateUpdateMessage() {
		}

		public StateUpdateMessage(String key, int type, Object value) {
			super(key, type, value);
		}
	}

	public static class StateHandler implements IMessageHandler<StateMessage, IMessage> {
		@Override public IMessage onMessage(StateMessage message, MessageContext context) {
			EntityPlayerMP player = context.getServerHandler().player;
			player.getServerWorld().addScheduledTask(
					() -> State.putServer(player, message.key, message.type, message.value()));
			return null;
		}
	}

	public static class StateUpdateHandler implements IMessageHandler<StateUpdateMessage, IMessage> {
		@Override public IMessage onMessage(StateUpdateMessage message, MessageContext context) {
			State.putClient(message.key, message.value());
			return null;
		}
	}

}
<#-- @formatter:on -->
