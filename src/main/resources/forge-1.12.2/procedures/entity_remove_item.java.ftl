<#include "mcitems.ftl">
if (${input$entity} instanceof EntityPlayer) {
	ItemStack _stktoremove = ${mappedMCItemToItemStackCode(input$item, 1)};
	((EntityPlayer) ${input$entity}).inventory.clearMatchingItems(_stktoremove.getItem(), _stktoremove.getMetadata(), ${opt.toInt(input$amount)}, null);
}
