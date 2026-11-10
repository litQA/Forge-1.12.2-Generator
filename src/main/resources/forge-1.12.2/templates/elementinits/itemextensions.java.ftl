<#-- @formatter:off -->
package ${package}.init;

public class ${JavaModName}ItemExtensions {

	public static void load() {
		<#list (itemextensions![]) as itemextension>
		<#if itemextension.hasDispenseBehavior>
		${package}.item.extension.${itemextension.getModElement().getName()}ItemExtension.init();
		</#if>
		</#list>
	}

}
<#-- @formatter:on -->
