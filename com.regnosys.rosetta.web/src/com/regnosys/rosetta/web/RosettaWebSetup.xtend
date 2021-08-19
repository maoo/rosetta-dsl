/*
 * Copyright (c) REGnosys 2018 (www.regnosys.com) 
 */
package com.regnosys.rosetta.web

import com.google.inject.Guice
import com.google.inject.Injector
import com.regnosys.rosetta.RosettaRuntimeModule
import com.regnosys.rosetta.RosettaStandaloneSetup
import com.regnosys.rosetta.ide.RosettaIdeModule
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages in web applications.
 */
class RosettaWebSetup extends RosettaStandaloneSetup {
	
	override Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new RosettaRuntimeModule, new RosettaIdeModule, new RosettaWebModule))
	}
	
}
