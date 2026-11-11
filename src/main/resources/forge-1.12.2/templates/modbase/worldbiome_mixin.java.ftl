<#-- @formatter:off -->
package ${package}.mixin;

import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.biome.Biome;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(World.class)
public class ${JavaModName}WorldBiomeMixin {

	@Inject(method = "getBiome", at = @At("RETURN"), cancellable = true)
	private void ${JavaModName?lower_case}$getBiome(BlockPos pos, CallbackInfoReturnable<Biome> cir) {
		World world = (World) (Object) this;
		Biome replacement = ${JavaModName}WorldgenHooks.getBiome(world, pos, cir.getReturnValue());
		if (replacement != null) {
			cir.setReturnValue(replacement);
		}
	}
}
<#-- @formatter:on -->
