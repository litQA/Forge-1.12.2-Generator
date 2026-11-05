<#include "/mcitems.ftl">
<#if input$block??>
<#assign blockCode = mappedBlockToBlock(input$block)>
<#assign stateCode = mappedBlockToBlockStateCode(input$block)>
<#else>
<#assign blockCode = "blockstate.getBlock()">
<#assign stateCode = "blockstate">
</#if>
/*@String*/((net.minecraft.block.properties.PropertyEnum) ${blockCode}.getBlockState().getProperty(${input$property}))
    .getName((Enum) ${stateCode}.getValue((net.minecraft.block.properties.IProperty) ${blockCode}.getBlockState().getProperty(${input$property})))
