/*
 * generated by Xtext 2.10.0
 */
package com.regnosys.rosetta.generator.java.object

import com.google.inject.Inject
import com.regnosys.rosetta.rosetta.RosettaAlias
import com.regnosys.rosetta.rosetta.RosettaCallableCall
import com.regnosys.rosetta.rosetta.RosettaEnumeration
import com.regnosys.rosetta.rosetta.RosettaEvent
import com.regnosys.rosetta.rosetta.RosettaExistsExpression
import com.regnosys.rosetta.tests.RosettaInjectorProvider
import com.regnosys.rosetta.tests.util.ModelHelper
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.*

@ExtendWith(InjectionExtension)
@InjectWith(RosettaInjectorProvider)
class RosettaModelTest{

	@Inject extension ModelHelper modelHelper
	
	@Test
	def void testEnumeration() {
		val model =
		'''
			enum QuoteRejectReasonEnum: <"The enumeration values.">
			[synonym ISO value "QuoteRejectReason" componentID 24]
				UnknownSymbol <"unknown symbol">
				[synonym ISO_20022 value "UK" definition "Unknown Symbol"]
				KnownSymbol
		'''.parseRosettaWithNoErrors
		
		val enum = model.elements.get(0) as RosettaEnumeration
		assertEquals("QuoteRejectReasonEnum", enum.name)
		assertEquals("The enumeration values.", enum.definition)
		
		val synonyms = enum.synonyms.get(0)
		assertEquals("ISO", synonyms.sources.head.getName())
		assertEquals("QuoteRejectReason", synonyms.body.values.get(0).getName())
		assertEquals("componentID", synonyms.body.values.get(0).refType.getName())
		assertEquals(24, synonyms.body.values.get(0).value)
		
		val enumValues1 = enum.enumValues.get(0)
		assertEquals("UnknownSymbol", enumValues1.name)
		assertEquals("unknown symbol", enumValues1.definition)
		
		val enumSynonyms = enumValues1.enumSynonyms.get(0)
		assertEquals("ISO_20022", enumSynonyms.sources.map[it.getName].join)

		assertEquals("UK", enumSynonyms.synonymValue)
		assertEquals("Unknown Symbol", enumSynonyms.definition)
		
		val enumValues2 = enum.enumValues.get(1) 
		assertEquals("KnownSymbol", enumValues2.name)
	}
	
	@Test
	def void testAlias() {
		val model =
		'''
			alias InflationSwap
			Swap -> inflationLeg
			
			alias IRS
			Swap -> interestLeg
			
			type Swap:
				inflationLeg string (0..*)
					[synonym FIX value "inflation"]
				interestLeg string (0..*)
		'''.parseRosettaWithNoErrors
		
		val alias = model.elements.get(0) as RosettaAlias
		assertEquals("InflationSwap", alias.name)
	}
	
	@Test
	def void testAliasWithDistinctResourceSet() {
		
		val resource1 = 
		'''
			alias IRS
			Swap -> interestLeg
		'''
		
		val resource2 =
		'''
			type Swap:
				inflationLeg string (0..*)
				interestLeg string (0..*)
			
			isEvent Foo
				IRS exists
		'''
		
		val model = modelHelper.combineAndParseRosetta(resource1, resource2)
				
		val isEvents = model.elements.filter(RosettaEvent)
		assertEquals(1, isEvents.size)
		val isEventExpr = isEvents.get(0).expression
		assertTrue(isEventExpr instanceof RosettaExistsExpression)
		val argument = (isEventExpr as RosettaExistsExpression).argument
		assertTrue(argument instanceof RosettaCallableCall)
		assertEquals("IRS", (argument as RosettaCallableCall).callable.name)
	}
}
