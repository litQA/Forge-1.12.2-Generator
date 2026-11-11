<#-- @formatter:off -->
package ${package}.client;

import ${package}.init.${JavaModName}Biomes;
import net.minecraft.client.Minecraft;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.SoundCategory;
import net.minecraft.util.SoundEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.gameevent.TickEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import net.minecraftforge.fml.common.registry.ForgeRegistries;

@SideOnly(Side.CLIENT)
public class ${JavaModName}BiomeSounds {

	private static int tickCounter;

	@SubscribeEvent public static void onClientTick(TickEvent.ClientTickEvent event) {
		if (event.phase != TickEvent.Phase.END) {
			return;
		}
		Minecraft mc = Minecraft.getMinecraft();
		if (mc.world == null || mc.player == null) {
			return;
		}
		tickCounter++;
		if (tickCounter < 400) {
			return;
		}
		tickCounter = 0;

		<#list biomes as biome>
		<#if biome.ambientSound?has_content || biome.additionsSound?has_content>
		if (mc.world.getBiome(mc.player.getPosition()) == ${JavaModName}Biomes.${biome.getModElement().getRegistryNameUpper()}) {
			<#if biome.ambientSound?has_content>
			SoundEvent ambient = ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${biome.ambientSound}"));
			if (ambient != null) {
				mc.world.playSound(mc.player, mc.player.getPosition(), ambient, SoundCategory.AMBIENT, 1.0F, 1.0F);
			}
			</#if>
			<#if biome.additionsSound?has_content>
			SoundEvent additions = ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${biome.additionsSound}"));
			if (additions != null && mc.world.rand.nextInt(4) == 0) {
				mc.world.playSound(mc.player, mc.player.getPosition(), additions, SoundCategory.AMBIENT, 0.7F, 1.0F);
			}
			</#if>
		}
		</#if>
		</#list>
	}
}
<#-- @formatter:on -->
