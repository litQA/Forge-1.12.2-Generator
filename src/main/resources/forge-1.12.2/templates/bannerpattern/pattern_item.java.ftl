package ${package}.item;

import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.item.Item;

public class ${name}Item extends Item {
	public ${name}Item() {
		this.setUnlocalizedName("${modid}.${registryname}_pattern");
		this.setCreativeTab(CreativeTabs.DECORATIONS);
		this.setMaxStackSize(1);
	}
}
