<#include "/mcitems.ftl">
<#if input$block??>
<#assign blockCode = mappedBlockToBlock(input$block)>
<#assign stateCode = mappedBlockToBlockStateCode(input$block)>
<#else>
<#assign blockCode = "blockstate.getBlock()">
<#assign stateCode = "blockstate">
</#if>
/*@int*/(${blockCode}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyInteger
    ? ${stateCode}.getValue((net.minecraft.block.properties.PropertyInteger) ${blockCode}.getBlockState().getProperty(${input$property})) : -1)
