<#-- @formatter:off -->
<#include "/creativeTabs.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;
import net.minecraft.block.Block;
import net.minecraft.client.renderer.block.model.ModelResourceLocation;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.item.Item;
import net.minecraft.item.EnumRarity;
import net.minecraft.item.ItemBlock;
import net.minecraft.item.ItemStack;
import net.minecraft.util.NonNullList;
import net.minecraftforge.client.event.ModelRegistryEvent;
import net.minecraftforge.client.model.ModelLoader;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${JavaModName}Items {

	private static final List<Item> REGISTRY = new ArrayList<>();

	<#list types.items as item>
	<#if item.getModElement().getTypeString() == "item">
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", new ${package}.item.${item.getModElement().getName()}Item());
	</#if>
	</#list>

	<#list types.blocks as block>
	<#if block.getModElement().getTypeString() == "block" && block.hasBlockItem>
	public static final Item ${block.getModElement().getRegistryNameUpper()}_ITEM = registerBlockItem("${block.getModElement().getRegistryName()}",
			${package}.init.${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}, ${block.maxStackSize}, EnumRarity.${block.rarity}, new CreativeTabs[] {
<#list block.creativeTabs as creativeTab>
				${creativeTabValue([creativeTab])}<#if creativeTab?has_next>,</#if>
</#list>
			});
	</#if>
	</#list>

	// Start of user code block custom items
	// End of user code block custom items

	private static Item register(String name, Item item) {
		item.setRegistryName(${package}.${JavaModName}.MODID, name);
		REGISTRY.add(item);
		return item;
	}

	private static Item registerBlockItem(String name, Block block, int maxStackSize, EnumRarity rarity, CreativeTabs[] tabs) {
		Item item = new ItemBlock(block) {
			@Override public EnumRarity getRarity(ItemStack stack) {
				return rarity;
			}

			@Override public void getSubItems(CreativeTabs tab, NonNullList<ItemStack> items) {
				for (CreativeTabs supportedTab : tabs) {
					if (supportedTab == tab) {
						items.add(new ItemStack(this));
						return;
					}
				}
			}
		};
		item.setRegistryName(${package}.${JavaModName}.MODID, name);
		item.setMaxStackSize(maxStackSize);
		if (tabs.length > 0) {
			item.setCreativeTab(tabs[0]);
		}
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
