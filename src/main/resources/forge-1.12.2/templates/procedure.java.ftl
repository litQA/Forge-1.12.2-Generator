<#-- @formatter:off -->
package ${package}.procedures;

import java.util.Map;

import net.minecraft.advancements.Advancement;
import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.Entity;
import net.minecraft.item.ItemStack;
import net.minecraft.util.DamageSource;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.math.Vec3d;
import net.minecraft.world.World;

public class ${name}Procedure {

	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> executeProcedure(Map<String, Object> dependencies) {
		if (dependencies == null) {
			System.err.println("Procedure ${name} called without dependencies");
			return<#if return_type??><#if return_type.getJavaType(generator.getWorkspace()) == "boolean"> false<#else> ${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}

		<#list dependencies as dependency>
		if (dependencies.get("${dependency.getName()}") == null) {
			System.err.println("Failed to load dependency ${dependency.getName()} for procedure ${name}");
			return<#if return_type??><#if return_type.getJavaType(generator.getWorkspace()) == "boolean"> false<#else> ${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}
		</#list>

		<#list dependencies as dependency>
		${dependency.getType(generator.getWorkspace())} ${dependency.getName()} = (${dependency.getType(generator.getWorkspace())}) dependencies.get("${dependency.getName()}");
		</#list>

		<#list localvariables as var>
		${var.getType().getScopeDefinition(generator.getWorkspace(), "LOCAL")['init']?interpret}
		</#list>

		${procedurecode}
		${additional_code}
		${extra_templates_code}
	}

}
<#-- @formatter:on -->
