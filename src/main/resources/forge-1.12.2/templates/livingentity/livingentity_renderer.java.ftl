<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.client.renderer;

import net.minecraft.client.model.ModelBase;
import net.minecraft.client.model.ModelBiped;
import net.minecraft.client.model.ModelChicken;
import net.minecraft.client.model.ModelCow;
import net.minecraft.client.model.ModelCreeper;
import net.minecraft.client.model.ModelGhast;
import net.minecraft.client.model.ModelOcelot;
import net.minecraft.client.model.ModelPig;
import net.minecraft.client.model.ModelPlayer;
import net.minecraft.client.model.ModelSilverfish;
import net.minecraft.client.model.ModelSlime;
import net.minecraft.client.model.ModelSpider;
import net.minecraft.client.model.ModelSquid;
import net.minecraft.client.model.ModelVillager;
import net.minecraft.client.model.ModelWitch;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.client.renderer.entity.RenderBiped;
import net.minecraft.client.renderer.entity.RenderLiving;
import net.minecraft.client.renderer.entity.RenderManager;
import net.minecraft.client.renderer.entity.layers.LayerBipedArmor;
import net.minecraft.client.renderer.entity.layers.LayerHeldItem;
import net.minecraft.client.renderer.entity.layers.LayerHeldItemWitch;
import net.minecraft.client.renderer.entity.layers.LayerRenderer;
import net.minecraft.entity.Entity;
import net.minecraft.util.ResourceLocation;
import net.minecraft.world.World;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

import ${package}.entity.${name}Entity;

<#assign humanoid = false>
<#assign modelExpression = "new ModelPlayer(0.0F, false)">
<#assign modelClass = "ModelBase">
<#assign fallbackTexture = "textures/entity/steve.png">
<#if data.mobModelName == "Biped">
	<#assign humanoid = true>
	<#assign modelExpression = "new ModelPlayer(0.0F, false)">
	<#assign modelClass = "ModelBiped">
	<#assign fallbackTexture = "textures/entity/steve.png">
<#elseif data.mobModelName == "Chicken">
	<#assign modelExpression = "new ModelChicken()">
	<#assign fallbackTexture = "textures/entity/chicken.png">
<#elseif data.mobModelName == "Cow">
	<#assign modelExpression = "new ModelCow()">
	<#assign fallbackTexture = "textures/entity/cow/cow.png">
<#elseif data.mobModelName == "Creeper">
	<#assign modelExpression = "new ModelCreeper()">
	<#assign fallbackTexture = "textures/entity/creeper/creeper.png">
<#elseif data.mobModelName == "Ghast">
	<#assign modelExpression = "new ModelGhast()">
	<#assign fallbackTexture = "textures/entity/ghast/ghast.png">
<#elseif data.mobModelName == "Ocelot">
	<#assign modelExpression = "new ModelOcelot()">
	<#assign fallbackTexture = "textures/entity/cat/ocelot.png">
<#elseif data.mobModelName == "Pig">
	<#assign modelExpression = "new ModelPig()">
	<#assign fallbackTexture = "textures/entity/pig/pig.png">
<#elseif data.mobModelName == "Piglin" || data.mobModelName == "Default">
	<#assign humanoid = true>
	<#assign modelExpression = "new ModelBiped()">
	<#assign modelClass = "ModelBiped">
	<#assign fallbackTexture = "textures/entity/steve.png">
<#elseif data.mobModelName == "Slime">
	<#assign modelExpression = "new ModelSlime(16)">
	<#assign fallbackTexture = "textures/entity/slime/slime.png">
<#elseif data.mobModelName == "Salmon" || data.mobModelName == "Cod">
	<#assign modelExpression = "new ModelSquid()">
	<#assign fallbackTexture = "textures/entity/squid.png">
<#elseif data.mobModelName == "Spider">
	<#assign modelExpression = "new ModelSpider()">
	<#assign fallbackTexture = "textures/entity/spider/spider.png">
<#elseif data.mobModelName == "Villager">
	<#assign modelExpression = "new ModelVillager(0.0F)">
	<#assign fallbackTexture = "textures/entity/villager/villager.png">
<#elseif data.mobModelName == "Silverfish">
	<#assign modelExpression = "new ModelSilverfish()">
	<#assign fallbackTexture = "textures/entity/silverfish.png">
<#elseif data.mobModelName == "Witch">
	<#assign modelExpression = "new ModelWitch(0.0F)">
	<#assign fallbackTexture = "textures/entity/witch.png">
<#else>
	<#assign modelExpression = "new ${package}.client.model.${data.mobModelName}()">
</#if>

@SideOnly(Side.CLIENT)
public class ${name}Renderer extends <#if humanoid>RenderBiped<${name}Entity><#else>RenderLiving<${name}Entity></#if> {

	private static final ResourceLocation TEXTURE = <#if (data.mobModelTexture!"")?has_content>
			getTexture("${data.mobModelTexture}")<#else>
			new ResourceLocation("${fallbackTexture}")</#if>;

	public ${name}Renderer(RenderManager renderManager) {
		super(renderManager, <#if humanoid>(ModelBiped) </#if>${modelExpression}, ${data.modelShadowSize?c}F);

		<#if humanoid>
		this.addLayer(new LayerBipedArmor(this));
		<#elseif data.mobModelName == "Villager" || data.mobModelName == "Silverfish">
		this.addLayer(new LayerHeldItem(this));
		</#if>

		<#if (data.modelLayers![])?has_content>
		<#list data.modelLayers as layer>
		this.addLayer(new LayerRenderer<${name}Entity>() {
			private final ResourceLocation layerTexture = new ResourceLocation("${modid}", "textures/entities/${layer.texture}");

			@Override public void doRenderLayer(${name}Entity entity, float limbSwing, float limbSwingAmount,
					float partialTicks, float ageInTicks, float netHeadYaw, float headPitch, float scale) {
				<#if hasProcedure(layer.condition)>
				World world = entity.world;
				double x = entity.posX;
				double y = entity.posY;
				double z = entity.posZ;
				if (!(<@procedureOBJToConditionCode layer.condition/>))
					return;
				</#if>
				<#if layer.model != "Default">
				ModelBase layerModel = new ${package}.client.model.${layer.model}();
				layerModel.setModelAttributes(${name}Renderer.this.getMainModel());
				layerModel.setLivingAnimations(entity, limbSwing, limbSwingAmount, partialTicks);
				layerModel.setRotationAngles(limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scale, entity);
				<#else>
				ModelBase layerModel = ${name}Renderer.this.getMainModel();
				</#if>
				${name}Renderer.this.bindTexture(layerTexture);
				<#if layer.glow>
				GlStateManager.enableBlend();
				GlStateManager.disableAlpha();
				GlStateManager.blendFunc(GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ONE);
				GlStateManager.depthMask(!entity.isInvisible());
				GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
				layerModel.render(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scale);
				GlStateManager.depthMask(true);
				GlStateManager.disableBlend();
				GlStateManager.enableAlpha();
				<#else>
				GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
				layerModel.render(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scale);
				</#if>
			}

			@Override public boolean shouldCombineTextures() {
				return ${layer.disableHurtOverlay?c};
			}
		});
		</#list>
		</#if>
	}

	<#if data.visualScale?? && (hasProcedure(data.visualScale) || data.visualScale.getFixedValue() != 1)>
	@Override protected void preRenderCallback(${name}Entity entity, float partialTicks) {
		<#if hasProcedure(data.visualScale)>
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		float scale = (float) <@procedureOBJToNumberCode data.visualScale/>;
		GlStateManager.scale(scale, scale, scale);
		<#else>
		GlStateManager.scale(${data.visualScale.getFixedValue()?c}F, ${data.visualScale.getFixedValue()?c}F, ${data.visualScale.getFixedValue()?c}F);
		</#if>
	}
	</#if>

	@Override protected ResourceLocation getEntityTexture(${name}Entity entity) {
		return TEXTURE;
	}

	<#if data.transparentModelCondition?? && (hasProcedure(data.transparentModelCondition) || data.transparentModelCondition.getFixedValue())>
	@Override protected boolean isVisible(${name}Entity entity) {
		<#if hasProcedure(data.transparentModelCondition)>
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		return <@procedureOBJToConditionCode data.transparentModelCondition/>;
		<#else>
		return true;
		</#if>
	}
	</#if>

	<#if data.isShakingCondition?? && (hasProcedure(data.isShakingCondition) || data.isShakingCondition.getFixedValue())>
	@Override protected void applyRotations(${name}Entity entity, float ageInTicks, float rotationYaw, float partialTicks) {
		super.applyRotations(entity, ageInTicks, rotationYaw, partialTicks);
		<#if hasProcedure(data.isShakingCondition)>
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		if (<@procedureOBJToConditionCode data.isShakingCondition/>)
		</#if>
			GlStateManager.rotate(25.0F, 1.0F, 0.0F, 0.0F);
	}
	</#if>

	private static ResourceLocation getTexture(String path) {
		if (path.contains(":"))
			return new ResourceLocation(path);
		if (!path.endsWith(".png"))
			path += ".png";
		return new ResourceLocation("${modid}", "textures/entities/" + path);
	}

}
<#-- @formatter:on -->
