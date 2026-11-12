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

import net.minecraftforge.event.world.*;
import net.minecraftforge.event.entity.*;
import net.minecraftforge.event.entity.living.*;
import net.minecraftforge.event.entity.player.*;
import net.minecraftforge.event.terraingen.*;
import net.minecraftforge.fml.common.event.*;
import net.minecraftforge.fml.common.gameevent.*;
import net.minecraftforge.fml.common.eventhandler.*;
import net.minecraftforge.fml.common.network.simpleimpl.*;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.relauncher.*;
import net.minecraft.entity.*;
import net.minecraft.entity.player.*;
import net.minecraft.entity.item.*;
import net.minecraft.util.*;
import net.minecraft.util.math.*;
import net.minecraft.world.*;
import net.minecraft.item.*;
import net.minecraft.block.*;
import net.minecraft.network.*;
import io.netty.buffer.*;

<#if trigger_code?has_content>
${trigger_code}
<#else>
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
</#if>
<#if trigger_code?has_content>
	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(
			<#list dependencies as dependency>${dependency.getType(generator.getWorkspace())} ${dependency.getName()}<#sep>, </#list>) {
		<#if return_type??>return </#if>execute(null<#if dependencies?has_content>,</#if><#list dependencies as dependency>${dependency.getName()}<#sep>, </#list>);
	}

	private static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(net.minecraftforge.fml.common.eventhandler.Event event<#if dependencies?has_content>,</#if>
			<#list dependencies as dependency>${dependency.getType(generator.getWorkspace())} ${dependency.getName()}<#sep>, </#list>) {
</#if>

		<#list localvariables as var>
		${var.getType().getScopeDefinition(generator.getWorkspace(), "LOCAL")['init']?interpret}
		</#list>

		${procedurecode}
		${additional_code}
		${extra_templates_code}
	}

}
<#-- @formatter:on -->
