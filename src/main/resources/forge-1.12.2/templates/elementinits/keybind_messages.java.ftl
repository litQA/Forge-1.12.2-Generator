<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

public class ${JavaModName}KeyMessages {

	public static void register() {
		<#list (types.keybinds![]) as keybind>
		${package}.network.${keybind.getModElement().getName()}Message.registerMessage();
		</#list>
	}

}
<#-- @formatter:on -->
