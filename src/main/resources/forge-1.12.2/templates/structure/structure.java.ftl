<#-- @formatter:off -->
<#assign structureName = (data.structure!"")?remove_ending(".nbt")?remove_beginning("structures/")>
<#if !structureName?has_content>
<#stop "A structure NBT file must be selected for the 1.12.2 structure element">
</#if>
<#if structureName?contains(":")>
<#assign structureLocation = structureName>
<#else>
<#assign structureLocation = modid + ":" + structureName>
</#if>
package ${package}.worldgen;

import java.util.Random;

import net.minecraft.server.MinecraftServer;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.WorldServer;
import net.minecraft.world.chunk.IChunkProvider;
import net.minecraft.world.gen.IChunkGenerator;
import net.minecraft.world.gen.structure.template.PlacementSettings;
import net.minecraft.world.gen.structure.template.Template;
import net.minecraftforge.fml.common.IWorldGenerator;

public class ${name}StructureGenerator implements IWorldGenerator {

	private static final ResourceLocation STRUCTURE = new ResourceLocation("${structureLocation}");

	@Override
	public void generate(Random random, int chunkX, int chunkZ, World world, IChunkGenerator chunkGenerator, IChunkProvider chunkProvider) {
		if (world.isRemote || random.nextInt(Math.max(1, ${data.spacing?c})) != 0)
			return;

		int x = chunkX * 16 + random.nextInt(16);
		int z = chunkZ * 16 + random.nextInt(16);
		BlockPos biomePos = new BlockPos(x, 0, z);
		if (!isBiomeAllowed(world, biomePos))
			return;

		int y;
		<#if data.useStartHeight>
		y = ${data.startHeightMin?c} + random.nextInt(Math.max(1, ${data.startHeightMax?c} - ${data.startHeightMin?c} + 1));
		<#else>
		y = world.getTopSolidOrLiquidBlock(biomePos).getY();
		</#if>

		MinecraftServer server = world.getMinecraftServer();
		if (server == null || !(world instanceof WorldServer))
			return;

		Template template = ((WorldServer) world).getStructureTemplateManager().getTemplate(server, STRUCTURE);
		if (template != null)
			template.addBlocksToWorld(world, new BlockPos(x, y, z), new PlacementSettings(), 2);
	}

	private boolean isBiomeAllowed(World world, BlockPos pos) {
		<#if (data.restrictionBiomes![])?has_content>
		String biome = String.valueOf(net.minecraft.world.biome.Biome.REGISTRY.getNameForObject(world.getBiome(pos)));
		<#list w.filterBrokenReferences(data.restrictionBiomes) as biome>
		if (biome.equals("${biome}"))
			return true;
		</#list>
		return false;
		<#else>
		return true;
		</#if>
	}
}
<#-- @formatter:on -->
