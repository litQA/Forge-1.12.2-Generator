<#-- @formatter:off -->
<#include "/procedures.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import net.minecraft.client.Minecraft;
import net.minecraft.client.settings.KeyBinding;
import net.minecraftforge.fml.client.registry.ClientRegistry;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.gameevent.InputEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;

@Mod.EventBusSubscriber(Side.CLIENT) public class ${JavaModName}KeyMappings {

	<#function keyCode keybind>
		<#if keybind?starts_with("MOUSE")>
			<#if keybind == "MOUSELEFT">
				<#return "-100">
			<#elseif keybind == "MOUSERIGHT">
				<#return "-99">
			<#elseif keybind == "MOUSEMIDDLE">
				<#return "-98">
			<#else>
				<#return "-100">
			</#if>
		<#else>
			<#return "Keyboard.KEY_" + generator.map(keybind, "keybuttons")>
		</#if>
	</#function>

	<#list (types.keybinds![]) as keybind>
	public static final KeyBinding ${keybind.getModElement().getRegistryNameUpper()} = new KeyBinding(
			"key.${modid}.${keybind.getModElement().getRegistryName()}", ${keyCode(keybind.triggerKey.getUnmappedValue())},
			"key.categories.${keybind.keyBindingCategoryKey}");
	</#list>

	<#list (types.keybinds![]) as keybind>
	<#if hasProcedure(keybind.onKeyReleased)>
	private static long ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = 0;
	</#if>
	</#list>

	public static void registerKeyBindings() {
		<#list (types.keybinds![]) as keybind>
		ClientRegistry.registerKeyBinding(${keybind.getModElement().getRegistryNameUpper()});
		</#list>
	}

	@SubscribeEvent public static void onKeyInput(InputEvent.KeyInputEvent event) {
		if (Minecraft.getMinecraft().currentScreen != null)
			return;

		<#list (types.keybinds![]) as keybind>
		<#if hasProcedure(keybind.onKeyPressed) || hasProcedure(keybind.onKeyReleased)>
		if (Keyboard.getEventKey() == ${keybind.getModElement().getRegistryNameUpper()}.getKeyCode()) {
			handleKey(${keybind.getModElement().getRegistryNameUpper()}, Keyboard.getEventKeyState() ? 0 : 1);
		}
		</#if>
		</#list>
	}

	@SubscribeEvent public static void onMouseInput(InputEvent.MouseInputEvent event) {
		if (Minecraft.getMinecraft().currentScreen != null)
			return;

		int mouseKey = Mouse.getEventButton() < 0 ? 0 : -100 + Mouse.getEventButton();
		<#list (types.keybinds![]) as keybind>
		<#if hasProcedure(keybind.onKeyPressed) || hasProcedure(keybind.onKeyReleased)>
		if (mouseKey == ${keybind.getModElement().getRegistryNameUpper()}.getKeyCode() && Mouse.getEventButton() >= 0) {
			handleKey(${keybind.getModElement().getRegistryNameUpper()}, Mouse.getEventButtonState() ? 0 : 1);
		}
		</#if>
		</#list>
	}

	private static void handleKey(KeyBinding keyBinding, int type) {
		String name = keyBinding.getKeyDescription();
		<#list (types.keybinds![]) as keybind>
		if (name.equals("key.${modid}.${keybind.getModElement().getRegistryName()}")) {
			<#if hasProcedure(keybind.onKeyPressed)>
			if (type == 0) {
				${JavaModName}.PACKET_HANDLER.sendToServer(new ${package}.network.${keybind.getModElement().getName()}Message(0, 0));
				${package}.network.${keybind.getModElement().getName()}Message.pressAction(Minecraft.getMinecraft().player, 0, 0);
			}
			</#if>
			<#if hasProcedure(keybind.onKeyReleased)>
			if (type == 0) {
				${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = System.currentTimeMillis();
			} else {
				int dt = (int) (System.currentTimeMillis() - ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS);
				${JavaModName}.PACKET_HANDLER.sendToServer(new ${package}.network.${keybind.getModElement().getName()}Message(1, dt));
				${package}.network.${keybind.getModElement().getName()}Message.pressAction(Minecraft.getMinecraft().player, 1, dt);
			}
			</#if>
			return;
		}
		</#list>
	}

}
<#-- @formatter:on -->
