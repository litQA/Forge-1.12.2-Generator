<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.client.gui;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.GuiButton;
import net.minecraft.client.gui.GuiButtonImage;
import net.minecraft.client.gui.inventory.GuiInventory;
import net.minecraft.client.gui.GuiTextField;
import net.minecraft.client.gui.inventory.GuiContainer;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.client.settings.KeyBinding;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.inventory.Container;
import net.minecraft.inventory.IInventory;
import net.minecraft.inventory.InventoryBasic;
import net.minecraft.inventory.Slot;
import net.minecraft.item.ItemStack;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.MathHelper;
import net.minecraft.util.text.TextComponentTranslation;
import net.minecraft.world.World;
import net.minecraftforge.fml.client.config.GuiCheckBox;
import net.minecraftforge.fml.client.config.GuiSlider;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import org.lwjgl.input.Keyboard;

import ${package}.${JavaModName};
import ${package}.init.${JavaModName}GUIs;
import ${package}.network.${name}GuiMessages;

<#assign textFields = data.getComponentsOfType("TextField")>
<#assign checkboxes = data.getComponentsOfType("Checkbox")>
<#assign buttons = data.getComponentsOfType("Button")>
<#assign imageButtons = data.getComponentsOfType("ImageButton")>
<#assign sliders = data.getComponentsOfType("Slider")>
<#assign tooltips = data.getComponentsOfType("Tooltip")>
<#assign slotnum = 0>

public class ${name}Gui {

	public static class ContainerMod extends Container implements Supplier<Map<Integer, Slot>> {

		public final World world;
		public final EntityPlayer entity;
		public final int x, y, z;

		private final IInventory internal;
		private final Map<Integer, Slot> customSlots = new HashMap<>();

		public ContainerMod(EntityPlayer player, World world, int x, int y, int z) {
			this.world = world;
			this.entity = player;
			this.x = x;
			this.y = y;
			this.z = z;
			this.internal = new InventoryBasic("", true, Math.max(1, ${data.getMaxSlotID() + 1}));

			<#if data.type == 1>
			<#list data.components as component>
			<#if component.getClass().getSimpleName()?ends_with("Slot")>
			<#assign slotnum += 1>
			this.customSlots.put(${component.id}, this.addSlotToContainer(new Slot(this.internal, ${component.id},
					${component.gx(data.width) + 1}, ${component.gy(data.height) + 1}) {
				private final int slot = ${component.id};

				<#if component.disablePickup?? && (hasProcedure(component.disablePickup) || component.disablePickup.getFixedValue())>
				@Override public boolean canTakeStack(EntityPlayer player) {
					return <@procedureOBJToConditionCode component.disablePickup/>;
				}
				</#if>

				<#if hasProcedure(component.onSlotChanged)>
				@Override public void onSlotChanged() {
					super.onSlotChanged();
					slotChanged(${component.id}, 0, 0);
				}
				</#if>

				<#if hasProcedure(component.onTakenFromSlot)>
				@Override public ItemStack onTake(EntityPlayer player, ItemStack stack) {
					slotChanged(${component.id}, 1, stack.getCount());
					return super.onTake(player, stack);
				}
				</#if>

				<#if hasProcedure(component.onStackTransfer)>
				@Override public void onSlotChange(ItemStack a, ItemStack b) {
					super.onSlotChange(a, b);
					slotChanged(${component.id}, 2, b.getCount() - a.getCount());
				}
				</#if>

				<#if component.getClass().getSimpleName() == "InputSlot">
				<#if component.disablePlacement?? && (hasProcedure(component.disablePlacement) || component.disablePlacement.getFixedValue())>
				@Override public boolean isItemValid(ItemStack stack) {
					return <@procedureOBJToConditionCode component.disablePlacement/>;
				}
				<#elseif component.inputLimit?? && component.inputLimit.getUnmappedValue()?has_content && !component.inputLimit.getUnmappedValue()?starts_with("TAG:")>
				@Override public boolean isItemValid(ItemStack stack) {
					return ${mappedMCItemToItem(component.inputLimit)} == stack.getItem();
				}
				</#if>
				<#elseif component.getClass().getSimpleName() == "OutputSlot">
				@Override public boolean isItemValid(ItemStack stack) {
					return false;
				}
				</#if>
			}));
			</#if>
			</#list>

			<#assign coffx = data.getInventorySlotsX()>
			<#assign coffy = data.getInventorySlotsY()>
			for (int si = 0; si < 3; ++si)
				for (int sj = 0; sj < 9; ++sj)
					this.addSlotToContainer(new Slot(player.inventory, sj + (si + 1) * 9,
							${coffx} + 8 + sj * 18, ${coffy} + 84 + si * 18));
			for (int si = 0; si < 9; ++si)
				this.addSlotToContainer(new Slot(player.inventory, si, ${coffx} + 8 + si * 18, ${coffy} + 142));
			</#if>

			if (!world.isRemote) {
				<#list textFields as component>
				${JavaModName}GUIs.State.putServer(player, "${component.getName()}", 0, "");
				</#list>
				<#list checkboxes as component>
				${JavaModName}GUIs.State.putServer(player, "${component.getName()}", 1, false);
				</#list>
				<#list sliders as component>
				${JavaModName}GUIs.State.putServer(player, "${component.getName()}", 2, ${component.value?c});
				</#list>
			}

			<#if hasProcedure(data.onOpen)>
			<@procedureOBJToCode data.onOpen/>
			</#if>
		}

		@Override public Map<Integer, Slot> get() {
			return this.customSlots;
		}

		@Override public boolean canInteractWith(EntityPlayer player) {
			return true;
		}

		<#if data.type == 1>
		@Override public ItemStack transferStackInSlot(EntityPlayer player, int index) {
			ItemStack itemstack = ItemStack.EMPTY;
			Slot slot = this.inventorySlots.get(index);
			if (slot != null && slot.getHasStack()) {
				ItemStack stack = slot.getStack();
				itemstack = stack.copy();
				if (index < ${slotnum}) {
					if (!this.mergeItemStack(stack, ${slotnum}, this.inventorySlots.size(), true))
						return ItemStack.EMPTY;
					slot.onSlotChange(stack, itemstack);
				} else if (!this.mergeItemStack(stack, 0, ${slotnum}, false)) {
					if (index < ${slotnum} + 27) {
						if (!this.mergeItemStack(stack, ${slotnum} + 27, this.inventorySlots.size(), true))
							return ItemStack.EMPTY;
					} else if (!this.mergeItemStack(stack, ${slotnum}, ${slotnum} + 27, false)) {
						return ItemStack.EMPTY;
					}
					return ItemStack.EMPTY;
				}

				if (stack.isEmpty())
					slot.putStack(ItemStack.EMPTY);
				else
					slot.onSlotChanged();

				if (stack.getCount() == itemstack.getCount())
					return ItemStack.EMPTY;

				slot.onTake(player, stack);
			}
			return itemstack;
		}
		</#if>

		@Override public void detectAndSendChanges() {
			super.detectAndSendChanges();
			<#if hasProcedure(data.onTick)>
			if (!this.world.isRemote) {
				<@procedureOBJToCode data.onTick/>
			}
			</#if>
		}

		@Override public void onContainerClosed(EntityPlayer player) {
			super.onContainerClosed(player);
			<#if hasProcedure(data.onClosed)>
			if (!player.world.isRemote) {
				<@procedureOBJToCode data.onClosed/>
			}
			</#if>

			if (!player.world.isRemote) {
				for (int i = 0; i < this.internal.getSizeInventory(); ++i) {
					ItemStack stack = this.internal.getStackInSlot(i);
					if (!stack.isEmpty()) {
						player.dropItem(stack, false);
						this.internal.setInventorySlotContents(i, ItemStack.EMPTY);
					}
				}
			}

			${JavaModName}GUIs.State.clearServer(player);
		}

		<#if data.hasSlotEvents()>
		private void slotChanged(int slotid, int type, int meta) {
			if (this.world != null && this.world.isRemote)
				${name}GuiMessages.sendSlot(slotid, type, meta, this.x, this.y, this.z);
		}
		</#if>
	}

	@SideOnly(Side.CLIENT) public static class GuiWindow extends GuiContainer {

		private final World world;
		private final int x, y, z;
		private final EntityPlayer entity;

		<#list textFields as component>
		private GuiTextField ${component.getName()};
		private String ${component.getName()}Last = "";
		</#list>
		<#list checkboxes as component>
		private GuiCheckBox ${component.getName()};
		private boolean ${component.getName()}Last = false;
		</#list>
		<#list sliders as component>
		private GuiSlider ${component.getName()};
		private double ${component.getName()}Last = 0;
		</#list>
		private boolean applyingState = false;

		<#if data.renderBgLayer>
		private static final ResourceLocation BACKGROUND = new ResourceLocation("${modid}:textures/screens/${registryname}.png");
		</#if>

		public GuiWindow(ContainerMod container) {
			super(container);
			this.world = container.world;
			this.x = container.x;
			this.y = container.y;
			this.z = container.z;
			this.entity = container.entity;
			this.xSize = ${data.width};
			this.ySize = ${data.height};
		}

		@Override public void initGui() {
			super.initGui();
			this.buttonList.clear();
			Keyboard.enableRepeatEvents(true);

			<#assign tfid = 0>
			<#list textFields as component>
			this.${component.getName()} = new GuiTextField(${tfid}, this.fontRenderer,
					this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
					${component.width}, ${component.height});
			this.${component.getName()}.setMaxStringLength(32767);
			this.${component.getName()}.setText(${JavaModName}GUIs.State.getClientString("${component.getName()}", ""));
			this.${component.getName()}Last = this.${component.getName()}.getText();
			<#assign tfid += 1>
			</#list>

			<#assign btid = 0>
			<#list buttons as component>
			this.buttonList.add(new GuiButton(${btid}, this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)}, ${component.width}, ${component.height},
					new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText()));
			<#assign btid += 1>
			</#list>

			<#list imageButtons as component>
			this.buttonList.add(new GuiButtonImage(${btid}, this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)}, ${component.getWidth(w.getWorkspace())},
					${component.getHeight(w.getWorkspace())}, 0, 0, ${component.getHeight(w.getWorkspace())},
					new ResourceLocation("${modid}:textures/screens/atlas/${component.getName()}.png")));
			<#assign btid += 1>
			</#list>

			<#list checkboxes as component>
			boolean ${component.getName()}Initial = <#if hasProcedure(component.isCheckedProcedure)><@procedureOBJToConditionCode component.isCheckedProcedure/><#else>false</#if>;
			this.${component.getName()} = new GuiCheckBox(${btid}, this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)},
					new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText(),
					${component.getName()}Initial);
			this.${component.getName()}Last = ${component.getName()}Initial;
			this.buttonList.add(this.${component.getName()});
			<#assign btid += 1>
			</#list>

			<#assign slid = 0>
			<#list sliders as component>
			this.${component.getName()} = new GuiSlider(${btid}, this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)}, ${component.width}, ${component.height},
					new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}_prefix").getUnformattedText(),
					new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}_suffix").getUnformattedText(),
					${component.min?c}, ${component.max?c}, ${component.value?c}, false, true, slider -> {
						if (!this.applyingState) {
							${JavaModName}GUIs.State.sendToServer("${component.getName()}", 2, slider.getValue());
							<#if data.hasSliderEvents()>
							${name}GuiMessages.sendSlider(${slid}, slider.getValue(), this.x, this.y, this.z);
							</#if>
						}
					});
			this.${component.getName()}Last = ${component.value?c};
			this.buttonList.add(this.${component.getName()});
			<#assign btid += 1>
			<#assign slid += 1>
			</#list>
		}

		@Override public void drawScreen(int mouseX, int mouseY, float partialTicks) {
			this.drawDefaultBackground();
			super.drawScreen(mouseX, mouseY, partialTicks);

			<#list textFields as component>
			this.${component.getName()}.drawTextBox();
			if (this.${component.getName()}.getText().isEmpty() && !this.${component.getName()}.isFocused()) {
				this.fontRenderer.drawString(new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText(),
						this.guiLeft + ${component.gx(data.width) + 4},
						this.guiTop + ${component.gy(data.height) + (component.height - 8) / 2}, 0x808080);
			}
			</#list>

			<#list data.getComponentsOfType("EntityModel") as component>
			<#if hasProcedure(component.entityModel)>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			if (<@procedureOBJToConditionCode component.entityModel/> instanceof EntityLivingBase) {
				GuiInventory.drawEntityOnScreen(this.guiLeft + ${component.gx(data.width) + 10},
						this.guiTop + ${component.gy(data.height) + 20}, ${component.scale},
						${component.rotationX / 20.0}F <#if component.followMouseMovement>+ (float) Math.atan((this.guiLeft + ${component.gx(data.width) + 10} - mouseX) / 40.0F)</#if>,
						<#if component.followMouseMovement>(float) Math.atan((this.guiTop + ${component.gy(data.height) + 21 - 50} - mouseY) / 40.0F)<#else>0.0F</#if>,
						(EntityLivingBase) <@procedureOBJToConditionCode component.entityModel/>);
			}
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#if>
			</#list>

			<#if tooltips?has_content>
			boolean customTooltipShown = false;
			</#if>
			<#list tooltips as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
			if (mouseX > this.guiLeft + ${component.gx(data.width)} && mouseX < this.guiLeft + ${component.gx(data.width) + component.width}
					&& mouseY > this.guiTop + ${component.gy(data.height)} && mouseY < this.guiTop + ${component.gy(data.height) + component.height}) {
				<#if hasProcedure(component.text)>
				String hoverText = <@procedureOBJToStringCode component.text/>;
				if (hoverText != null)
					this.drawHoveringText(Arrays.stream(hoverText.split("\n")).collect(Collectors.toList()), mouseX, mouseY);
				<#else>
				this.drawHoveringText(new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText(),
						mouseX, mouseY);
				</#if>
				customTooltipShown = true;
			}
			</#list>

			<#if tooltips?has_content>
			if (!customTooltipShown)
			</#if>
				this.renderHoveredToolTip(mouseX, mouseY);
		}

		@Override protected void drawGuiContainerBackgroundLayer(float partialTicks, int mouseX, int mouseY) {
			GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
			GlStateManager.enableBlend();
			GlStateManager.tryBlendFuncSeparate(GlStateManager.SourceFactor.SRC_ALPHA,
					GlStateManager.DestFactor.ONE_MINUS_SRC_ALPHA, GlStateManager.SourceFactor.ONE,
					GlStateManager.DestFactor.ZERO);

			<#if data.renderBgLayer>
			this.mc.getTextureManager().bindTexture(BACKGROUND);
			this.drawModalRectWithCustomSizedTexture(this.guiLeft, this.guiTop, 0, 0, this.xSize, this.ySize,
					this.xSize, this.ySize);
			</#if>

			<#list data.getComponentsOfType("Image") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			this.mc.getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
			this.drawModalRectWithCustomSizedTexture(this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)}, 0, 0,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#list>

			<#list data.getComponentsOfType("Sprite") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			this.mc.getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.sprite}"));
			this.drawModalRectWithCustomSizedTexture(this.guiLeft + ${component.gx(data.width)},
					this.guiTop + ${component.gy(data.height)},
					<#if component.getTextureWidth(w.getWorkspace()) gt component.getTextureHeight(w.getWorkspace())>
					<@getSpriteByIndex component "width"/>, 0
					<#else>
					0, <@getSpriteByIndex component "height"/>
					</#if>,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getTextureWidth(w.getWorkspace())}, ${component.getTextureHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#list>

			GlStateManager.disableBlend();
		}

		@Override protected void drawGuiContainerForegroundLayer(int mouseX, int mouseY) {
			<#list data.getComponentsOfType("Label") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
			this.fontRenderer.<#if component.hasShadow>drawStringWithShadow<#else>drawString</#if>(
					<#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>new TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText()</#if>,
					${component.gx(data.width)}, ${component.gy(data.height)}, ${component.color.getRGB()?c});
			</#list>
		}

		@Override public void updateScreen() {
			super.updateScreen();

			<#list textFields as component>
			String ${component.getName()}State = ${JavaModName}GUIs.State.getClientString("${component.getName()}", null);
			if (${component.getName()}State != null && !${component.getName()}State.equals(this.${component.getName()}.getText())) {
				this.${component.getName()}.setText(${component.getName()}State);
				this.${component.getName()}Last = ${component.getName()}State;
			}
			String ${component.getName()}Current = this.${component.getName()}.getText();
			if (!${component.getName()}Current.equals(this.${component.getName()}Last)) {
				this.${component.getName()}Last = ${component.getName()}Current;
				${JavaModName}GUIs.State.sendToServer("${component.getName()}", 0, ${component.getName()}Current);
			}
			this.${component.getName()}.updateCursorCounter();
			</#list>

			<#list checkboxes as component>
			Boolean ${component.getName()}State = ${JavaModName}GUIs.State.getClientBoolean("${component.getName()}");
			if (${component.getName()}State != null && ${component.getName()}State != this.${component.getName()}.isChecked()) {
				this.${component.getName()}.setIsChecked(${component.getName()}State);
				this.${component.getName()}Last = ${component.getName()}State;
			}
			if (this.${component.getName()}.isChecked() != this.${component.getName()}Last) {
				this.${component.getName()}Last = this.${component.getName()}.isChecked();
				${JavaModName}GUIs.State.sendToServer("${component.getName()}", 1, this.${component.getName()}.isChecked());
			}
			</#list>

			<#list sliders as component>
			Double ${component.getName()}State = ${JavaModName}GUIs.State.getClientDouble("${component.getName()}");
			if (${component.getName()}State != null && Math.abs(${component.getName()}State - this.${component.getName()}.getValue()) > 0.0001D) {
				this.applyingState = true;
				this.${component.getName()}.setValue(${component.getName()}State);
				this.applyingState = false;
				this.${component.getName()}Last = ${component.getName()}State;
			}
			</#list>

			<#list buttons as component>
			<#if hasProcedure(component.displayCondition)>
			this.buttonList.stream().filter(button -> button.id == ${component?index}).findFirst()
					.ifPresent(button -> button.visible = <@procedureOBJToConditionCode component.displayCondition/>);
			</#if>
			</#list>
			<#list imageButtons as component>
			<#if hasProcedure(component.displayCondition)>
			this.buttonList.stream().filter(button -> button.id == ${buttons?size + component?index}).findFirst()
					.ifPresent(button -> button.visible = <@procedureOBJToConditionCode component.displayCondition/>);
			</#if>
			</#list>
		}

		@Override protected void keyTyped(char typedChar, int keyCode) throws IOException {
			if (keyCode == 1) {
				<#list textFields as component>
				${JavaModName}GUIs.State.sendToServer("${component.getName()}", 0, this.${component.getName()}.getText());
				</#list>
				<#list checkboxes as component>
				${JavaModName}GUIs.State.sendToServer("${component.getName()}", 1, this.${component.getName()}.isChecked());
				</#list>
				<#list sliders as component>
				${JavaModName}GUIs.State.sendToServer("${component.getName()}", 2, this.${component.getName()}.getValue());
				</#list>
				this.mc.player.closeScreen();
				return;
			}

			<#list textFields as component>
			if (this.${component.getName()}.isFocused()) {
				this.${component.getName()}.textboxKeyTyped(typedChar, keyCode);
				return;
			}
			</#list>

			super.keyTyped(typedChar, keyCode);
		}

		@Override protected void mouseClicked(int mouseX, int mouseY, int mouseButton) throws IOException {
			<#list textFields as component>
			this.${component.getName()}.mouseClicked(mouseX, mouseY, mouseButton);
			</#list>
			super.mouseClicked(mouseX, mouseY, mouseButton);
		}

		@Override protected void actionPerformed(GuiButton button) {
			<#if data.hasButtonEvents()>
			<#assign index = 0>
			<#list buttons as component>
			if (button.id == ${index}) {
				${name}GuiMessages.sendButton(${index}, this.x, this.y, this.z);
				return;
			}
			<#assign index += 1>
			</#list>
			<#list imageButtons as component>
			if (button.id == ${index}) {
				${name}GuiMessages.sendButton(${index}, this.x, this.y, this.z);
				return;
			}
			<#assign index += 1>
			</#list>
			</#if>
		}

		@Override public void onGuiClosed() {
			super.onGuiClosed();
			Keyboard.enableRepeatEvents(false);
			${JavaModName}GUIs.State.clearClient();
		}

		<#if data.doesPauseGame>
		@Override public boolean doesGuiPauseGame() {
			return true;
		}
		</#if>
	}

}

<#macro getSpriteByIndex component dim>
	<#if hasProcedure(component.spriteIndex)>
		MathHelper.clamp((int) <@procedureOBJToNumberCode component.spriteIndex/>
			* <#if dim == "width">${component.getWidth(w.getWorkspace())}<#else>${component.getHeight(w.getWorkspace())}</#if>,
			0,
			<#if dim == "width">${component.getTextureWidth(w.getWorkspace()) - component.getWidth(w.getWorkspace())}<#else>${component.getTextureHeight(w.getWorkspace()) - component.getHeight(w.getWorkspace())}</#if>)
	<#else>
		<#if dim == "width">
			${component.getWidth(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		<#else>
			${component.getHeight(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		</#if>
	</#if>
</#macro>
<#-- @formatter:on -->

