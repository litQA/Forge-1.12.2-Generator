<#-- @formatter:off -->
package ${package}.init;

public class ${JavaModName}Procedures {

	public static void load() {
		<#list (procedures![]) as procedure>
		<#if procedure.procedurexml?contains('player_left_click_air') || procedure.procedurexml?contains('player_right_click_empty_hand')>
		${procedure.getModElement().getName()}Procedure.registerMessage();
		</#if>
		</#list>
	}
}
<#-- @formatter:on -->
