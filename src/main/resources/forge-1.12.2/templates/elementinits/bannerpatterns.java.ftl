<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.item.ItemStack;
import net.minecraft.tileentity.BannerPattern;
import net.minecraftforge.common.util.EnumHelper;

public class ${JavaModName}BannerPatterns {

	private static final Class<?>[] PARAMETERS = new Class<?>[] { String.class, String.class, ItemStack.class };

	<#list (types.bannerpatterns![]) as pattern>
	public static BannerPattern ${pattern.getModElement().getRegistryNameUpper()};
	</#list>

	public static void init() {
		<#list (types.bannerpatterns![]) as pattern>
		${pattern.getModElement().getRegistryNameUpper()} = EnumHelper.addEnum(BannerPattern.class,
				"${pattern.getModElement().getRegistryNameUpper()}", PARAMETERS,
				"${pattern.getModElement().getRegistryName()}", "${pattern.getModElement().getRegistryName()}",
				new ItemStack(${package}.init.${JavaModName}Items.${pattern.getModElement().getRegistryNameUpper()}_PATTERN));
		if (${pattern.getModElement().getRegistryNameUpper()} == null)
			throw new IllegalStateException("Failed to register banner pattern ${pattern.getModElement().getRegistryName()}");
		</#list>
	}
}
<#-- @formatter:on -->
