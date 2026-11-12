<#-- @formatter:off -->
package ${package};

import net.minecraftforge.fml.common.event.FMLInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPostInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPreInitializationEvent;
import net.minecraftforge.fml.common.event.FMLServerStartingEvent;

public class ServerProxy${JavaModName} implements IProxy${JavaModName} {

	@Override public void preInit(FMLPreInitializationEvent event) {
	}

	@Override public void init(FMLInitializationEvent event) {
		<#list w.getGElementsOfType('procedure') as procedure>
		<#if procedure.procedurexml?contains('mod_serverload')>
		${package}.procedures.${procedure.getModElement().getName()}Procedure.init(event);
		</#if>
		</#list>
	}

	@Override public void postInit(FMLPostInitializationEvent event) {
	}

	@Override public void serverLoad(FMLServerStartingEvent event) {
	}

}
<#-- @formatter:on -->
