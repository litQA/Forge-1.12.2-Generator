<#-- @formatter:off -->
package ${package}.init;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import net.minecraft.util.ResourceLocation;
import net.minecraft.world.storage.loot.LootContext;
import net.minecraft.world.storage.loot.LootEntry;
import net.minecraft.world.storage.loot.LootPool;
import net.minecraft.world.storage.loot.LootTable;
import net.minecraft.world.storage.loot.LootTableList;
import net.minecraft.world.storage.loot.RandomValueRange;
import net.minecraft.world.storage.loot.conditions.LootCondition;
import net.minecraft.world.storage.loot.conditions.LootConditionManager;
import net.minecraft.world.storage.loot.functions.LootFunction;
import net.minecraft.world.storage.loot.functions.LootFunctionManager;
import net.minecraftforge.event.LootTableLoadEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

public class ${JavaModName}Loottables {

	private static final Gson LOOT_TABLE_GSON = new GsonBuilder()
			.registerTypeAdapter(RandomValueRange.class, new RandomValueRange.Serializer())
			.registerTypeAdapter(LootPool.class, new LootPool.Serializer())
			.registerTypeAdapter(LootTable.class, new LootTable.Serializer())
			.registerTypeHierarchyAdapter(LootEntry.class, new LootEntry.Serializer())
			.registerTypeHierarchyAdapter(LootFunction.class, new LootFunctionManager.Serializer())
			.registerTypeHierarchyAdapter(LootCondition.class, new LootConditionManager.Serializer())
			.registerTypeHierarchyAdapter(LootContext.EntityTarget.class, new LootContext.EntityTarget.Serializer())
			.create();

	public static void load() {
		net.minecraftforge.common.MinecraftForge.EVENT_BUS.register(${JavaModName}Loottables.class);
		<#list (loottables![]) as loottable>
		try {
			LootTableList.register(new ResourceLocation("${loottable.getNamespace()}:${loottable.getName()}"));
		} catch (IllegalArgumentException ignored) {
			// Built-in loot tables are replaced by the load event below.
		}
		</#list>
	}

	@SubscribeEvent
	public static void onLootTableLoad(LootTableLoadEvent event) {
		<#list (loottables![]) as loottable>
		if (event.getName().equals(new ResourceLocation("${loottable.getNamespace()}:${loottable.getName()}"))) {
			event.setTable(loadLootTable("${loottable.getName()}"));
		}
		</#list>
	}

	private static LootTable loadLootTable(String path) {
		String resourcePath = "/assets/${modid}/loot_tables/" + path + ".json";
		try (InputStream stream = ${JavaModName}Loottables.class.getResourceAsStream(resourcePath)) {
			if (stream == null)
				return LootTable.EMPTY_LOOT_TABLE;
			return LOOT_TABLE_GSON.fromJson(new InputStreamReader(stream, StandardCharsets.UTF_8), LootTable.class);
		} catch (Exception exception) {
			exception.printStackTrace();
			return LootTable.EMPTY_LOOT_TABLE;
		}
	}

}
<#-- @formatter:on -->
