<#-- @formatter:off -->
package ${package}.init;

import java.lang.reflect.Constructor;
import net.minecraft.entity.Entity;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.inventory.ContainerChest;
import net.minecraft.inventory.IInventory;
import net.minecraft.world.World;
import net.minecraftforge.fml.common.network.IGuiHandler;

import ${package}.${JavaModName};

/*
 * Client GUI classes are created through reflection so that a dedicated server
 * never has to resolve the client-only Minecraft GUI classes.
 */
public class ${JavaModName}GuiHandler implements IGuiHandler {

	@Override public Object getServerGuiElement(int id, EntityPlayer player, World world, int x, int y, int z) {
		<#list (types.guis![]) as gui>
		if (id == ${JavaModName}GUIs.${gui.getModElement().getRegistryNameUpper()}_ID)
			return new ${package}.client.gui.${gui.getModElement().getName()}Gui.ContainerMod(player, world, x, y, z);
		</#list>

		<#list (types.specialentities![]) as specialentity>
		<#if specialentity.isBoatChestVariant()>
		if (id == ${JavaModName}GUIs.CHEST_BOAT_ID) {
			Entity entity = world.getEntityByID(x);
			if (entity instanceof IInventory)
				return new ContainerChest(player.inventory, (IInventory) entity, player);
		}
		</#if>
		</#list>

		return null;
	}

	@Override public Object getClientGuiElement(int id, EntityPlayer player, World world, int x, int y, int z) {
		try {
			<#list (types.guis![]) as gui>
			if (id == ${JavaModName}GUIs.${gui.getModElement().getRegistryNameUpper()}_ID) {
				Class<?> containerClass = Class.forName("${package}.client.gui.${gui.getModElement().getName()}Gui$ContainerMod");
				Class<?> windowClass = Class.forName("${package}.client.gui.${gui.getModElement().getName()}Gui$GuiWindow");
				Constructor<?> containerConstructor = containerClass.getConstructor(EntityPlayer.class, World.class, int.class, int.class, int.class);
				Object container = containerConstructor.newInstance(player, world, x, y, z);
				return windowClass.getConstructor(containerClass).newInstance(container);
			}
			</#list>

			<#list (types.specialentities![]) as specialentity>
			<#if specialentity.isBoatChestVariant()>
			if (id == ${JavaModName}GUIs.CHEST_BOAT_ID) {
				Entity entity = world.getEntityByID(x);
				if (entity instanceof IInventory) {
					Class<?> chestClass = Class.forName("net.minecraft.client.gui.GuiChest");
					return chestClass.getConstructor(net.minecraft.entity.player.InventoryPlayer.class, IInventory.class)
							.newInstance(player.inventory, (IInventory) entity);
				}
			}
			</#if>
			</#list>
		} catch (Exception exception) {
			exception.printStackTrace();
		}

		return null;
	}

}
<#-- @formatter:on -->
