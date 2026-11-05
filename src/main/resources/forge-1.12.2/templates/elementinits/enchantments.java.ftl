<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.enchantment.Enchantment;
import net.minecraftforge.fml.common.registry.ForgeRegistries;
import net.minecraftforge.common.MinecraftForge;

public class ${JavaModName}Enchantments {

	<#list (types.enchantments![]) as enchantment>
	public static final Enchantment ${enchantment.getModElement().getRegistryNameUpper()} =
			new ${package}.enchantment.${enchantment.getModElement().getName()}Enchantment();
	</#list>

	public static void init() {
		<#list (types.enchantments![]) as enchantment>
		ForgeRegistries.ENCHANTMENTS.register(${enchantment.getModElement().getRegistryNameUpper()});
		MinecraftForge.EVENT_BUS.register(${package}.enchantment.${enchantment.getModElement().getName()}Enchantment.class);
		</#list>
	}

}
<#-- @formatter:on -->
