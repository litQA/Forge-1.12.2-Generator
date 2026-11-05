<#include "/mcitems.ftl">
if (entity instanceof net.minecraft.entity.player.EntityPlayer) {
    net.minecraft.item.ItemStack _stack = ${mappedMCItemToItemStackCode(input$item, 1)};
    _stack.setCount(${input$amount});
    net.minecraftforge.items.ItemHandlerHelper.giveItemToPlayer((net.minecraft.entity.player.EntityPlayer) entity, _stack);
}
