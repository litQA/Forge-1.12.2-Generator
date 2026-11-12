package ${package}.item;

import net.minecraft.entity.item.EntityPainting;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;

public class ${name}Item extends Item {
	public ${name}Item() {
		this.setUnlocalizedName("${modid}.${registryname}");
		this.setCreativeTab(net.minecraft.creativetab.CreativeTabs.DECORATIONS);
		this.setMaxStackSize(1);
	}

	@Override
	public EnumActionResult onItemUse(EntityPlayer player, World world, BlockPos pos, EnumHand hand, EnumFacing facing,
			float hitX, float hitY, float hitZ) {
		if (facing == EnumFacing.UP || facing == EnumFacing.DOWN)
			return EnumActionResult.FAIL;

		if (!world.isRemote) {
			EntityPainting painting = new ${package}.entity.${name}PaintingEntity(world, pos.offset(facing), facing);
			if (!painting.onValidSurface())
				return EnumActionResult.FAIL;
			world.spawnEntity(painting);
			player.getHeldItem(hand).shrink(1);
		}

		return EnumActionResult.SUCCESS;
	}
}
