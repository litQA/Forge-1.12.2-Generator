<#-- @formatter:off -->
package ${package}.client.model;

@SideOnly(Side.CLIENT)
${model.toString()
	.replace("public static class", "public class")
	.replace("private final ModelRenderer", "public final ModelRenderer")?keep_before_last("}")}

	<#if !model.contains("setRotationAngles")>
	@Override public void setRotationAngles(float f, float f1, float f2, float f3, float f4, float f5, Entity entity) {}
	</#if>
}
<#-- @formatter:on -->
