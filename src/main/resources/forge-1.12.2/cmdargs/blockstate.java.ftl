if (!__commandExecuted && __argIndex < args.length) {
	CommandParameters.VALUES.put("${field$name}", args[__argIndex]);
	__argIndex++;
	${statement$args!""}
	__argIndex--;
}
