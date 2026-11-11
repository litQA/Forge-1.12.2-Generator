<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#function entityClassCode entity>
	<#assign entityName = entity?string>
	<#if entityName?starts_with("CUSTOM:")>
		<#return package + ".entity." + entityName?replace("CUSTOM:", "")>
	<#else>
		<#assign mappedEntity = generator.map(entityName, "entityclasses")>
		<#return (mappedEntity?has_content && mappedEntity != "null")?then(mappedEntity, "net.minecraft.entity.Entity")>
	</#if>
</#function>
package ${package}.world.biome;

import ${package}.init.${JavaModName}Biomes;
<#if data.treeType == 1>import ${package}.world.features.treedecorators.${name}TreeFeature;</#if>
import java.util.Random;
import net.minecraft.init.Blocks;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.biome.Biome;
import net.minecraft.world.gen.feature.WorldGenAbstractTree;
import net.minecraft.world.gen.feature.WorldGenBigTree;
import net.minecraft.world.gen.feature.WorldGenBirchTree;
import net.minecraft.world.gen.feature.WorldGenMegaPineTree;
import net.minecraft.world.gen.feature.WorldGenSavannaTree;
import net.minecraft.world.gen.feature.WorldGenTrees;
import net.minecraftforge.common.BiomeManager;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${name}Biome extends Biome {

	<#if data.spawnBiome>
	public static void init() {
		BiomeManager.addSpawnBiome(${JavaModName}Biomes.${REGISTRYNAME});
		BiomeManager.addBiome(BiomeManager.BiomeType.
		<#if data.temperature < -0.25>
		ICY
		<#elseif data.temperature <= 0.15>
		COOL
		<#elseif data.temperature <= 1.0>
		WARM
		<#else>
		DESERT
		</#if>, new BiomeManager.BiomeEntry(${JavaModName}Biomes.${REGISTRYNAME}, 100));
	}
	</#if>

	public ${name}Biome() {
		super(new Biome.BiomeProperties("${name}")
				.setRainfall(${data.rainingPossibility?c}f)
				.setBaseHeight(0.1f)
				.setHeightVariation(0.3f)
				.setTemperature(${data.temperature?c}f)
				<#if data.rainingPossibility gt 0 && data.temperature <= 0.15>
				.setSnowEnabled()
				<#else>
				.setRainDisabled()
				</#if>
				.setWaterColor(${(data.waterColor?has_content?then(data.waterColor.getRGB(), 4159204))?c}));

		this.topBlock = ${mappedBlockToBlockStateCode(data.groundBlock)};
		this.fillerBlock = ${mappedBlockToBlockStateCode(data.undergroundBlock)};

		this.decorator.flowersPerChunk = 0;
		this.decorator.grassPerChunk = 0;
		this.decorator.gravelPatchesPerChunk = 0;
		this.decorator.sandPatchesPerChunk = 0;
		this.decorator.clayPerChunk = 0;
		this.decorator.treesPerChunk = ${data.treesPerChunk};

		<#if data.spawnStronghold>
		BiomeManager.addStrongholdBiome(this);
		</#if>

		<#if data.villageType != "none">
		BiomeManager.addVillageBiome(this, true);
		</#if>

		this.spawnableMonsterList.clear();
		this.spawnableCreatureList.clear();
		this.spawnableWaterCreatureList.clear();
		this.spawnableCaveCreatureList.clear();

		<#list data.spawnEntries as spawnEntry>
		<#assign entity = spawnEntry.entity!"null">
		<#if entity != "null">
		<#assign entityCode = entityClassCode(entity)>
		<#if generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.MONSTER">
		this.spawnableMonsterList.add(new SpawnListEntry((Class<? extends net.minecraft.entity.EntityLiving>) (Class<?>) ${entityCode}.class,
				${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
		<#elseif generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.CREATURE">
		this.spawnableCreatureList.add(new SpawnListEntry((Class<? extends net.minecraft.entity.EntityLiving>) (Class<?>) ${entityCode}.class,
				${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
		<#elseif generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.AMBIENT">
		this.spawnableCaveCreatureList.add(new SpawnListEntry((Class<? extends net.minecraft.entity.EntityLiving>) (Class<?>) ${entityCode}.class,
				${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
		<#else>
		this.spawnableWaterCreatureList.add(new SpawnListEntry((Class<? extends net.minecraft.entity.EntityLiving>) (Class<?>) ${entityCode}.class,
				${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
		</#if>
		</#if>
		</#list>
	}

	<#if data.treesPerChunk gt 0>
	@Override public WorldGenAbstractTree getRandomTreeFeature(Random rand) {
		<#if data.treeType == 1>
		return new ${name}TreeFeature();
		<#elseif data.vanillaTreeType == "Big trees">
		return new WorldGenBigTree(false);
		<#elseif data.vanillaTreeType == "Birch trees">
		return new WorldGenBirchTree(false, true);
		<#elseif data.vanillaTreeType == "Savanna trees">
		return new WorldGenSavannaTree(false);
		<#elseif data.vanillaTreeType == "Mega pine trees">
		return new WorldGenMegaPineTree(false, false);
		<#elseif data.vanillaTreeType == "Mega spruce trees">
		return new WorldGenMegaPineTree(false, true);
		<#else>
		return new WorldGenTrees(false);
		</#if>
	}
	</#if>

	@SideOnly(Side.CLIENT)
	@Override public int getGrassColorAtPos(BlockPos pos) {
		return ${(data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285))?c};
	}

	@SideOnly(Side.CLIENT)
	@Override public int getFoliageColorAtPos(BlockPos pos) {
		return ${(data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789))?c};
	}

	@SideOnly(Side.CLIENT)
	@Override public int getSkyColorByTemp(float currentTemperature) {
		return ${(data.airColor?has_content?then(data.airColor.getRGB(), 7972607))?c};
	}
}
<#-- @formatter:on -->
