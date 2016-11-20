
// Generated from vhdl.g4 by ANTLR 4.6

#pragma once


#include "antlr4-runtime.h"
#include "vhdlParser.h"


namespace vhdl {

/**
 * This interface defines an abstract listener for a parse tree produced by vhdlParser.
 */
class vhdlListener : public antlr4::tree::ParseTreeListener {
public:

  virtual void enterAbstract_literal(vhdlParser::Abstract_literalContext *ctx) = 0;
  virtual void exitAbstract_literal(vhdlParser::Abstract_literalContext *ctx) = 0;

  virtual void enterAccess_type_definition(vhdlParser::Access_type_definitionContext *ctx) = 0;
  virtual void exitAccess_type_definition(vhdlParser::Access_type_definitionContext *ctx) = 0;

  virtual void enterAcross_aspect(vhdlParser::Across_aspectContext *ctx) = 0;
  virtual void exitAcross_aspect(vhdlParser::Across_aspectContext *ctx) = 0;

  virtual void enterActual_designator(vhdlParser::Actual_designatorContext *ctx) = 0;
  virtual void exitActual_designator(vhdlParser::Actual_designatorContext *ctx) = 0;

  virtual void enterActual_parameter_part(vhdlParser::Actual_parameter_partContext *ctx) = 0;
  virtual void exitActual_parameter_part(vhdlParser::Actual_parameter_partContext *ctx) = 0;

  virtual void enterActual_part(vhdlParser::Actual_partContext *ctx) = 0;
  virtual void exitActual_part(vhdlParser::Actual_partContext *ctx) = 0;

  virtual void enterAdding_operator(vhdlParser::Adding_operatorContext *ctx) = 0;
  virtual void exitAdding_operator(vhdlParser::Adding_operatorContext *ctx) = 0;

  virtual void enterAggregate(vhdlParser::AggregateContext *ctx) = 0;
  virtual void exitAggregate(vhdlParser::AggregateContext *ctx) = 0;

  virtual void enterAlias_declaration(vhdlParser::Alias_declarationContext *ctx) = 0;
  virtual void exitAlias_declaration(vhdlParser::Alias_declarationContext *ctx) = 0;

  virtual void enterAlias_designator(vhdlParser::Alias_designatorContext *ctx) = 0;
  virtual void exitAlias_designator(vhdlParser::Alias_designatorContext *ctx) = 0;

  virtual void enterAlias_indication(vhdlParser::Alias_indicationContext *ctx) = 0;
  virtual void exitAlias_indication(vhdlParser::Alias_indicationContext *ctx) = 0;

  virtual void enterAllocator(vhdlParser::AllocatorContext *ctx) = 0;
  virtual void exitAllocator(vhdlParser::AllocatorContext *ctx) = 0;

  virtual void enterArchitecture_body(vhdlParser::Architecture_bodyContext *ctx) = 0;
  virtual void exitArchitecture_body(vhdlParser::Architecture_bodyContext *ctx) = 0;

  virtual void enterArchitecture_declarative_part(vhdlParser::Architecture_declarative_partContext *ctx) = 0;
  virtual void exitArchitecture_declarative_part(vhdlParser::Architecture_declarative_partContext *ctx) = 0;

  virtual void enterArchitecture_statement(vhdlParser::Architecture_statementContext *ctx) = 0;
  virtual void exitArchitecture_statement(vhdlParser::Architecture_statementContext *ctx) = 0;

  virtual void enterArchitecture_statement_part(vhdlParser::Architecture_statement_partContext *ctx) = 0;
  virtual void exitArchitecture_statement_part(vhdlParser::Architecture_statement_partContext *ctx) = 0;

  virtual void enterArray_nature_definition(vhdlParser::Array_nature_definitionContext *ctx) = 0;
  virtual void exitArray_nature_definition(vhdlParser::Array_nature_definitionContext *ctx) = 0;

  virtual void enterArray_type_definition(vhdlParser::Array_type_definitionContext *ctx) = 0;
  virtual void exitArray_type_definition(vhdlParser::Array_type_definitionContext *ctx) = 0;

  virtual void enterAssertion(vhdlParser::AssertionContext *ctx) = 0;
  virtual void exitAssertion(vhdlParser::AssertionContext *ctx) = 0;

  virtual void enterAssertion_statement(vhdlParser::Assertion_statementContext *ctx) = 0;
  virtual void exitAssertion_statement(vhdlParser::Assertion_statementContext *ctx) = 0;

  virtual void enterAssociation_element(vhdlParser::Association_elementContext *ctx) = 0;
  virtual void exitAssociation_element(vhdlParser::Association_elementContext *ctx) = 0;

  virtual void enterAssociation_list(vhdlParser::Association_listContext *ctx) = 0;
  virtual void exitAssociation_list(vhdlParser::Association_listContext *ctx) = 0;

  virtual void enterAttribute_declaration(vhdlParser::Attribute_declarationContext *ctx) = 0;
  virtual void exitAttribute_declaration(vhdlParser::Attribute_declarationContext *ctx) = 0;

  virtual void enterAttribute_designator(vhdlParser::Attribute_designatorContext *ctx) = 0;
  virtual void exitAttribute_designator(vhdlParser::Attribute_designatorContext *ctx) = 0;

  virtual void enterAttribute_specification(vhdlParser::Attribute_specificationContext *ctx) = 0;
  virtual void exitAttribute_specification(vhdlParser::Attribute_specificationContext *ctx) = 0;

  virtual void enterBase_unit_declaration(vhdlParser::Base_unit_declarationContext *ctx) = 0;
  virtual void exitBase_unit_declaration(vhdlParser::Base_unit_declarationContext *ctx) = 0;

  virtual void enterBinding_indication(vhdlParser::Binding_indicationContext *ctx) = 0;
  virtual void exitBinding_indication(vhdlParser::Binding_indicationContext *ctx) = 0;

  virtual void enterBlock_configuration(vhdlParser::Block_configurationContext *ctx) = 0;
  virtual void exitBlock_configuration(vhdlParser::Block_configurationContext *ctx) = 0;

  virtual void enterBlock_declarative_item(vhdlParser::Block_declarative_itemContext *ctx) = 0;
  virtual void exitBlock_declarative_item(vhdlParser::Block_declarative_itemContext *ctx) = 0;

  virtual void enterBlock_declarative_part(vhdlParser::Block_declarative_partContext *ctx) = 0;
  virtual void exitBlock_declarative_part(vhdlParser::Block_declarative_partContext *ctx) = 0;

  virtual void enterBlock_header(vhdlParser::Block_headerContext *ctx) = 0;
  virtual void exitBlock_header(vhdlParser::Block_headerContext *ctx) = 0;

  virtual void enterBlock_specification(vhdlParser::Block_specificationContext *ctx) = 0;
  virtual void exitBlock_specification(vhdlParser::Block_specificationContext *ctx) = 0;

  virtual void enterBlock_statement(vhdlParser::Block_statementContext *ctx) = 0;
  virtual void exitBlock_statement(vhdlParser::Block_statementContext *ctx) = 0;

  virtual void enterBlock_statement_part(vhdlParser::Block_statement_partContext *ctx) = 0;
  virtual void exitBlock_statement_part(vhdlParser::Block_statement_partContext *ctx) = 0;

  virtual void enterBranch_quantity_declaration(vhdlParser::Branch_quantity_declarationContext *ctx) = 0;
  virtual void exitBranch_quantity_declaration(vhdlParser::Branch_quantity_declarationContext *ctx) = 0;

  virtual void enterBreak_element(vhdlParser::Break_elementContext *ctx) = 0;
  virtual void exitBreak_element(vhdlParser::Break_elementContext *ctx) = 0;

  virtual void enterBreak_list(vhdlParser::Break_listContext *ctx) = 0;
  virtual void exitBreak_list(vhdlParser::Break_listContext *ctx) = 0;

  virtual void enterBreak_selector_clause(vhdlParser::Break_selector_clauseContext *ctx) = 0;
  virtual void exitBreak_selector_clause(vhdlParser::Break_selector_clauseContext *ctx) = 0;

  virtual void enterBreak_statement(vhdlParser::Break_statementContext *ctx) = 0;
  virtual void exitBreak_statement(vhdlParser::Break_statementContext *ctx) = 0;

  virtual void enterCase_statement(vhdlParser::Case_statementContext *ctx) = 0;
  virtual void exitCase_statement(vhdlParser::Case_statementContext *ctx) = 0;

  virtual void enterCase_statement_alternative(vhdlParser::Case_statement_alternativeContext *ctx) = 0;
  virtual void exitCase_statement_alternative(vhdlParser::Case_statement_alternativeContext *ctx) = 0;

  virtual void enterChoice(vhdlParser::ChoiceContext *ctx) = 0;
  virtual void exitChoice(vhdlParser::ChoiceContext *ctx) = 0;

  virtual void enterChoices(vhdlParser::ChoicesContext *ctx) = 0;
  virtual void exitChoices(vhdlParser::ChoicesContext *ctx) = 0;

  virtual void enterComponent_configuration(vhdlParser::Component_configurationContext *ctx) = 0;
  virtual void exitComponent_configuration(vhdlParser::Component_configurationContext *ctx) = 0;

  virtual void enterComponent_declaration(vhdlParser::Component_declarationContext *ctx) = 0;
  virtual void exitComponent_declaration(vhdlParser::Component_declarationContext *ctx) = 0;

  virtual void enterComponent_instantiation_statement(vhdlParser::Component_instantiation_statementContext *ctx) = 0;
  virtual void exitComponent_instantiation_statement(vhdlParser::Component_instantiation_statementContext *ctx) = 0;

  virtual void enterComponent_specification(vhdlParser::Component_specificationContext *ctx) = 0;
  virtual void exitComponent_specification(vhdlParser::Component_specificationContext *ctx) = 0;

  virtual void enterComposite_nature_definition(vhdlParser::Composite_nature_definitionContext *ctx) = 0;
  virtual void exitComposite_nature_definition(vhdlParser::Composite_nature_definitionContext *ctx) = 0;

  virtual void enterComposite_type_definition(vhdlParser::Composite_type_definitionContext *ctx) = 0;
  virtual void exitComposite_type_definition(vhdlParser::Composite_type_definitionContext *ctx) = 0;

  virtual void enterConcurrent_assertion_statement(vhdlParser::Concurrent_assertion_statementContext *ctx) = 0;
  virtual void exitConcurrent_assertion_statement(vhdlParser::Concurrent_assertion_statementContext *ctx) = 0;

  virtual void enterConcurrent_break_statement(vhdlParser::Concurrent_break_statementContext *ctx) = 0;
  virtual void exitConcurrent_break_statement(vhdlParser::Concurrent_break_statementContext *ctx) = 0;

  virtual void enterConcurrent_procedure_call_statement(vhdlParser::Concurrent_procedure_call_statementContext *ctx) = 0;
  virtual void exitConcurrent_procedure_call_statement(vhdlParser::Concurrent_procedure_call_statementContext *ctx) = 0;

  virtual void enterConcurrent_signal_assignment_statement(vhdlParser::Concurrent_signal_assignment_statementContext *ctx) = 0;
  virtual void exitConcurrent_signal_assignment_statement(vhdlParser::Concurrent_signal_assignment_statementContext *ctx) = 0;

  virtual void enterCondition(vhdlParser::ConditionContext *ctx) = 0;
  virtual void exitCondition(vhdlParser::ConditionContext *ctx) = 0;

  virtual void enterCondition_clause(vhdlParser::Condition_clauseContext *ctx) = 0;
  virtual void exitCondition_clause(vhdlParser::Condition_clauseContext *ctx) = 0;

  virtual void enterConditional_signal_assignment(vhdlParser::Conditional_signal_assignmentContext *ctx) = 0;
  virtual void exitConditional_signal_assignment(vhdlParser::Conditional_signal_assignmentContext *ctx) = 0;

  virtual void enterConditional_waveforms(vhdlParser::Conditional_waveformsContext *ctx) = 0;
  virtual void exitConditional_waveforms(vhdlParser::Conditional_waveformsContext *ctx) = 0;

  virtual void enterConfiguration_declaration(vhdlParser::Configuration_declarationContext *ctx) = 0;
  virtual void exitConfiguration_declaration(vhdlParser::Configuration_declarationContext *ctx) = 0;

  virtual void enterConfiguration_declarative_item(vhdlParser::Configuration_declarative_itemContext *ctx) = 0;
  virtual void exitConfiguration_declarative_item(vhdlParser::Configuration_declarative_itemContext *ctx) = 0;

  virtual void enterConfiguration_declarative_part(vhdlParser::Configuration_declarative_partContext *ctx) = 0;
  virtual void exitConfiguration_declarative_part(vhdlParser::Configuration_declarative_partContext *ctx) = 0;

  virtual void enterConfiguration_item(vhdlParser::Configuration_itemContext *ctx) = 0;
  virtual void exitConfiguration_item(vhdlParser::Configuration_itemContext *ctx) = 0;

  virtual void enterConfiguration_specification(vhdlParser::Configuration_specificationContext *ctx) = 0;
  virtual void exitConfiguration_specification(vhdlParser::Configuration_specificationContext *ctx) = 0;

  virtual void enterConstant_declaration(vhdlParser::Constant_declarationContext *ctx) = 0;
  virtual void exitConstant_declaration(vhdlParser::Constant_declarationContext *ctx) = 0;

  virtual void enterConstrained_array_definition(vhdlParser::Constrained_array_definitionContext *ctx) = 0;
  virtual void exitConstrained_array_definition(vhdlParser::Constrained_array_definitionContext *ctx) = 0;

  virtual void enterConstrained_nature_definition(vhdlParser::Constrained_nature_definitionContext *ctx) = 0;
  virtual void exitConstrained_nature_definition(vhdlParser::Constrained_nature_definitionContext *ctx) = 0;

  virtual void enterConstraint(vhdlParser::ConstraintContext *ctx) = 0;
  virtual void exitConstraint(vhdlParser::ConstraintContext *ctx) = 0;

  virtual void enterContext_clause(vhdlParser::Context_clauseContext *ctx) = 0;
  virtual void exitContext_clause(vhdlParser::Context_clauseContext *ctx) = 0;

  virtual void enterContext_item(vhdlParser::Context_itemContext *ctx) = 0;
  virtual void exitContext_item(vhdlParser::Context_itemContext *ctx) = 0;

  virtual void enterDelay_mechanism(vhdlParser::Delay_mechanismContext *ctx) = 0;
  virtual void exitDelay_mechanism(vhdlParser::Delay_mechanismContext *ctx) = 0;

  virtual void enterDesign_file(vhdlParser::Design_fileContext *ctx) = 0;
  virtual void exitDesign_file(vhdlParser::Design_fileContext *ctx) = 0;

  virtual void enterDesign_unit(vhdlParser::Design_unitContext *ctx) = 0;
  virtual void exitDesign_unit(vhdlParser::Design_unitContext *ctx) = 0;

  virtual void enterDesignator(vhdlParser::DesignatorContext *ctx) = 0;
  virtual void exitDesignator(vhdlParser::DesignatorContext *ctx) = 0;

  virtual void enterDirection(vhdlParser::DirectionContext *ctx) = 0;
  virtual void exitDirection(vhdlParser::DirectionContext *ctx) = 0;

  virtual void enterDisconnection_specification(vhdlParser::Disconnection_specificationContext *ctx) = 0;
  virtual void exitDisconnection_specification(vhdlParser::Disconnection_specificationContext *ctx) = 0;

  virtual void enterDiscrete_range(vhdlParser::Discrete_rangeContext *ctx) = 0;
  virtual void exitDiscrete_range(vhdlParser::Discrete_rangeContext *ctx) = 0;

  virtual void enterElement_association(vhdlParser::Element_associationContext *ctx) = 0;
  virtual void exitElement_association(vhdlParser::Element_associationContext *ctx) = 0;

  virtual void enterElement_declaration(vhdlParser::Element_declarationContext *ctx) = 0;
  virtual void exitElement_declaration(vhdlParser::Element_declarationContext *ctx) = 0;

  virtual void enterElement_subnature_definition(vhdlParser::Element_subnature_definitionContext *ctx) = 0;
  virtual void exitElement_subnature_definition(vhdlParser::Element_subnature_definitionContext *ctx) = 0;

  virtual void enterElement_subtype_definition(vhdlParser::Element_subtype_definitionContext *ctx) = 0;
  virtual void exitElement_subtype_definition(vhdlParser::Element_subtype_definitionContext *ctx) = 0;

  virtual void enterEntity_aspect(vhdlParser::Entity_aspectContext *ctx) = 0;
  virtual void exitEntity_aspect(vhdlParser::Entity_aspectContext *ctx) = 0;

  virtual void enterEntity_class(vhdlParser::Entity_classContext *ctx) = 0;
  virtual void exitEntity_class(vhdlParser::Entity_classContext *ctx) = 0;

  virtual void enterEntity_class_entry(vhdlParser::Entity_class_entryContext *ctx) = 0;
  virtual void exitEntity_class_entry(vhdlParser::Entity_class_entryContext *ctx) = 0;

  virtual void enterEntity_class_entry_list(vhdlParser::Entity_class_entry_listContext *ctx) = 0;
  virtual void exitEntity_class_entry_list(vhdlParser::Entity_class_entry_listContext *ctx) = 0;

  virtual void enterEntity_declaration(vhdlParser::Entity_declarationContext *ctx) = 0;
  virtual void exitEntity_declaration(vhdlParser::Entity_declarationContext *ctx) = 0;

  virtual void enterEntity_declarative_item(vhdlParser::Entity_declarative_itemContext *ctx) = 0;
  virtual void exitEntity_declarative_item(vhdlParser::Entity_declarative_itemContext *ctx) = 0;

  virtual void enterEntity_declarative_part(vhdlParser::Entity_declarative_partContext *ctx) = 0;
  virtual void exitEntity_declarative_part(vhdlParser::Entity_declarative_partContext *ctx) = 0;

  virtual void enterEntity_designator(vhdlParser::Entity_designatorContext *ctx) = 0;
  virtual void exitEntity_designator(vhdlParser::Entity_designatorContext *ctx) = 0;

  virtual void enterEntity_header(vhdlParser::Entity_headerContext *ctx) = 0;
  virtual void exitEntity_header(vhdlParser::Entity_headerContext *ctx) = 0;

  virtual void enterEntity_name_list(vhdlParser::Entity_name_listContext *ctx) = 0;
  virtual void exitEntity_name_list(vhdlParser::Entity_name_listContext *ctx) = 0;

  virtual void enterEntity_specification(vhdlParser::Entity_specificationContext *ctx) = 0;
  virtual void exitEntity_specification(vhdlParser::Entity_specificationContext *ctx) = 0;

  virtual void enterEntity_statement(vhdlParser::Entity_statementContext *ctx) = 0;
  virtual void exitEntity_statement(vhdlParser::Entity_statementContext *ctx) = 0;

  virtual void enterEntity_statement_part(vhdlParser::Entity_statement_partContext *ctx) = 0;
  virtual void exitEntity_statement_part(vhdlParser::Entity_statement_partContext *ctx) = 0;

  virtual void enterEntity_tag(vhdlParser::Entity_tagContext *ctx) = 0;
  virtual void exitEntity_tag(vhdlParser::Entity_tagContext *ctx) = 0;

  virtual void enterEnumeration_literal(vhdlParser::Enumeration_literalContext *ctx) = 0;
  virtual void exitEnumeration_literal(vhdlParser::Enumeration_literalContext *ctx) = 0;

  virtual void enterEnumeration_type_definition(vhdlParser::Enumeration_type_definitionContext *ctx) = 0;
  virtual void exitEnumeration_type_definition(vhdlParser::Enumeration_type_definitionContext *ctx) = 0;

  virtual void enterExit_statement(vhdlParser::Exit_statementContext *ctx) = 0;
  virtual void exitExit_statement(vhdlParser::Exit_statementContext *ctx) = 0;

  virtual void enterExpression(vhdlParser::ExpressionContext *ctx) = 0;
  virtual void exitExpression(vhdlParser::ExpressionContext *ctx) = 0;

  virtual void enterFactor(vhdlParser::FactorContext *ctx) = 0;
  virtual void exitFactor(vhdlParser::FactorContext *ctx) = 0;

  virtual void enterFile_declaration(vhdlParser::File_declarationContext *ctx) = 0;
  virtual void exitFile_declaration(vhdlParser::File_declarationContext *ctx) = 0;

  virtual void enterFile_logical_name(vhdlParser::File_logical_nameContext *ctx) = 0;
  virtual void exitFile_logical_name(vhdlParser::File_logical_nameContext *ctx) = 0;

  virtual void enterFile_open_information(vhdlParser::File_open_informationContext *ctx) = 0;
  virtual void exitFile_open_information(vhdlParser::File_open_informationContext *ctx) = 0;

  virtual void enterFile_type_definition(vhdlParser::File_type_definitionContext *ctx) = 0;
  virtual void exitFile_type_definition(vhdlParser::File_type_definitionContext *ctx) = 0;

  virtual void enterFormal_parameter_list(vhdlParser::Formal_parameter_listContext *ctx) = 0;
  virtual void exitFormal_parameter_list(vhdlParser::Formal_parameter_listContext *ctx) = 0;

  virtual void enterFormal_part(vhdlParser::Formal_partContext *ctx) = 0;
  virtual void exitFormal_part(vhdlParser::Formal_partContext *ctx) = 0;

  virtual void enterFree_quantity_declaration(vhdlParser::Free_quantity_declarationContext *ctx) = 0;
  virtual void exitFree_quantity_declaration(vhdlParser::Free_quantity_declarationContext *ctx) = 0;

  virtual void enterGenerate_statement(vhdlParser::Generate_statementContext *ctx) = 0;
  virtual void exitGenerate_statement(vhdlParser::Generate_statementContext *ctx) = 0;

  virtual void enterGeneration_scheme(vhdlParser::Generation_schemeContext *ctx) = 0;
  virtual void exitGeneration_scheme(vhdlParser::Generation_schemeContext *ctx) = 0;

  virtual void enterGeneric_clause(vhdlParser::Generic_clauseContext *ctx) = 0;
  virtual void exitGeneric_clause(vhdlParser::Generic_clauseContext *ctx) = 0;

  virtual void enterGeneric_list(vhdlParser::Generic_listContext *ctx) = 0;
  virtual void exitGeneric_list(vhdlParser::Generic_listContext *ctx) = 0;

  virtual void enterGeneric_map_aspect(vhdlParser::Generic_map_aspectContext *ctx) = 0;
  virtual void exitGeneric_map_aspect(vhdlParser::Generic_map_aspectContext *ctx) = 0;

  virtual void enterGroup_constituent(vhdlParser::Group_constituentContext *ctx) = 0;
  virtual void exitGroup_constituent(vhdlParser::Group_constituentContext *ctx) = 0;

  virtual void enterGroup_constituent_list(vhdlParser::Group_constituent_listContext *ctx) = 0;
  virtual void exitGroup_constituent_list(vhdlParser::Group_constituent_listContext *ctx) = 0;

  virtual void enterGroup_declaration(vhdlParser::Group_declarationContext *ctx) = 0;
  virtual void exitGroup_declaration(vhdlParser::Group_declarationContext *ctx) = 0;

  virtual void enterGroup_template_declaration(vhdlParser::Group_template_declarationContext *ctx) = 0;
  virtual void exitGroup_template_declaration(vhdlParser::Group_template_declarationContext *ctx) = 0;

  virtual void enterGuarded_signal_specification(vhdlParser::Guarded_signal_specificationContext *ctx) = 0;
  virtual void exitGuarded_signal_specification(vhdlParser::Guarded_signal_specificationContext *ctx) = 0;

  virtual void enterIdentifier(vhdlParser::IdentifierContext *ctx) = 0;
  virtual void exitIdentifier(vhdlParser::IdentifierContext *ctx) = 0;

  virtual void enterIdentifier_list(vhdlParser::Identifier_listContext *ctx) = 0;
  virtual void exitIdentifier_list(vhdlParser::Identifier_listContext *ctx) = 0;

  virtual void enterIf_statement(vhdlParser::If_statementContext *ctx) = 0;
  virtual void exitIf_statement(vhdlParser::If_statementContext *ctx) = 0;

  virtual void enterIndex_constraint(vhdlParser::Index_constraintContext *ctx) = 0;
  virtual void exitIndex_constraint(vhdlParser::Index_constraintContext *ctx) = 0;

  virtual void enterIndex_specification(vhdlParser::Index_specificationContext *ctx) = 0;
  virtual void exitIndex_specification(vhdlParser::Index_specificationContext *ctx) = 0;

  virtual void enterIndex_subtype_definition(vhdlParser::Index_subtype_definitionContext *ctx) = 0;
  virtual void exitIndex_subtype_definition(vhdlParser::Index_subtype_definitionContext *ctx) = 0;

  virtual void enterInstantiated_unit(vhdlParser::Instantiated_unitContext *ctx) = 0;
  virtual void exitInstantiated_unit(vhdlParser::Instantiated_unitContext *ctx) = 0;

  virtual void enterInstantiation_list(vhdlParser::Instantiation_listContext *ctx) = 0;
  virtual void exitInstantiation_list(vhdlParser::Instantiation_listContext *ctx) = 0;

  virtual void enterInterface_constant_declaration(vhdlParser::Interface_constant_declarationContext *ctx) = 0;
  virtual void exitInterface_constant_declaration(vhdlParser::Interface_constant_declarationContext *ctx) = 0;

  virtual void enterInterface_declaration(vhdlParser::Interface_declarationContext *ctx) = 0;
  virtual void exitInterface_declaration(vhdlParser::Interface_declarationContext *ctx) = 0;

  virtual void enterInterface_element(vhdlParser::Interface_elementContext *ctx) = 0;
  virtual void exitInterface_element(vhdlParser::Interface_elementContext *ctx) = 0;

  virtual void enterInterface_file_declaration(vhdlParser::Interface_file_declarationContext *ctx) = 0;
  virtual void exitInterface_file_declaration(vhdlParser::Interface_file_declarationContext *ctx) = 0;

  virtual void enterInterface_signal_list(vhdlParser::Interface_signal_listContext *ctx) = 0;
  virtual void exitInterface_signal_list(vhdlParser::Interface_signal_listContext *ctx) = 0;

  virtual void enterInterface_port_list(vhdlParser::Interface_port_listContext *ctx) = 0;
  virtual void exitInterface_port_list(vhdlParser::Interface_port_listContext *ctx) = 0;

  virtual void enterInterface_list(vhdlParser::Interface_listContext *ctx) = 0;
  virtual void exitInterface_list(vhdlParser::Interface_listContext *ctx) = 0;

  virtual void enterInterface_quantity_declaration(vhdlParser::Interface_quantity_declarationContext *ctx) = 0;
  virtual void exitInterface_quantity_declaration(vhdlParser::Interface_quantity_declarationContext *ctx) = 0;

  virtual void enterInterface_port_declaration(vhdlParser::Interface_port_declarationContext *ctx) = 0;
  virtual void exitInterface_port_declaration(vhdlParser::Interface_port_declarationContext *ctx) = 0;

  virtual void enterInterface_signal_declaration(vhdlParser::Interface_signal_declarationContext *ctx) = 0;
  virtual void exitInterface_signal_declaration(vhdlParser::Interface_signal_declarationContext *ctx) = 0;

  virtual void enterInterface_terminal_declaration(vhdlParser::Interface_terminal_declarationContext *ctx) = 0;
  virtual void exitInterface_terminal_declaration(vhdlParser::Interface_terminal_declarationContext *ctx) = 0;

  virtual void enterInterface_variable_declaration(vhdlParser::Interface_variable_declarationContext *ctx) = 0;
  virtual void exitInterface_variable_declaration(vhdlParser::Interface_variable_declarationContext *ctx) = 0;

  virtual void enterIteration_scheme(vhdlParser::Iteration_schemeContext *ctx) = 0;
  virtual void exitIteration_scheme(vhdlParser::Iteration_schemeContext *ctx) = 0;

  virtual void enterLabel_colon(vhdlParser::Label_colonContext *ctx) = 0;
  virtual void exitLabel_colon(vhdlParser::Label_colonContext *ctx) = 0;

  virtual void enterLibrary_clause(vhdlParser::Library_clauseContext *ctx) = 0;
  virtual void exitLibrary_clause(vhdlParser::Library_clauseContext *ctx) = 0;

  virtual void enterLibrary_unit(vhdlParser::Library_unitContext *ctx) = 0;
  virtual void exitLibrary_unit(vhdlParser::Library_unitContext *ctx) = 0;

  virtual void enterLiteral(vhdlParser::LiteralContext *ctx) = 0;
  virtual void exitLiteral(vhdlParser::LiteralContext *ctx) = 0;

  virtual void enterLogical_name(vhdlParser::Logical_nameContext *ctx) = 0;
  virtual void exitLogical_name(vhdlParser::Logical_nameContext *ctx) = 0;

  virtual void enterLogical_name_list(vhdlParser::Logical_name_listContext *ctx) = 0;
  virtual void exitLogical_name_list(vhdlParser::Logical_name_listContext *ctx) = 0;

  virtual void enterLogical_operator(vhdlParser::Logical_operatorContext *ctx) = 0;
  virtual void exitLogical_operator(vhdlParser::Logical_operatorContext *ctx) = 0;

  virtual void enterLoop_statement(vhdlParser::Loop_statementContext *ctx) = 0;
  virtual void exitLoop_statement(vhdlParser::Loop_statementContext *ctx) = 0;

  virtual void enterSignal_mode(vhdlParser::Signal_modeContext *ctx) = 0;
  virtual void exitSignal_mode(vhdlParser::Signal_modeContext *ctx) = 0;

  virtual void enterMultiplying_operator(vhdlParser::Multiplying_operatorContext *ctx) = 0;
  virtual void exitMultiplying_operator(vhdlParser::Multiplying_operatorContext *ctx) = 0;

  virtual void enterName(vhdlParser::NameContext *ctx) = 0;
  virtual void exitName(vhdlParser::NameContext *ctx) = 0;

  virtual void enterName_part(vhdlParser::Name_partContext *ctx) = 0;
  virtual void exitName_part(vhdlParser::Name_partContext *ctx) = 0;

  virtual void enterName_part_specificator(vhdlParser::Name_part_specificatorContext *ctx) = 0;
  virtual void exitName_part_specificator(vhdlParser::Name_part_specificatorContext *ctx) = 0;

  virtual void enterName_attribute_part(vhdlParser::Name_attribute_partContext *ctx) = 0;
  virtual void exitName_attribute_part(vhdlParser::Name_attribute_partContext *ctx) = 0;

  virtual void enterName_function_call_or_indexed_part(vhdlParser::Name_function_call_or_indexed_partContext *ctx) = 0;
  virtual void exitName_function_call_or_indexed_part(vhdlParser::Name_function_call_or_indexed_partContext *ctx) = 0;

  virtual void enterName_slice_part(vhdlParser::Name_slice_partContext *ctx) = 0;
  virtual void exitName_slice_part(vhdlParser::Name_slice_partContext *ctx) = 0;

  virtual void enterSelected_name(vhdlParser::Selected_nameContext *ctx) = 0;
  virtual void exitSelected_name(vhdlParser::Selected_nameContext *ctx) = 0;

  virtual void enterNature_declaration(vhdlParser::Nature_declarationContext *ctx) = 0;
  virtual void exitNature_declaration(vhdlParser::Nature_declarationContext *ctx) = 0;

  virtual void enterNature_definition(vhdlParser::Nature_definitionContext *ctx) = 0;
  virtual void exitNature_definition(vhdlParser::Nature_definitionContext *ctx) = 0;

  virtual void enterNature_element_declaration(vhdlParser::Nature_element_declarationContext *ctx) = 0;
  virtual void exitNature_element_declaration(vhdlParser::Nature_element_declarationContext *ctx) = 0;

  virtual void enterNext_statement(vhdlParser::Next_statementContext *ctx) = 0;
  virtual void exitNext_statement(vhdlParser::Next_statementContext *ctx) = 0;

  virtual void enterNumeric_literal(vhdlParser::Numeric_literalContext *ctx) = 0;
  virtual void exitNumeric_literal(vhdlParser::Numeric_literalContext *ctx) = 0;

  virtual void enterObject_declaration(vhdlParser::Object_declarationContext *ctx) = 0;
  virtual void exitObject_declaration(vhdlParser::Object_declarationContext *ctx) = 0;

  virtual void enterOpts(vhdlParser::OptsContext *ctx) = 0;
  virtual void exitOpts(vhdlParser::OptsContext *ctx) = 0;

  virtual void enterPackage_body(vhdlParser::Package_bodyContext *ctx) = 0;
  virtual void exitPackage_body(vhdlParser::Package_bodyContext *ctx) = 0;

  virtual void enterPackage_body_declarative_item(vhdlParser::Package_body_declarative_itemContext *ctx) = 0;
  virtual void exitPackage_body_declarative_item(vhdlParser::Package_body_declarative_itemContext *ctx) = 0;

  virtual void enterPackage_body_declarative_part(vhdlParser::Package_body_declarative_partContext *ctx) = 0;
  virtual void exitPackage_body_declarative_part(vhdlParser::Package_body_declarative_partContext *ctx) = 0;

  virtual void enterPackage_declaration(vhdlParser::Package_declarationContext *ctx) = 0;
  virtual void exitPackage_declaration(vhdlParser::Package_declarationContext *ctx) = 0;

  virtual void enterPackage_declarative_item(vhdlParser::Package_declarative_itemContext *ctx) = 0;
  virtual void exitPackage_declarative_item(vhdlParser::Package_declarative_itemContext *ctx) = 0;

  virtual void enterPackage_declarative_part(vhdlParser::Package_declarative_partContext *ctx) = 0;
  virtual void exitPackage_declarative_part(vhdlParser::Package_declarative_partContext *ctx) = 0;

  virtual void enterParameter_specification(vhdlParser::Parameter_specificationContext *ctx) = 0;
  virtual void exitParameter_specification(vhdlParser::Parameter_specificationContext *ctx) = 0;

  virtual void enterPhysical_literal(vhdlParser::Physical_literalContext *ctx) = 0;
  virtual void exitPhysical_literal(vhdlParser::Physical_literalContext *ctx) = 0;

  virtual void enterPhysical_type_definition(vhdlParser::Physical_type_definitionContext *ctx) = 0;
  virtual void exitPhysical_type_definition(vhdlParser::Physical_type_definitionContext *ctx) = 0;

  virtual void enterPort_clause(vhdlParser::Port_clauseContext *ctx) = 0;
  virtual void exitPort_clause(vhdlParser::Port_clauseContext *ctx) = 0;

  virtual void enterPort_list(vhdlParser::Port_listContext *ctx) = 0;
  virtual void exitPort_list(vhdlParser::Port_listContext *ctx) = 0;

  virtual void enterPort_map_aspect(vhdlParser::Port_map_aspectContext *ctx) = 0;
  virtual void exitPort_map_aspect(vhdlParser::Port_map_aspectContext *ctx) = 0;

  virtual void enterPrimary(vhdlParser::PrimaryContext *ctx) = 0;
  virtual void exitPrimary(vhdlParser::PrimaryContext *ctx) = 0;

  virtual void enterPrimary_unit(vhdlParser::Primary_unitContext *ctx) = 0;
  virtual void exitPrimary_unit(vhdlParser::Primary_unitContext *ctx) = 0;

  virtual void enterProcedural_declarative_item(vhdlParser::Procedural_declarative_itemContext *ctx) = 0;
  virtual void exitProcedural_declarative_item(vhdlParser::Procedural_declarative_itemContext *ctx) = 0;

  virtual void enterProcedural_declarative_part(vhdlParser::Procedural_declarative_partContext *ctx) = 0;
  virtual void exitProcedural_declarative_part(vhdlParser::Procedural_declarative_partContext *ctx) = 0;

  virtual void enterProcedural_statement_part(vhdlParser::Procedural_statement_partContext *ctx) = 0;
  virtual void exitProcedural_statement_part(vhdlParser::Procedural_statement_partContext *ctx) = 0;

  virtual void enterProcedure_call(vhdlParser::Procedure_callContext *ctx) = 0;
  virtual void exitProcedure_call(vhdlParser::Procedure_callContext *ctx) = 0;

  virtual void enterProcedure_call_statement(vhdlParser::Procedure_call_statementContext *ctx) = 0;
  virtual void exitProcedure_call_statement(vhdlParser::Procedure_call_statementContext *ctx) = 0;

  virtual void enterProcess_declarative_item(vhdlParser::Process_declarative_itemContext *ctx) = 0;
  virtual void exitProcess_declarative_item(vhdlParser::Process_declarative_itemContext *ctx) = 0;

  virtual void enterProcess_declarative_part(vhdlParser::Process_declarative_partContext *ctx) = 0;
  virtual void exitProcess_declarative_part(vhdlParser::Process_declarative_partContext *ctx) = 0;

  virtual void enterProcess_statement(vhdlParser::Process_statementContext *ctx) = 0;
  virtual void exitProcess_statement(vhdlParser::Process_statementContext *ctx) = 0;

  virtual void enterProcess_statement_part(vhdlParser::Process_statement_partContext *ctx) = 0;
  virtual void exitProcess_statement_part(vhdlParser::Process_statement_partContext *ctx) = 0;

  virtual void enterQualified_expression(vhdlParser::Qualified_expressionContext *ctx) = 0;
  virtual void exitQualified_expression(vhdlParser::Qualified_expressionContext *ctx) = 0;

  virtual void enterQuantity_declaration(vhdlParser::Quantity_declarationContext *ctx) = 0;
  virtual void exitQuantity_declaration(vhdlParser::Quantity_declarationContext *ctx) = 0;

  virtual void enterQuantity_list(vhdlParser::Quantity_listContext *ctx) = 0;
  virtual void exitQuantity_list(vhdlParser::Quantity_listContext *ctx) = 0;

  virtual void enterQuantity_specification(vhdlParser::Quantity_specificationContext *ctx) = 0;
  virtual void exitQuantity_specification(vhdlParser::Quantity_specificationContext *ctx) = 0;

  virtual void enterRange(vhdlParser::RangeContext *ctx) = 0;
  virtual void exitRange(vhdlParser::RangeContext *ctx) = 0;

  virtual void enterExplicit_range(vhdlParser::Explicit_rangeContext *ctx) = 0;
  virtual void exitExplicit_range(vhdlParser::Explicit_rangeContext *ctx) = 0;

  virtual void enterRange_constraint(vhdlParser::Range_constraintContext *ctx) = 0;
  virtual void exitRange_constraint(vhdlParser::Range_constraintContext *ctx) = 0;

  virtual void enterRecord_nature_definition(vhdlParser::Record_nature_definitionContext *ctx) = 0;
  virtual void exitRecord_nature_definition(vhdlParser::Record_nature_definitionContext *ctx) = 0;

  virtual void enterRecord_type_definition(vhdlParser::Record_type_definitionContext *ctx) = 0;
  virtual void exitRecord_type_definition(vhdlParser::Record_type_definitionContext *ctx) = 0;

  virtual void enterRelation(vhdlParser::RelationContext *ctx) = 0;
  virtual void exitRelation(vhdlParser::RelationContext *ctx) = 0;

  virtual void enterRelational_operator(vhdlParser::Relational_operatorContext *ctx) = 0;
  virtual void exitRelational_operator(vhdlParser::Relational_operatorContext *ctx) = 0;

  virtual void enterReport_statement(vhdlParser::Report_statementContext *ctx) = 0;
  virtual void exitReport_statement(vhdlParser::Report_statementContext *ctx) = 0;

  virtual void enterReturn_statement(vhdlParser::Return_statementContext *ctx) = 0;
  virtual void exitReturn_statement(vhdlParser::Return_statementContext *ctx) = 0;

  virtual void enterScalar_nature_definition(vhdlParser::Scalar_nature_definitionContext *ctx) = 0;
  virtual void exitScalar_nature_definition(vhdlParser::Scalar_nature_definitionContext *ctx) = 0;

  virtual void enterScalar_type_definition(vhdlParser::Scalar_type_definitionContext *ctx) = 0;
  virtual void exitScalar_type_definition(vhdlParser::Scalar_type_definitionContext *ctx) = 0;

  virtual void enterSecondary_unit(vhdlParser::Secondary_unitContext *ctx) = 0;
  virtual void exitSecondary_unit(vhdlParser::Secondary_unitContext *ctx) = 0;

  virtual void enterSecondary_unit_declaration(vhdlParser::Secondary_unit_declarationContext *ctx) = 0;
  virtual void exitSecondary_unit_declaration(vhdlParser::Secondary_unit_declarationContext *ctx) = 0;

  virtual void enterSelected_signal_assignment(vhdlParser::Selected_signal_assignmentContext *ctx) = 0;
  virtual void exitSelected_signal_assignment(vhdlParser::Selected_signal_assignmentContext *ctx) = 0;

  virtual void enterSelected_waveforms(vhdlParser::Selected_waveformsContext *ctx) = 0;
  virtual void exitSelected_waveforms(vhdlParser::Selected_waveformsContext *ctx) = 0;

  virtual void enterSensitivity_clause(vhdlParser::Sensitivity_clauseContext *ctx) = 0;
  virtual void exitSensitivity_clause(vhdlParser::Sensitivity_clauseContext *ctx) = 0;

  virtual void enterSensitivity_list(vhdlParser::Sensitivity_listContext *ctx) = 0;
  virtual void exitSensitivity_list(vhdlParser::Sensitivity_listContext *ctx) = 0;

  virtual void enterSequence_of_statements(vhdlParser::Sequence_of_statementsContext *ctx) = 0;
  virtual void exitSequence_of_statements(vhdlParser::Sequence_of_statementsContext *ctx) = 0;

  virtual void enterSequential_statement(vhdlParser::Sequential_statementContext *ctx) = 0;
  virtual void exitSequential_statement(vhdlParser::Sequential_statementContext *ctx) = 0;

  virtual void enterShift_expression(vhdlParser::Shift_expressionContext *ctx) = 0;
  virtual void exitShift_expression(vhdlParser::Shift_expressionContext *ctx) = 0;

  virtual void enterShift_operator(vhdlParser::Shift_operatorContext *ctx) = 0;
  virtual void exitShift_operator(vhdlParser::Shift_operatorContext *ctx) = 0;

  virtual void enterSignal_assignment_statement(vhdlParser::Signal_assignment_statementContext *ctx) = 0;
  virtual void exitSignal_assignment_statement(vhdlParser::Signal_assignment_statementContext *ctx) = 0;

  virtual void enterSignal_declaration(vhdlParser::Signal_declarationContext *ctx) = 0;
  virtual void exitSignal_declaration(vhdlParser::Signal_declarationContext *ctx) = 0;

  virtual void enterSignal_kind(vhdlParser::Signal_kindContext *ctx) = 0;
  virtual void exitSignal_kind(vhdlParser::Signal_kindContext *ctx) = 0;

  virtual void enterSignal_list(vhdlParser::Signal_listContext *ctx) = 0;
  virtual void exitSignal_list(vhdlParser::Signal_listContext *ctx) = 0;

  virtual void enterSignature(vhdlParser::SignatureContext *ctx) = 0;
  virtual void exitSignature(vhdlParser::SignatureContext *ctx) = 0;

  virtual void enterSimple_expression(vhdlParser::Simple_expressionContext *ctx) = 0;
  virtual void exitSimple_expression(vhdlParser::Simple_expressionContext *ctx) = 0;

  virtual void enterSimple_simultaneous_statement(vhdlParser::Simple_simultaneous_statementContext *ctx) = 0;
  virtual void exitSimple_simultaneous_statement(vhdlParser::Simple_simultaneous_statementContext *ctx) = 0;

  virtual void enterSimultaneous_alternative(vhdlParser::Simultaneous_alternativeContext *ctx) = 0;
  virtual void exitSimultaneous_alternative(vhdlParser::Simultaneous_alternativeContext *ctx) = 0;

  virtual void enterSimultaneous_case_statement(vhdlParser::Simultaneous_case_statementContext *ctx) = 0;
  virtual void exitSimultaneous_case_statement(vhdlParser::Simultaneous_case_statementContext *ctx) = 0;

  virtual void enterSimultaneous_if_statement(vhdlParser::Simultaneous_if_statementContext *ctx) = 0;
  virtual void exitSimultaneous_if_statement(vhdlParser::Simultaneous_if_statementContext *ctx) = 0;

  virtual void enterSimultaneous_procedural_statement(vhdlParser::Simultaneous_procedural_statementContext *ctx) = 0;
  virtual void exitSimultaneous_procedural_statement(vhdlParser::Simultaneous_procedural_statementContext *ctx) = 0;

  virtual void enterSimultaneous_statement(vhdlParser::Simultaneous_statementContext *ctx) = 0;
  virtual void exitSimultaneous_statement(vhdlParser::Simultaneous_statementContext *ctx) = 0;

  virtual void enterSimultaneous_statement_part(vhdlParser::Simultaneous_statement_partContext *ctx) = 0;
  virtual void exitSimultaneous_statement_part(vhdlParser::Simultaneous_statement_partContext *ctx) = 0;

  virtual void enterSource_aspect(vhdlParser::Source_aspectContext *ctx) = 0;
  virtual void exitSource_aspect(vhdlParser::Source_aspectContext *ctx) = 0;

  virtual void enterSource_quantity_declaration(vhdlParser::Source_quantity_declarationContext *ctx) = 0;
  virtual void exitSource_quantity_declaration(vhdlParser::Source_quantity_declarationContext *ctx) = 0;

  virtual void enterStep_limit_specification(vhdlParser::Step_limit_specificationContext *ctx) = 0;
  virtual void exitStep_limit_specification(vhdlParser::Step_limit_specificationContext *ctx) = 0;

  virtual void enterSubnature_declaration(vhdlParser::Subnature_declarationContext *ctx) = 0;
  virtual void exitSubnature_declaration(vhdlParser::Subnature_declarationContext *ctx) = 0;

  virtual void enterSubnature_indication(vhdlParser::Subnature_indicationContext *ctx) = 0;
  virtual void exitSubnature_indication(vhdlParser::Subnature_indicationContext *ctx) = 0;

  virtual void enterSubprogram_body(vhdlParser::Subprogram_bodyContext *ctx) = 0;
  virtual void exitSubprogram_body(vhdlParser::Subprogram_bodyContext *ctx) = 0;

  virtual void enterSubprogram_declaration(vhdlParser::Subprogram_declarationContext *ctx) = 0;
  virtual void exitSubprogram_declaration(vhdlParser::Subprogram_declarationContext *ctx) = 0;

  virtual void enterSubprogram_declarative_item(vhdlParser::Subprogram_declarative_itemContext *ctx) = 0;
  virtual void exitSubprogram_declarative_item(vhdlParser::Subprogram_declarative_itemContext *ctx) = 0;

  virtual void enterSubprogram_declarative_part(vhdlParser::Subprogram_declarative_partContext *ctx) = 0;
  virtual void exitSubprogram_declarative_part(vhdlParser::Subprogram_declarative_partContext *ctx) = 0;

  virtual void enterSubprogram_kind(vhdlParser::Subprogram_kindContext *ctx) = 0;
  virtual void exitSubprogram_kind(vhdlParser::Subprogram_kindContext *ctx) = 0;

  virtual void enterSubprogram_specification(vhdlParser::Subprogram_specificationContext *ctx) = 0;
  virtual void exitSubprogram_specification(vhdlParser::Subprogram_specificationContext *ctx) = 0;

  virtual void enterProcedure_specification(vhdlParser::Procedure_specificationContext *ctx) = 0;
  virtual void exitProcedure_specification(vhdlParser::Procedure_specificationContext *ctx) = 0;

  virtual void enterFunction_specification(vhdlParser::Function_specificationContext *ctx) = 0;
  virtual void exitFunction_specification(vhdlParser::Function_specificationContext *ctx) = 0;

  virtual void enterSubprogram_statement_part(vhdlParser::Subprogram_statement_partContext *ctx) = 0;
  virtual void exitSubprogram_statement_part(vhdlParser::Subprogram_statement_partContext *ctx) = 0;

  virtual void enterSubtype_declaration(vhdlParser::Subtype_declarationContext *ctx) = 0;
  virtual void exitSubtype_declaration(vhdlParser::Subtype_declarationContext *ctx) = 0;

  virtual void enterSubtype_indication(vhdlParser::Subtype_indicationContext *ctx) = 0;
  virtual void exitSubtype_indication(vhdlParser::Subtype_indicationContext *ctx) = 0;

  virtual void enterSuffix(vhdlParser::SuffixContext *ctx) = 0;
  virtual void exitSuffix(vhdlParser::SuffixContext *ctx) = 0;

  virtual void enterTarget(vhdlParser::TargetContext *ctx) = 0;
  virtual void exitTarget(vhdlParser::TargetContext *ctx) = 0;

  virtual void enterTerm(vhdlParser::TermContext *ctx) = 0;
  virtual void exitTerm(vhdlParser::TermContext *ctx) = 0;

  virtual void enterTerminal_aspect(vhdlParser::Terminal_aspectContext *ctx) = 0;
  virtual void exitTerminal_aspect(vhdlParser::Terminal_aspectContext *ctx) = 0;

  virtual void enterTerminal_declaration(vhdlParser::Terminal_declarationContext *ctx) = 0;
  virtual void exitTerminal_declaration(vhdlParser::Terminal_declarationContext *ctx) = 0;

  virtual void enterThrough_aspect(vhdlParser::Through_aspectContext *ctx) = 0;
  virtual void exitThrough_aspect(vhdlParser::Through_aspectContext *ctx) = 0;

  virtual void enterTimeout_clause(vhdlParser::Timeout_clauseContext *ctx) = 0;
  virtual void exitTimeout_clause(vhdlParser::Timeout_clauseContext *ctx) = 0;

  virtual void enterTolerance_aspect(vhdlParser::Tolerance_aspectContext *ctx) = 0;
  virtual void exitTolerance_aspect(vhdlParser::Tolerance_aspectContext *ctx) = 0;

  virtual void enterType_declaration(vhdlParser::Type_declarationContext *ctx) = 0;
  virtual void exitType_declaration(vhdlParser::Type_declarationContext *ctx) = 0;

  virtual void enterType_definition(vhdlParser::Type_definitionContext *ctx) = 0;
  virtual void exitType_definition(vhdlParser::Type_definitionContext *ctx) = 0;

  virtual void enterUnconstrained_array_definition(vhdlParser::Unconstrained_array_definitionContext *ctx) = 0;
  virtual void exitUnconstrained_array_definition(vhdlParser::Unconstrained_array_definitionContext *ctx) = 0;

  virtual void enterUnconstrained_nature_definition(vhdlParser::Unconstrained_nature_definitionContext *ctx) = 0;
  virtual void exitUnconstrained_nature_definition(vhdlParser::Unconstrained_nature_definitionContext *ctx) = 0;

  virtual void enterUse_clause(vhdlParser::Use_clauseContext *ctx) = 0;
  virtual void exitUse_clause(vhdlParser::Use_clauseContext *ctx) = 0;

  virtual void enterVariable_assignment_statement(vhdlParser::Variable_assignment_statementContext *ctx) = 0;
  virtual void exitVariable_assignment_statement(vhdlParser::Variable_assignment_statementContext *ctx) = 0;

  virtual void enterVariable_declaration(vhdlParser::Variable_declarationContext *ctx) = 0;
  virtual void exitVariable_declaration(vhdlParser::Variable_declarationContext *ctx) = 0;

  virtual void enterWait_statement(vhdlParser::Wait_statementContext *ctx) = 0;
  virtual void exitWait_statement(vhdlParser::Wait_statementContext *ctx) = 0;

  virtual void enterWaveform(vhdlParser::WaveformContext *ctx) = 0;
  virtual void exitWaveform(vhdlParser::WaveformContext *ctx) = 0;

  virtual void enterWaveform_element(vhdlParser::Waveform_elementContext *ctx) = 0;
  virtual void exitWaveform_element(vhdlParser::Waveform_elementContext *ctx) = 0;


};

}  // namespace vhdl
