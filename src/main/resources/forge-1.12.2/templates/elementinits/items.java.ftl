<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;
import net.minecraft.client.renderer.block.model.ModelResourceLocation;
import net.minecraft.item.Item;
import net.minecraftforge.client.event.ModelRegistryEvent;
import net.minecraftforge.client.model.ModelLoader;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${JavaModName}Items {

	private static final List<Item> REGISTRY = new ArrayList<>();

	<#list types.items as item>
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", new ${package}.item.${item.getModElement().getName()}Item());
	</#list>

	// Start of user code block custom items
	// End of user code block custom items

	private static Item register(String name, Item item) {
		item.setRegistryName(${package}.${JavaModName}.MODID, name);
		REGISTRY.add(item);
		return item;
	}

	@SubscribeEvent public static void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Item[0]));
	}

	@SideOnly(Side.CLIENT) @SubscribeEvent public static void registerModels(ModelRegistryEvent event) {
		for (Item item : REGISTRY) {
			ModelLoader.setCustomModelResourceLocation(item, 0, new ModelResourceLocation(item.getRegistryName(), "inventory"));
		}
	}

}
<#-- @formatter:on -->
