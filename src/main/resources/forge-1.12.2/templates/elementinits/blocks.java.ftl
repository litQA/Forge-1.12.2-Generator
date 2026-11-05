<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;
import net.minecraft.block.Block;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

public class ${JavaModName}Blocks {

	private static final List<Block> REGISTRY = new ArrayList<>();

	<#list types.blocks as block>
	<#if block.getModElement().getTypeString() == "block">
	public static final Block ${block.getModElement().getRegistryNameUpper()} = register("${block.getModElement().getRegistryName()}", new ${package}.block.${block.getModElement().getName()}Block());
	</#if>
	</#list>

	<#list (types.plants![]) as plant>
	public static final Block ${plant.getModElement().getRegistryNameUpper()} = register("${plant.getModElement().getRegistryName()}", new ${package}.block.${plant.getModElement().getName()}Block());
	</#list>

	<#list (types.fluids![]) as fluid>
	public static final Block ${fluid.getModElement().getRegistryNameUpper()} = register("${fluid.getModElement().getRegistryName()}", new ${package}.block.${fluid.getModElement().getName()}Block());
	</#list>

	// Start of user code block custom blocks
	// End of user code block custom blocks

	private static Block register(String name, Block block) {
		block.setRegistryName(${package}.${JavaModName}.MODID, name);
		REGISTRY.add(block);
		return block;
	}

	public static void initTileEntities() {
		<#list types.blocks as block>
		<#if block.hasInventory>
		net.minecraftforge.fml.common.registry.GameRegistry.registerTileEntity(${package}.block.entity.${block.getModElement().getName()}BlockEntity.class, ${package}.${JavaModName}.MODID + ":${block.getModElement().getRegistryName()}");
		</#if>
		</#list>
	}

	@SubscribeEvent public static void registerBlocks(RegistryEvent.Register<Block> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Block[0]));
	}

}
<#-- @formatter:on -->
