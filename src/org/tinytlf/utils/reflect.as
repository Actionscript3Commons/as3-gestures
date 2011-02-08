package org.tinytlf.utils
{
	import flash.utils.*;
	
	public function reflect(type:Object, refreshCache:Boolean = false):XML
	{
		const typeCache:Dictionary = ReflectionCache.cache;
		
		if(!(type is Class))
		{
			if(type is Proxy)
				type = getDefinitionByName(getQualifiedClassName(type)) as Class;
			else if(type is Number)
				type = Number;
			else
				type = type.constructor as Class;
		}
		
		if(refreshCache || typeCache[type] == null)
			typeCache[type] = flash.utils.describeType(type);
		
		return typeCache[type];
	}
}

import flash.utils.Dictionary;

internal class ReflectionCache
{
	public static const cache:Dictionary = new Dictionary(false);
}