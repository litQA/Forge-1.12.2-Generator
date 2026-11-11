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
import ${package}.init.${JavaModName}GUIs;

public class ${name}GuiMessages {

	public static void register() {
		<#if data.hasButtonEvents()>
		${JavaModName}.addNetworkMessage(ButtonHandler.class, ButtonMessage.class, Side.SERVER);
		</#if>
		<#if data.hasSliderEvents()>
		${JavaModName}.addNetworkMessage(SliderHandler.class, SliderMessage.class, Side.SERVER);
		</#if>
		<#if data.hasSlotEvents()>
		${JavaModName}.addNetworkMessage(SlotHandler.class, SlotMessage.class, Side.SERVER);
		</#if>
	}

	<#if data.hasButtonEvents()>
	public static void sendButton(int id, int x, int y, int z) {
		${JavaModName}.PACKET_HANDLER.sendToServer(new ButtonMessage(id, x, y, z));
	}

	public static void handleButton(EntityPlayer entity, int id, int x, int y, int z) {
		World world = entity.world;
		<#assign buttonId = 0>
		<#list data.getComponentsOfType("Button") as component>
		if (id == ${buttonId}) {
			<#if hasProcedure(component.onClick)>
			<@procedureOBJToCode component.onClick/>
			</#if>
			return;
		}
		<#assign buttonId += 1>
		</#list>
		<#list data.getComponentsOfType("ImageButton") as component>
		if (id == ${buttonId}) {
			<#if hasProcedure(component.onClick)>
			<@procedureOBJToCode component.onClick/>
			</#if>
			return;
		}
		<#assign buttonId += 1>
		</#list>
	}

	public static class ButtonMessage implements IMessage {
		int id, x, y, z;

		public ButtonMessage() {
		}

		public ButtonMessage(int id, int x, int y, int z) {
			this.id = id;
			this.x = x;
			this.y = y;
			this.z = z;
		}

		@Override public void fromBytes(ByteBuf buffer) {
			this.id = buffer.readInt();
			this.x = buffer.readInt();
			this.y = buffer.readInt();
			this.z = buffer.readInt();
		}

		@Override public void toBytes(ByteBuf buffer) {
			buffer.writeInt(this.id);
			buffer.writeInt(this.x);
			buffer.writeInt(this.y);
			buffer.writeInt(this.z);
		}
	}

	public static class ButtonHandler implements IMessageHandler<ButtonMessage, IMessage> {
		@Override public IMessage onMessage(ButtonMessage message, MessageContext context) {
			EntityPlayerMP player = context.getServerHandler().player;
			player.getServerWorld().addScheduledTask(
					() -> handleButton(player, message.id, message.x, message.y, message.z));
			return null;
		}
	}
	</#if>

	<#if data.hasSliderEvents()>
	public static void sendSlider(int id, double value, int x, int y, int z) {
		${JavaModName}.PACKET_HANDLER.sendToServer(new SliderMessage(id, value, x, y, z));
	}

	public static void handleSlider(EntityPlayer entity, int id, double value, int x, int y, int z) {
		World world = entity.world;
		<#assign sliderId = 0>
		<#list data.getComponentsOfType("Slider") as component>
		if (id == ${sliderId}) {
			<#if hasProcedure(component.whenSliderMoves)>
			<@procedureOBJToCode component.whenSliderMoves/>
			</#if>
			return;
		}
		<#assign sliderId += 1>
		</#list>
	}

	public static class SliderMessage implements IMessage {
		int id, x, y, z;
		double value;

		public SliderMessage() {
		}

		public SliderMessage(int id, double value, int x, int y, int z) {
			this.id = id;
			this.value = value;
			this.x = x;
			this.y = y;
			this.z = z;
		}

		@Override public void fromBytes(ByteBuf buffer) {
			this.id = buffer.readInt();
			this.value = buffer.readDouble();
			this.x = buffer.readInt();
			this.y = buffer.readInt();
			this.z = buffer.readInt();
		}

		@Override public void toBytes(ByteBuf buffer) {
			buffer.writeInt(this.id);
			buffer.writeDouble(this.value);
			buffer.writeInt(this.x);
			buffer.writeInt(this.y);
			buffer.writeInt(this.z);
		}
	}

	public static class SliderHandler implements IMessageHandler<SliderMessage, IMessage> {
		@Override public IMessage onMessage(SliderMessage message, MessageContext context) {
			EntityPlayerMP player = context.getServerHandler().player;
			player.getServerWorld().addScheduledTask(
					() -> handleSlider(player, message.id, message.value, message.x, message.y, message.z));
			return null;
		}
	}
	</#if>

	<#if data.hasSlotEvents()>
	public static void sendSlot(int id, int type, int meta, int x, int y, int z) {
		${JavaModName}.PACKET_HANDLER.sendToServer(new SlotMessage(id, type, meta, x, y, z));
	}

	public static void handleSlot(EntityPlayer entity, int id, int type, int meta, int x, int y, int z) {
		World world = entity.world;
		int slotid = id;
		int amount = meta;
		<#list data.components as component>
		<#if component.getClass().getSimpleName()?ends_with("Slot")>
			<#if hasProcedure(component.onSlotChanged)>
		if (slotid == ${component.id} && type == 0) {
			<@procedureOBJToCode component.onSlotChanged/>
		}
			</#if>
			<#if hasProcedure(component.onTakenFromSlot)>
		if (slotid == ${component.id} && type == 1) {
			<@procedureOBJToCode component.onTakenFromSlot/>
		}
			</#if>
			<#if hasProcedure(component.onStackTransfer)>
		if (slotid == ${component.id} && type == 2) {
			<@procedureOBJToCode component.onStackTransfer/>
		}
			</#if>
		</#if>
		</#list>
	}

	public static class SlotMessage implements IMessage {
		int id, type, meta, x, y, z;

		public SlotMessage() {
		}

		public SlotMessage(int id, int type, int meta, int x, int y, int z) {
			this.id = id;
			this.type = type;
			this.meta = meta;
			this.x = x;
			this.y = y;
			this.z = z;
		}

		@Override public void fromBytes(ByteBuf buffer) {
			this.id = buffer.readInt();
			this.type = buffer.readInt();
			this.meta = buffer.readInt();
			this.x = buffer.readInt();
			this.y = buffer.readInt();
			this.z = buffer.readInt();
		}

		@Override public void toBytes(ByteBuf buffer) {
			buffer.writeInt(this.id);
			buffer.writeInt(this.type);
			buffer.writeInt(this.meta);
			buffer.writeInt(this.x);
			buffer.writeInt(this.y);
			buffer.writeInt(this.z);
		}
	}

	public static class SlotHandler implements IMessageHandler<SlotMessage, IMessage> {
		@Override public IMessage onMessage(SlotMessage message, MessageContext context) {
			EntityPlayerMP player = context.getServerHandler().player;
			player.getServerWorld().addScheduledTask(
					() -> handleSlot(player, message.id, message.type, message.meta, message.x, message.y, message.z));
			return null;
		}
	}
	</#if>

}
<#-- @formatter:on -->
