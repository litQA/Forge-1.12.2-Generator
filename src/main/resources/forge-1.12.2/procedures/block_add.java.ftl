<#include "/mcitems.ftl">
<#if input$block??>
world.setBlockState(new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z}), ${mappedBlockToBlockStateCode(input$block)}, 3);
<#else>
/* block_add: input block was not provided */
</#if>
