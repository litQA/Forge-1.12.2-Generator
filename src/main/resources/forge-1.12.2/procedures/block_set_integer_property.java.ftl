<#include "/mcitems.ftl">
<#if input$block??>
<#assign blockCode = mappedBlockToBlock(input$block)>
<#assign stateCode = mappedBlockToBlockStateCode(input$block)>
<#else>
<#assign blockCode = "blockstate.getBlock()">
<#assign stateCode = "blockstate">
</#if>
/*@BlockState*/(${blockCode}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyInteger
    ? ${stateCode}.withProperty((net.minecraft.block.properties.PropertyInteger) ${blockCode}.getBlockState().getProperty(${input$property}), ${input$value})
    : ${stateCode})
