
// Generated from vhdl.g4 by ANTLR 4.6

#pragma once


#include "antlr4-runtime.h"


using namespace antlr4;

namespace vhdl {


class vhdlParser : public Parser {
public:
  enum {
    ABS = 1, ACCESS = 2, ACROSS = 3, AFTER = 4, ALIAS = 5, ALL = 6, AND = 7, 
    ARCHITECTURE = 8, ARRAY = 9, ASSERT = 10, ATTRIBUTE = 11, BEGIN = 12, 
    BLOCK = 13, BODY = 14, BREAK = 15, BUFFER = 16, BUS = 17, CASE = 18, 
    COMPONENT = 19, CONFIGURATION = 20, CONSTANT = 21, DISCONNECT = 22, 
    DOWNTO = 23, END = 24, ENTITY = 25, ELSE = 26, ELSIF = 27, EXIT = 28, 
    FILE = 29, FOR = 30, FUNCTION = 31, GENERATE = 32, GENERIC = 33, GROUP = 34, 
    GUARDED = 35, IF = 36, IMPURE = 37, IN = 38, INERTIAL = 39, INOUT = 40, 
    IS = 41, LABEL = 42, LIBRARY = 43, LIMIT = 44, LINKAGE = 45, LITERAL = 46, 
    LOOP = 47, MAP = 48, MOD = 49, NAND = 50, NATURE = 51, NEW = 52, NEXT = 53, 
    NOISE = 54, NOR = 55, NOT = 56, NULL_SYM = 57, OF = 58, ON = 59, OPEN = 60, 
    OR = 61, OTHERS = 62, OUT = 63, PACKAGE = 64, PORT = 65, POSTPONED = 66, 
    PROCESS = 67, PROCEDURE = 68, PROCEDURAL = 69, PURE = 70, QUANTITY = 71, 
    RANGE = 72, REVERSE_RANGE = 73, REJECT = 74, REM = 75, RECORD = 76, 
    REFERENCE = 77, REGISTER = 78, REPORT = 79, RETURN = 80, ROL = 81, ROR = 82, 
    SELECT = 83, SEVERITY = 84, SHARED = 85, SIGNAL = 86, SLA = 87, SLL = 88, 
    SPECTRUM = 89, SRA = 90, SRL = 91, SUBNATURE = 92, SUBTYPE = 93, TERMINAL = 94, 
    THEN = 95, THROUGH = 96, TO = 97, TOLERANCE = 98, TRANSPORT = 99, TYPE = 100, 
    UNAFFECTED = 101, UNITS = 102, UNTIL = 103, USE = 104, VARIABLE = 105, 
    WAIT = 106, WITH = 107, WHEN = 108, WHILE = 109, XNOR = 110, XOR = 111, 
    BASE_LITERAL = 112, BIT_STRING_LITERAL = 113, BIT_STRING_LITERAL_BINARY = 114, 
    BIT_STRING_LITERAL_OCTAL = 115, BIT_STRING_LITERAL_HEX = 116, REAL_LITERAL = 117, 
    BASIC_IDENTIFIER = 118, EXTENDED_IDENTIFIER = 119, LETTER = 120, COMMENT = 121, 
    TAB = 122, SPACE = 123, NEWLINE = 124, CR = 125, CHARACTER_LITERAL = 126, 
    STRING_LITERAL = 127, OTHER_SPECIAL_CHARACTER = 128, DOUBLESTAR = 129, 
    ASSIGN = 130, LE = 131, GE = 132, ARROW = 133, NEQ = 134, VARASGN = 135, 
    BOX = 136, DBLQUOTE = 137, SEMI = 138, COMMA = 139, AMPERSAND = 140, 
    LPAREN = 141, RPAREN = 142, LBRACKET = 143, RBRACKET = 144, COLON = 145, 
    MUL = 146, DIV = 147, PLUS = 148, MINUS = 149, LOWERTHAN = 150, GREATERTHAN = 151, 
    EQ = 152, BAR = 153, DOT = 154, BACKSLASH = 155, EXPONENT = 156, HEXDIGIT = 157, 
    INTEGER = 158, DIGIT = 159, BASED_INTEGER = 160, EXTENDED_DIGIT = 161, 
    APOSTROPHE = 162
  };

  enum {
    RuleAbstract_literal = 0, RuleAccess_type_definition = 1, RuleAcross_aspect = 2, 
    RuleActual_designator = 3, RuleActual_parameter_part = 4, RuleActual_part = 5, 
    RuleAdding_operator = 6, RuleAggregate = 7, RuleAlias_declaration = 8, 
    RuleAlias_designator = 9, RuleAlias_indication = 10, RuleAllocator = 11, 
    RuleArchitecture_body = 12, RuleArchitecture_declarative_part = 13, 
    RuleArchitecture_statement = 14, RuleArchitecture_statement_part = 15, 
    RuleArray_nature_definition = 16, RuleArray_type_definition = 17, RuleAssertion = 18, 
    RuleAssertion_statement = 19, RuleAssociation_element = 20, RuleAssociation_list = 21, 
    RuleAttribute_declaration = 22, RuleAttribute_designator = 23, RuleAttribute_specification = 24, 
    RuleBase_unit_declaration = 25, RuleBinding_indication = 26, RuleBlock_configuration = 27, 
    RuleBlock_declarative_item = 28, RuleBlock_declarative_part = 29, RuleBlock_header = 30, 
    RuleBlock_specification = 31, RuleBlock_statement = 32, RuleBlock_statement_part = 33, 
    RuleBranch_quantity_declaration = 34, RuleBreak_element = 35, RuleBreak_list = 36, 
    RuleBreak_selector_clause = 37, RuleBreak_statement = 38, RuleCase_statement = 39, 
    RuleCase_statement_alternative = 40, RuleChoice = 41, RuleChoices = 42, 
    RuleComponent_configuration = 43, RuleComponent_declaration = 44, RuleComponent_instantiation_statement = 45, 
    RuleComponent_specification = 46, RuleComposite_nature_definition = 47, 
    RuleComposite_type_definition = 48, RuleConcurrent_assertion_statement = 49, 
    RuleConcurrent_break_statement = 50, RuleConcurrent_procedure_call_statement = 51, 
    RuleConcurrent_signal_assignment_statement = 52, RuleCondition = 53, 
    RuleCondition_clause = 54, RuleConditional_signal_assignment = 55, RuleConditional_waveforms = 56, 
    RuleConfiguration_declaration = 57, RuleConfiguration_declarative_item = 58, 
    RuleConfiguration_declarative_part = 59, RuleConfiguration_item = 60, 
    RuleConfiguration_specification = 61, RuleConstant_declaration = 62, 
    RuleConstrained_array_definition = 63, RuleConstrained_nature_definition = 64, 
    RuleConstraint = 65, RuleContext_clause = 66, RuleContext_item = 67, 
    RuleDelay_mechanism = 68, RuleDesign_file = 69, RuleDesign_unit = 70, 
    RuleDesignator = 71, RuleDirection = 72, RuleDisconnection_specification = 73, 
    RuleDiscrete_range = 74, RuleElement_association = 75, RuleElement_declaration = 76, 
    RuleElement_subnature_definition = 77, RuleElement_subtype_definition = 78, 
    RuleEntity_aspect = 79, RuleEntity_class = 80, RuleEntity_class_entry = 81, 
    RuleEntity_class_entry_list = 82, RuleEntity_declaration = 83, RuleEntity_declarative_item = 84, 
    RuleEntity_declarative_part = 85, RuleEntity_designator = 86, RuleEntity_header = 87, 
    RuleEntity_name_list = 88, RuleEntity_specification = 89, RuleEntity_statement = 90, 
    RuleEntity_statement_part = 91, RuleEntity_tag = 92, RuleEnumeration_literal = 93, 
    RuleEnumeration_type_definition = 94, RuleExit_statement = 95, RuleExpression = 96, 
    RuleFactor = 97, RuleFile_declaration = 98, RuleFile_logical_name = 99, 
    RuleFile_open_information = 100, RuleFile_type_definition = 101, RuleFormal_parameter_list = 102, 
    RuleFormal_part = 103, RuleFree_quantity_declaration = 104, RuleGenerate_statement = 105, 
    RuleGeneration_scheme = 106, RuleGeneric_clause = 107, RuleGeneric_list = 108, 
    RuleGeneric_map_aspect = 109, RuleGroup_constituent = 110, RuleGroup_constituent_list = 111, 
    RuleGroup_declaration = 112, RuleGroup_template_declaration = 113, RuleGuarded_signal_specification = 114, 
    RuleIdentifier = 115, RuleIdentifier_list = 116, RuleIf_statement = 117, 
    RuleIndex_constraint = 118, RuleIndex_specification = 119, RuleIndex_subtype_definition = 120, 
    RuleInstantiated_unit = 121, RuleInstantiation_list = 122, RuleInterface_constant_declaration = 123, 
    RuleInterface_declaration = 124, RuleInterface_element = 125, RuleInterface_file_declaration = 126, 
    RuleInterface_signal_list = 127, RuleInterface_port_list = 128, RuleInterface_list = 129, 
    RuleInterface_quantity_declaration = 130, RuleInterface_port_declaration = 131, 
    RuleInterface_signal_declaration = 132, RuleInterface_terminal_declaration = 133, 
    RuleInterface_variable_declaration = 134, RuleIteration_scheme = 135, 
    RuleLabel_colon = 136, RuleLibrary_clause = 137, RuleLibrary_unit = 138, 
    RuleLiteral = 139, RuleLogical_name = 140, RuleLogical_name_list = 141, 
    RuleLogical_operator = 142, RuleLoop_statement = 143, RuleSignal_mode = 144, 
    RuleMultiplying_operator = 145, RuleName = 146, RuleName_part = 147, 
    RuleName_part_specificator = 148, RuleName_attribute_part = 149, RuleName_function_call_or_indexed_part = 150, 
    RuleName_slice_part = 151, RuleSelected_name = 152, RuleNature_declaration = 153, 
    RuleNature_definition = 154, RuleNature_element_declaration = 155, RuleNext_statement = 156, 
    RuleNumeric_literal = 157, RuleObject_declaration = 158, RuleOpts = 159, 
    RulePackage_body = 160, RulePackage_body_declarative_item = 161, RulePackage_body_declarative_part = 162, 
    RulePackage_declaration = 163, RulePackage_declarative_item = 164, RulePackage_declarative_part = 165, 
    RuleParameter_specification = 166, RulePhysical_literal = 167, RulePhysical_type_definition = 168, 
    RulePort_clause = 169, RulePort_list = 170, RulePort_map_aspect = 171, 
    RulePrimary = 172, RulePrimary_unit = 173, RuleProcedural_declarative_item = 174, 
    RuleProcedural_declarative_part = 175, RuleProcedural_statement_part = 176, 
    RuleProcedure_call = 177, RuleProcedure_call_statement = 178, RuleProcess_declarative_item = 179, 
    RuleProcess_declarative_part = 180, RuleProcess_statement = 181, RuleProcess_statement_part = 182, 
    RuleQualified_expression = 183, RuleQuantity_declaration = 184, RuleQuantity_list = 185, 
    RuleQuantity_specification = 186, RuleRange = 187, RuleExplicit_range = 188, 
    RuleRange_constraint = 189, RuleRecord_nature_definition = 190, RuleRecord_type_definition = 191, 
    RuleRelation = 192, RuleRelational_operator = 193, RuleReport_statement = 194, 
    RuleReturn_statement = 195, RuleScalar_nature_definition = 196, RuleScalar_type_definition = 197, 
    RuleSecondary_unit = 198, RuleSecondary_unit_declaration = 199, RuleSelected_signal_assignment = 200, 
    RuleSelected_waveforms = 201, RuleSensitivity_clause = 202, RuleSensitivity_list = 203, 
    RuleSequence_of_statements = 204, RuleSequential_statement = 205, RuleShift_expression = 206, 
    RuleShift_operator = 207, RuleSignal_assignment_statement = 208, RuleSignal_declaration = 209, 
    RuleSignal_kind = 210, RuleSignal_list = 211, RuleSignature = 212, RuleSimple_expression = 213, 
    RuleSimple_simultaneous_statement = 214, RuleSimultaneous_alternative = 215, 
    RuleSimultaneous_case_statement = 216, RuleSimultaneous_if_statement = 217, 
    RuleSimultaneous_procedural_statement = 218, RuleSimultaneous_statement = 219, 
    RuleSimultaneous_statement_part = 220, RuleSource_aspect = 221, RuleSource_quantity_declaration = 222, 
    RuleStep_limit_specification = 223, RuleSubnature_declaration = 224, 
    RuleSubnature_indication = 225, RuleSubprogram_body = 226, RuleSubprogram_declaration = 227, 
    RuleSubprogram_declarative_item = 228, RuleSubprogram_declarative_part = 229, 
    RuleSubprogram_kind = 230, RuleSubprogram_specification = 231, RuleProcedure_specification = 232, 
    RuleFunction_specification = 233, RuleSubprogram_statement_part = 234, 
    RuleSubtype_declaration = 235, RuleSubtype_indication = 236, RuleSuffix = 237, 
    RuleTarget = 238, RuleTerm = 239, RuleTerminal_aspect = 240, RuleTerminal_declaration = 241, 
    RuleThrough_aspect = 242, RuleTimeout_clause = 243, RuleTolerance_aspect = 244, 
    RuleType_declaration = 245, RuleType_definition = 246, RuleUnconstrained_array_definition = 247, 
    RuleUnconstrained_nature_definition = 248, RuleUse_clause = 249, RuleVariable_assignment_statement = 250, 
    RuleVariable_declaration = 251, RuleWait_statement = 252, RuleWaveform = 253, 
    RuleWaveform_element = 254
  };

  vhdlParser(TokenStream *input);
  ~vhdlParser();

  virtual std::string getGrammarFileName() const override;
  virtual const atn::ATN& getATN() const override { return _atn; };
  virtual const std::vector<std::string>& getTokenNames() const override { return _tokenNames; }; // deprecated: use vocabulary instead.
  virtual const std::vector<std::string>& getRuleNames() const override;
  virtual dfa::Vocabulary& getVocabulary() const override;


  class Abstract_literalContext;
  class Access_type_definitionContext;
  class Across_aspectContext;
  class Actual_designatorContext;
  class Actual_parameter_partContext;
  class Actual_partContext;
  class Adding_operatorContext;
  class AggregateContext;
  class Alias_declarationContext;
  class Alias_designatorContext;
  class Alias_indicationContext;
  class AllocatorContext;
  class Architecture_bodyContext;
  class Architecture_declarative_partContext;
  class Architecture_statementContext;
  class Architecture_statement_partContext;
  class Array_nature_definitionContext;
  class Array_type_definitionContext;
  class AssertionContext;
  class Assertion_statementContext;
  class Association_elementContext;
  class Association_listContext;
  class Attribute_declarationContext;
  class Attribute_designatorContext;
  class Attribute_specificationContext;
  class Base_unit_declarationContext;
  class Binding_indicationContext;
  class Block_configurationContext;
  class Block_declarative_itemContext;
  class Block_declarative_partContext;
  class Block_headerContext;
  class Block_specificationContext;
  class Block_statementContext;
  class Block_statement_partContext;
  class Branch_quantity_declarationContext;
  class Break_elementContext;
  class Break_listContext;
  class Break_selector_clauseContext;
  class Break_statementContext;
  class Case_statementContext;
  class Case_statement_alternativeContext;
  class ChoiceContext;
  class ChoicesContext;
  class Component_configurationContext;
  class Component_declarationContext;
  class Component_instantiation_statementContext;
  class Component_specificationContext;
  class Composite_nature_definitionContext;
  class Composite_type_definitionContext;
  class Concurrent_assertion_statementContext;
  class Concurrent_break_statementContext;
  class Concurrent_procedure_call_statementContext;
  class Concurrent_signal_assignment_statementContext;
  class ConditionContext;
  class Condition_clauseContext;
  class Conditional_signal_assignmentContext;
  class Conditional_waveformsContext;
  class Configuration_declarationContext;
  class Configuration_declarative_itemContext;
  class Configuration_declarative_partContext;
  class Configuration_itemContext;
  class Configuration_specificationContext;
  class Constant_declarationContext;
  class Constrained_array_definitionContext;
  class Constrained_nature_definitionContext;
  class ConstraintContext;
  class Context_clauseContext;
  class Context_itemContext;
  class Delay_mechanismContext;
  class Design_fileContext;
  class Design_unitContext;
  class DesignatorContext;
  class DirectionContext;
  class Disconnection_specificationContext;
  class Discrete_rangeContext;
  class Element_associationContext;
  class Element_declarationContext;
  class Element_subnature_definitionContext;
  class Element_subtype_definitionContext;
  class Entity_aspectContext;
  class Entity_classContext;
  class Entity_class_entryContext;
  class Entity_class_entry_listContext;
  class Entity_declarationContext;
  class Entity_declarative_itemContext;
  class Entity_declarative_partContext;
  class Entity_designatorContext;
  class Entity_headerContext;
  class Entity_name_listContext;
  class Entity_specificationContext;
  class Entity_statementContext;
  class Entity_statement_partContext;
  class Entity_tagContext;
  class Enumeration_literalContext;
  class Enumeration_type_definitionContext;
  class Exit_statementContext;
  class ExpressionContext;
  class FactorContext;
  class File_declarationContext;
  class File_logical_nameContext;
  class File_open_informationContext;
  class File_type_definitionContext;
  class Formal_parameter_listContext;
  class Formal_partContext;
  class Free_quantity_declarationContext;
  class Generate_statementContext;
  class Generation_schemeContext;
  class Generic_clauseContext;
  class Generic_listContext;
  class Generic_map_aspectContext;
  class Group_constituentContext;
  class Group_constituent_listContext;
  class Group_declarationContext;
  class Group_template_declarationContext;
  class Guarded_signal_specificationContext;
  class IdentifierContext;
  class Identifier_listContext;
  class If_statementContext;
  class Index_constraintContext;
  class Index_specificationContext;
  class Index_subtype_definitionContext;
  class Instantiated_unitContext;
  class Instantiation_listContext;
  class Interface_constant_declarationContext;
  class Interface_declarationContext;
  class Interface_elementContext;
  class Interface_file_declarationContext;
  class Interface_signal_listContext;
  class Interface_port_listContext;
  class Interface_listContext;
  class Interface_quantity_declarationContext;
  class Interface_port_declarationContext;
  class Interface_signal_declarationContext;
  class Interface_terminal_declarationContext;
  class Interface_variable_declarationContext;
  class Iteration_schemeContext;
  class Label_colonContext;
  class Library_clauseContext;
  class Library_unitContext;
  class LiteralContext;
  class Logical_nameContext;
  class Logical_name_listContext;
  class Logical_operatorContext;
  class Loop_statementContext;
  class Signal_modeContext;
  class Multiplying_operatorContext;
  class NameContext;
  class Name_partContext;
  class Name_part_specificatorContext;
  class Name_attribute_partContext;
  class Name_function_call_or_indexed_partContext;
  class Name_slice_partContext;
  class Selected_nameContext;
  class Nature_declarationContext;
  class Nature_definitionContext;
  class Nature_element_declarationContext;
  class Next_statementContext;
  class Numeric_literalContext;
  class Object_declarationContext;
  class OptsContext;
  class Package_bodyContext;
  class Package_body_declarative_itemContext;
  class Package_body_declarative_partContext;
  class Package_declarationContext;
  class Package_declarative_itemContext;
  class Package_declarative_partContext;
  class Parameter_specificationContext;
  class Physical_literalContext;
  class Physical_type_definitionContext;
  class Port_clauseContext;
  class Port_listContext;
  class Port_map_aspectContext;
  class PrimaryContext;
  class Primary_unitContext;
  class Procedural_declarative_itemContext;
  class Procedural_declarative_partContext;
  class Procedural_statement_partContext;
  class Procedure_callContext;
  class Procedure_call_statementContext;
  class Process_declarative_itemContext;
  class Process_declarative_partContext;
  class Process_statementContext;
  class Process_statement_partContext;
  class Qualified_expressionContext;
  class Quantity_declarationContext;
  class Quantity_listContext;
  class Quantity_specificationContext;
  class RangeContext;
  class Explicit_rangeContext;
  class Range_constraintContext;
  class Record_nature_definitionContext;
  class Record_type_definitionContext;
  class RelationContext;
  class Relational_operatorContext;
  class Report_statementContext;
  class Return_statementContext;
  class Scalar_nature_definitionContext;
  class Scalar_type_definitionContext;
  class Secondary_unitContext;
  class Secondary_unit_declarationContext;
  class Selected_signal_assignmentContext;
  class Selected_waveformsContext;
  class Sensitivity_clauseContext;
  class Sensitivity_listContext;
  class Sequence_of_statementsContext;
  class Sequential_statementContext;
  class Shift_expressionContext;
  class Shift_operatorContext;
  class Signal_assignment_statementContext;
  class Signal_declarationContext;
  class Signal_kindContext;
  class Signal_listContext;
  class SignatureContext;
  class Simple_expressionContext;
  class Simple_simultaneous_statementContext;
  class Simultaneous_alternativeContext;
  class Simultaneous_case_statementContext;
  class Simultaneous_if_statementContext;
  class Simultaneous_procedural_statementContext;
  class Simultaneous_statementContext;
  class Simultaneous_statement_partContext;
  class Source_aspectContext;
  class Source_quantity_declarationContext;
  class Step_limit_specificationContext;
  class Subnature_declarationContext;
  class Subnature_indicationContext;
  class Subprogram_bodyContext;
  class Subprogram_declarationContext;
  class Subprogram_declarative_itemContext;
  class Subprogram_declarative_partContext;
  class Subprogram_kindContext;
  class Subprogram_specificationContext;
  class Procedure_specificationContext;
  class Function_specificationContext;
  class Subprogram_statement_partContext;
  class Subtype_declarationContext;
  class Subtype_indicationContext;
  class SuffixContext;
  class TargetContext;
  class TermContext;
  class Terminal_aspectContext;
  class Terminal_declarationContext;
  class Through_aspectContext;
  class Timeout_clauseContext;
  class Tolerance_aspectContext;
  class Type_declarationContext;
  class Type_definitionContext;
  class Unconstrained_array_definitionContext;
  class Unconstrained_nature_definitionContext;
  class Use_clauseContext;
  class Variable_assignment_statementContext;
  class Variable_declarationContext;
  class Wait_statementContext;
  class WaveformContext;
  class Waveform_elementContext; 

  class Abstract_literalContext : public ParserRuleContext {
  public:
    Abstract_literalContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *INTEGER();
    tree::TerminalNode *REAL_LITERAL();
    tree::TerminalNode *BASE_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Abstract_literalContext* abstract_literal();

  class Access_type_definitionContext : public ParserRuleContext {
  public:
    Access_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ACCESS();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Access_type_definitionContext* access_type_definition();

  class Across_aspectContext : public ParserRuleContext {
  public:
    Across_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *ACROSS();
    Tolerance_aspectContext *tolerance_aspect();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Across_aspectContext* across_aspect();

  class Actual_designatorContext : public ParserRuleContext {
  public:
    Actual_designatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    tree::TerminalNode *OPEN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Actual_designatorContext* actual_designator();

  class Actual_parameter_partContext : public ParserRuleContext {
  public:
    Actual_parameter_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Association_listContext *association_list();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Actual_parameter_partContext* actual_parameter_part();

  class Actual_partContext : public ParserRuleContext {
  public:
    Actual_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    tree::TerminalNode *LPAREN();
    Actual_designatorContext *actual_designator();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Actual_partContext* actual_part();

  class Adding_operatorContext : public ParserRuleContext {
  public:
    Adding_operatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *PLUS();
    tree::TerminalNode *MINUS();
    tree::TerminalNode *AMPERSAND();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Adding_operatorContext* adding_operator();

  class AggregateContext : public ParserRuleContext {
  public:
    AggregateContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LPAREN();
    std::vector<Element_associationContext *> element_association();
    Element_associationContext* element_association(size_t i);
    tree::TerminalNode *RPAREN();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  AggregateContext* aggregate();

  class Alias_declarationContext : public ParserRuleContext {
  public:
    Alias_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ALIAS();
    Alias_designatorContext *alias_designator();
    tree::TerminalNode *IS();
    NameContext *name();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *COLON();
    Alias_indicationContext *alias_indication();
    SignatureContext *signature();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Alias_declarationContext* alias_declaration();

  class Alias_designatorContext : public ParserRuleContext {
  public:
    Alias_designatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *CHARACTER_LITERAL();
    tree::TerminalNode *STRING_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Alias_designatorContext* alias_designator();

  class Alias_indicationContext : public ParserRuleContext {
  public:
    Alias_indicationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subnature_indicationContext *subnature_indication();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Alias_indicationContext* alias_indication();

  class AllocatorContext : public ParserRuleContext {
  public:
    AllocatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *NEW();
    Qualified_expressionContext *qualified_expression();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  AllocatorContext* allocator();

  class Architecture_bodyContext : public ParserRuleContext {
  public:
    Architecture_bodyContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> ARCHITECTURE();
    tree::TerminalNode* ARCHITECTURE(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *OF();
    tree::TerminalNode *IS();
    Architecture_declarative_partContext *architecture_declarative_part();
    tree::TerminalNode *BEGIN();
    Architecture_statement_partContext *architecture_statement_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Architecture_bodyContext* architecture_body();

  class Architecture_declarative_partContext : public ParserRuleContext {
  public:
    Architecture_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Block_declarative_itemContext *> block_declarative_item();
    Block_declarative_itemContext* block_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Architecture_declarative_partContext* architecture_declarative_part();

  class Architecture_statementContext : public ParserRuleContext {
  public:
    Architecture_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Block_statementContext *block_statement();
    Process_statementContext *process_statement();
    Concurrent_procedure_call_statementContext *concurrent_procedure_call_statement();
    Label_colonContext *label_colon();
    Concurrent_assertion_statementContext *concurrent_assertion_statement();
    Concurrent_signal_assignment_statementContext *concurrent_signal_assignment_statement();
    tree::TerminalNode *POSTPONED();
    Component_instantiation_statementContext *component_instantiation_statement();
    Generate_statementContext *generate_statement();
    Concurrent_break_statementContext *concurrent_break_statement();
    Simultaneous_statementContext *simultaneous_statement();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Architecture_statementContext* architecture_statement();

  class Architecture_statement_partContext : public ParserRuleContext {
  public:
    Architecture_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Architecture_statementContext *> architecture_statement();
    Architecture_statementContext* architecture_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Architecture_statement_partContext* architecture_statement_part();

  class Array_nature_definitionContext : public ParserRuleContext {
  public:
    Array_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Unconstrained_nature_definitionContext *unconstrained_nature_definition();
    Constrained_nature_definitionContext *constrained_nature_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Array_nature_definitionContext* array_nature_definition();

  class Array_type_definitionContext : public ParserRuleContext {
  public:
    Array_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Unconstrained_array_definitionContext *unconstrained_array_definition();
    Constrained_array_definitionContext *constrained_array_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Array_type_definitionContext* array_type_definition();

  class AssertionContext : public ParserRuleContext {
  public:
    AssertionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ASSERT();
    ConditionContext *condition();
    tree::TerminalNode *REPORT();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    tree::TerminalNode *SEVERITY();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  AssertionContext* assertion();

  class Assertion_statementContext : public ParserRuleContext {
  public:
    Assertion_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AssertionContext *assertion();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Assertion_statementContext* assertion_statement();

  class Association_elementContext : public ParserRuleContext {
  public:
    Association_elementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Actual_partContext *actual_part();
    Formal_partContext *formal_part();
    tree::TerminalNode *ARROW();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Association_elementContext* association_element();

  class Association_listContext : public ParserRuleContext {
  public:
    Association_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Association_elementContext *> association_element();
    Association_elementContext* association_element(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Association_listContext* association_list();

  class Attribute_declarationContext : public ParserRuleContext {
  public:
    Attribute_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ATTRIBUTE();
    Label_colonContext *label_colon();
    NameContext *name();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Attribute_declarationContext* attribute_declaration();

  class Attribute_designatorContext : public ParserRuleContext {
  public:
    Attribute_designatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *RANGE();
    tree::TerminalNode *REVERSE_RANGE();
    tree::TerminalNode *ACROSS();
    tree::TerminalNode *THROUGH();
    tree::TerminalNode *REFERENCE();
    tree::TerminalNode *TOLERANCE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Attribute_designatorContext* attribute_designator();

  class Attribute_specificationContext : public ParserRuleContext {
  public:
    Attribute_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ATTRIBUTE();
    Attribute_designatorContext *attribute_designator();
    tree::TerminalNode *OF();
    Entity_specificationContext *entity_specification();
    tree::TerminalNode *IS();
    ExpressionContext *expression();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Attribute_specificationContext* attribute_specification();

  class Base_unit_declarationContext : public ParserRuleContext {
  public:
    Base_unit_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Base_unit_declarationContext* base_unit_declaration();

  class Binding_indicationContext : public ParserRuleContext {
  public:
    Binding_indicationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *USE();
    Entity_aspectContext *entity_aspect();
    Generic_map_aspectContext *generic_map_aspect();
    Port_map_aspectContext *port_map_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Binding_indicationContext* binding_indication();

  class Block_configurationContext : public ParserRuleContext {
  public:
    Block_configurationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> FOR();
    tree::TerminalNode* FOR(size_t i);
    Block_specificationContext *block_specification();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    std::vector<Use_clauseContext *> use_clause();
    Use_clauseContext* use_clause(size_t i);
    std::vector<Configuration_itemContext *> configuration_item();
    Configuration_itemContext* configuration_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_configurationContext* block_configuration();

  class Block_declarative_itemContext : public ParserRuleContext {
  public:
    Block_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Signal_declarationContext *signal_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Component_declarationContext *component_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Configuration_specificationContext *configuration_specification();
    Disconnection_specificationContext *disconnection_specification();
    Step_limit_specificationContext *step_limit_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();
    Nature_declarationContext *nature_declaration();
    Subnature_declarationContext *subnature_declaration();
    Quantity_declarationContext *quantity_declaration();
    Terminal_declarationContext *terminal_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_declarative_itemContext* block_declarative_item();

  class Block_declarative_partContext : public ParserRuleContext {
  public:
    Block_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Block_declarative_itemContext *> block_declarative_item();
    Block_declarative_itemContext* block_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_declarative_partContext* block_declarative_part();

  class Block_headerContext : public ParserRuleContext {
  public:
    Block_headerContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Generic_clauseContext *generic_clause();
    Port_clauseContext *port_clause();
    Generic_map_aspectContext *generic_map_aspect();
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);
    Port_map_aspectContext *port_map_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_headerContext* block_header();

  class Block_specificationContext : public ParserRuleContext {
  public:
    Block_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *LPAREN();
    Index_specificationContext *index_specification();
    tree::TerminalNode *RPAREN();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_specificationContext* block_specification();

  class Block_statementContext : public ParserRuleContext {
  public:
    Block_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Label_colonContext *label_colon();
    std::vector<tree::TerminalNode *> BLOCK();
    tree::TerminalNode* BLOCK(size_t i);
    Block_headerContext *block_header();
    Block_declarative_partContext *block_declarative_part();
    tree::TerminalNode *BEGIN();
    Block_statement_partContext *block_statement_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *LPAREN();
    ExpressionContext *expression();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *IS();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_statementContext* block_statement();

  class Block_statement_partContext : public ParserRuleContext {
  public:
    Block_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Architecture_statementContext *> architecture_statement();
    Architecture_statementContext* architecture_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Block_statement_partContext* block_statement_part();

  class Branch_quantity_declarationContext : public ParserRuleContext {
  public:
    Branch_quantity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *QUANTITY();
    Terminal_aspectContext *terminal_aspect();
    tree::TerminalNode *SEMI();
    Across_aspectContext *across_aspect();
    Through_aspectContext *through_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Branch_quantity_declarationContext* branch_quantity_declaration();

  class Break_elementContext : public ParserRuleContext {
  public:
    Break_elementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    tree::TerminalNode *ARROW();
    ExpressionContext *expression();
    Break_selector_clauseContext *break_selector_clause();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Break_elementContext* break_element();

  class Break_listContext : public ParserRuleContext {
  public:
    Break_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Break_elementContext *> break_element();
    Break_elementContext* break_element(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Break_listContext* break_list();

  class Break_selector_clauseContext : public ParserRuleContext {
  public:
    Break_selector_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FOR();
    NameContext *name();
    tree::TerminalNode *USE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Break_selector_clauseContext* break_selector_clause();

  class Break_statementContext : public ParserRuleContext {
  public:
    Break_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *BREAK();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Break_listContext *break_list();
    tree::TerminalNode *WHEN();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Break_statementContext* break_statement();

  class Case_statementContext : public ParserRuleContext {
  public:
    Case_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> CASE();
    tree::TerminalNode* CASE(size_t i);
    ExpressionContext *expression();
    tree::TerminalNode *IS();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    std::vector<Case_statement_alternativeContext *> case_statement_alternative();
    Case_statement_alternativeContext* case_statement_alternative(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Case_statementContext* case_statement();

  class Case_statement_alternativeContext : public ParserRuleContext {
  public:
    Case_statement_alternativeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *WHEN();
    ChoicesContext *choices();
    tree::TerminalNode *ARROW();
    Sequence_of_statementsContext *sequence_of_statements();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Case_statement_alternativeContext* case_statement_alternative();

  class ChoiceContext : public ParserRuleContext {
  public:
    ChoiceContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    Discrete_rangeContext *discrete_range();
    Simple_expressionContext *simple_expression();
    tree::TerminalNode *OTHERS();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  ChoiceContext* choice();

  class ChoicesContext : public ParserRuleContext {
  public:
    ChoicesContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ChoiceContext *> choice();
    ChoiceContext* choice(size_t i);
    std::vector<tree::TerminalNode *> BAR();
    tree::TerminalNode* BAR(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  ChoicesContext* choices();

  class Component_configurationContext : public ParserRuleContext {
  public:
    Component_configurationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> FOR();
    tree::TerminalNode* FOR(size_t i);
    Component_specificationContext *component_specification();
    tree::TerminalNode *END();
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);
    Binding_indicationContext *binding_indication();
    Block_configurationContext *block_configuration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_configurationContext* component_configuration();

  class Component_declarationContext : public ParserRuleContext {
  public:
    Component_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> COMPONENT();
    tree::TerminalNode* COMPONENT(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *IS();
    Generic_clauseContext *generic_clause();
    Port_clauseContext *port_clause();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_declarationContext* component_declaration();

  class Component_instantiation_statementContext : public ParserRuleContext {
  public:
    Component_instantiation_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Label_colonContext *label_colon();
    Instantiated_unitContext *instantiated_unit();
    tree::TerminalNode *SEMI();
    Generic_map_aspectContext *generic_map_aspect();
    Port_map_aspectContext *port_map_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_instantiation_statementContext* component_instantiation_statement();

  class Component_specificationContext : public ParserRuleContext {
  public:
    Component_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Instantiation_listContext *instantiation_list();
    tree::TerminalNode *COLON();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_specificationContext* component_specification();

  class Composite_nature_definitionContext : public ParserRuleContext {
  public:
    Composite_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Array_nature_definitionContext *array_nature_definition();
    Record_nature_definitionContext *record_nature_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Composite_nature_definitionContext* composite_nature_definition();

  class Composite_type_definitionContext : public ParserRuleContext {
  public:
    Composite_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Array_type_definitionContext *array_type_definition();
    Record_type_definitionContext *record_type_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Composite_type_definitionContext* composite_type_definition();

  class Concurrent_assertion_statementContext : public ParserRuleContext {
  public:
    Concurrent_assertion_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    AssertionContext *assertion();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    tree::TerminalNode *POSTPONED();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Concurrent_assertion_statementContext* concurrent_assertion_statement();

  class Concurrent_break_statementContext : public ParserRuleContext {
  public:
    Concurrent_break_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *BREAK();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Break_listContext *break_list();
    Sensitivity_clauseContext *sensitivity_clause();
    tree::TerminalNode *WHEN();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Concurrent_break_statementContext* concurrent_break_statement();

  class Concurrent_procedure_call_statementContext : public ParserRuleContext {
  public:
    Concurrent_procedure_call_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Procedure_callContext *procedure_call();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    tree::TerminalNode *POSTPONED();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Concurrent_procedure_call_statementContext* concurrent_procedure_call_statement();

  class Concurrent_signal_assignment_statementContext : public ParserRuleContext {
  public:
    Concurrent_signal_assignment_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Conditional_signal_assignmentContext *conditional_signal_assignment();
    Selected_signal_assignmentContext *selected_signal_assignment();
    Label_colonContext *label_colon();
    tree::TerminalNode *POSTPONED();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Concurrent_signal_assignment_statementContext* concurrent_signal_assignment_statement();

  class ConditionContext : public ParserRuleContext {
  public:
    ConditionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  ConditionContext* condition();

  class Condition_clauseContext : public ParserRuleContext {
  public:
    Condition_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *UNTIL();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Condition_clauseContext* condition_clause();

  class Conditional_signal_assignmentContext : public ParserRuleContext {
  public:
    Conditional_signal_assignmentContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TargetContext *target();
    tree::TerminalNode *LE();
    OptsContext *opts();
    Conditional_waveformsContext *conditional_waveforms();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Conditional_signal_assignmentContext* conditional_signal_assignment();

  class Conditional_waveformsContext : public ParserRuleContext {
  public:
    Conditional_waveformsContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    WaveformContext *waveform();
    tree::TerminalNode *WHEN();
    ConditionContext *condition();
    tree::TerminalNode *ELSE();
    Conditional_waveformsContext *conditional_waveforms();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Conditional_waveformsContext* conditional_waveforms();

  class Configuration_declarationContext : public ParserRuleContext {
  public:
    Configuration_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> CONFIGURATION();
    tree::TerminalNode* CONFIGURATION(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *OF();
    NameContext *name();
    tree::TerminalNode *IS();
    Configuration_declarative_partContext *configuration_declarative_part();
    Block_configurationContext *block_configuration();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Configuration_declarationContext* configuration_declaration();

  class Configuration_declarative_itemContext : public ParserRuleContext {
  public:
    Configuration_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Use_clauseContext *use_clause();
    Attribute_specificationContext *attribute_specification();
    Group_declarationContext *group_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Configuration_declarative_itemContext* configuration_declarative_item();

  class Configuration_declarative_partContext : public ParserRuleContext {
  public:
    Configuration_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Configuration_declarative_itemContext *> configuration_declarative_item();
    Configuration_declarative_itemContext* configuration_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Configuration_declarative_partContext* configuration_declarative_part();

  class Configuration_itemContext : public ParserRuleContext {
  public:
    Configuration_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Block_configurationContext *block_configuration();
    Component_configurationContext *component_configuration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Configuration_itemContext* configuration_item();

  class Configuration_specificationContext : public ParserRuleContext {
  public:
    Configuration_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FOR();
    Component_specificationContext *component_specification();
    Binding_indicationContext *binding_indication();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Configuration_specificationContext* configuration_specification();

  class Constant_declarationContext : public ParserRuleContext {
  public:
    Constant_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *CONSTANT();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Constant_declarationContext* constant_declaration();

  class Constrained_array_definitionContext : public ParserRuleContext {
  public:
    Constrained_array_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ARRAY();
    Index_constraintContext *index_constraint();
    tree::TerminalNode *OF();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Constrained_array_definitionContext* constrained_array_definition();

  class Constrained_nature_definitionContext : public ParserRuleContext {
  public:
    Constrained_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ARRAY();
    Index_constraintContext *index_constraint();
    tree::TerminalNode *OF();
    Subnature_indicationContext *subnature_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Constrained_nature_definitionContext* constrained_nature_definition();

  class ConstraintContext : public ParserRuleContext {
  public:
    ConstraintContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Range_constraintContext *range_constraint();
    Index_constraintContext *index_constraint();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  ConstraintContext* constraint();

  class Context_clauseContext : public ParserRuleContext {
  public:
    Context_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Context_itemContext *> context_item();
    Context_itemContext* context_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Context_clauseContext* context_clause();

  class Context_itemContext : public ParserRuleContext {
  public:
    Context_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Library_clauseContext *library_clause();
    Use_clauseContext *use_clause();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Context_itemContext* context_item();

  class Delay_mechanismContext : public ParserRuleContext {
  public:
    Delay_mechanismContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TRANSPORT();
    tree::TerminalNode *INERTIAL();
    tree::TerminalNode *REJECT();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Delay_mechanismContext* delay_mechanism();

  class Design_fileContext : public ParserRuleContext {
  public:
    Design_fileContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *EOF();
    std::vector<Design_unitContext *> design_unit();
    Design_unitContext* design_unit(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Design_fileContext* design_file();

  class Design_unitContext : public ParserRuleContext {
  public:
    Design_unitContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Context_clauseContext *context_clause();
    Library_unitContext *library_unit();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Design_unitContext* design_unit();

  class DesignatorContext : public ParserRuleContext {
  public:
    DesignatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *STRING_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  DesignatorContext* designator();

  class DirectionContext : public ParserRuleContext {
  public:
    DirectionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TO();
    tree::TerminalNode *DOWNTO();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  DirectionContext* direction();

  class Disconnection_specificationContext : public ParserRuleContext {
  public:
    Disconnection_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *DISCONNECT();
    Guarded_signal_specificationContext *guarded_signal_specification();
    tree::TerminalNode *AFTER();
    ExpressionContext *expression();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Disconnection_specificationContext* disconnection_specification();

  class Discrete_rangeContext : public ParserRuleContext {
  public:
    Discrete_rangeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    RangeContext *range();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Discrete_rangeContext* discrete_range();

  class Element_associationContext : public ParserRuleContext {
  public:
    Element_associationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();
    ChoicesContext *choices();
    tree::TerminalNode *ARROW();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Element_associationContext* element_association();

  class Element_declarationContext : public ParserRuleContext {
  public:
    Element_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Element_subtype_definitionContext *element_subtype_definition();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Element_declarationContext* element_declaration();

  class Element_subnature_definitionContext : public ParserRuleContext {
  public:
    Element_subnature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subnature_indicationContext *subnature_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Element_subnature_definitionContext* element_subnature_definition();

  class Element_subtype_definitionContext : public ParserRuleContext {
  public:
    Element_subtype_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Element_subtype_definitionContext* element_subtype_definition();

  class Entity_aspectContext : public ParserRuleContext {
  public:
    Entity_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ENTITY();
    NameContext *name();
    tree::TerminalNode *LPAREN();
    IdentifierContext *identifier();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *CONFIGURATION();
    tree::TerminalNode *OPEN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_aspectContext* entity_aspect();

  class Entity_classContext : public ParserRuleContext {
  public:
    Entity_classContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ENTITY();
    tree::TerminalNode *ARCHITECTURE();
    tree::TerminalNode *CONFIGURATION();
    tree::TerminalNode *PROCEDURE();
    tree::TerminalNode *FUNCTION();
    tree::TerminalNode *PACKAGE();
    tree::TerminalNode *TYPE();
    tree::TerminalNode *SUBTYPE();
    tree::TerminalNode *CONSTANT();
    tree::TerminalNode *SIGNAL();
    tree::TerminalNode *VARIABLE();
    tree::TerminalNode *COMPONENT();
    tree::TerminalNode *LABEL();
    tree::TerminalNode *LITERAL();
    tree::TerminalNode *UNITS();
    tree::TerminalNode *GROUP();
    tree::TerminalNode *FILE();
    tree::TerminalNode *NATURE();
    tree::TerminalNode *SUBNATURE();
    tree::TerminalNode *QUANTITY();
    tree::TerminalNode *TERMINAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_classContext* entity_class();

  class Entity_class_entryContext : public ParserRuleContext {
  public:
    Entity_class_entryContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Entity_classContext *entity_class();
    tree::TerminalNode *BOX();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_class_entryContext* entity_class_entry();

  class Entity_class_entry_listContext : public ParserRuleContext {
  public:
    Entity_class_entry_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Entity_class_entryContext *> entity_class_entry();
    Entity_class_entryContext* entity_class_entry(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_class_entry_listContext* entity_class_entry_list();

  class Entity_declarationContext : public ParserRuleContext {
  public:
    Entity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> ENTITY();
    tree::TerminalNode* ENTITY(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *IS();
    Entity_headerContext *entity_header();
    Entity_declarative_partContext *entity_declarative_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *BEGIN();
    Entity_statement_partContext *entity_statement_part();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_declarationContext* entity_declaration();

  class Entity_declarative_itemContext : public ParserRuleContext {
  public:
    Entity_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Signal_declarationContext *signal_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Disconnection_specificationContext *disconnection_specification();
    Step_limit_specificationContext *step_limit_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();
    Nature_declarationContext *nature_declaration();
    Subnature_declarationContext *subnature_declaration();
    Quantity_declarationContext *quantity_declaration();
    Terminal_declarationContext *terminal_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_declarative_itemContext* entity_declarative_item();

  class Entity_declarative_partContext : public ParserRuleContext {
  public:
    Entity_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Entity_declarative_itemContext *> entity_declarative_item();
    Entity_declarative_itemContext* entity_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_declarative_partContext* entity_declarative_part();

  class Entity_designatorContext : public ParserRuleContext {
  public:
    Entity_designatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Entity_tagContext *entity_tag();
    SignatureContext *signature();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_designatorContext* entity_designator();

  class Entity_headerContext : public ParserRuleContext {
  public:
    Entity_headerContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Generic_clauseContext *generic_clause();
    Port_clauseContext *port_clause();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_headerContext* entity_header();

  class Entity_name_listContext : public ParserRuleContext {
  public:
    Entity_name_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Entity_designatorContext *> entity_designator();
    Entity_designatorContext* entity_designator(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);
    tree::TerminalNode *OTHERS();
    tree::TerminalNode *ALL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_name_listContext* entity_name_list();

  class Entity_specificationContext : public ParserRuleContext {
  public:
    Entity_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Entity_name_listContext *entity_name_list();
    tree::TerminalNode *COLON();
    Entity_classContext *entity_class();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_specificationContext* entity_specification();

  class Entity_statementContext : public ParserRuleContext {
  public:
    Entity_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Concurrent_assertion_statementContext *concurrent_assertion_statement();
    Process_statementContext *process_statement();
    Concurrent_procedure_call_statementContext *concurrent_procedure_call_statement();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_statementContext* entity_statement();

  class Entity_statement_partContext : public ParserRuleContext {
  public:
    Entity_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Entity_statementContext *> entity_statement();
    Entity_statementContext* entity_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_statement_partContext* entity_statement_part();

  class Entity_tagContext : public ParserRuleContext {
  public:
    Entity_tagContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *CHARACTER_LITERAL();
    tree::TerminalNode *STRING_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Entity_tagContext* entity_tag();

  class Enumeration_literalContext : public ParserRuleContext {
  public:
    Enumeration_literalContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *CHARACTER_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Enumeration_literalContext* enumeration_literal();

  class Enumeration_type_definitionContext : public ParserRuleContext {
  public:
    Enumeration_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LPAREN();
    std::vector<Enumeration_literalContext *> enumeration_literal();
    Enumeration_literalContext* enumeration_literal(size_t i);
    tree::TerminalNode *RPAREN();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Enumeration_type_definitionContext* enumeration_type_definition();

  class Exit_statementContext : public ParserRuleContext {
  public:
    Exit_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *EXIT();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    IdentifierContext *identifier();
    tree::TerminalNode *WHEN();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Exit_statementContext* exit_statement();

  class ExpressionContext : public ParserRuleContext {
  public:
    ExpressionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<RelationContext *> relation();
    RelationContext* relation(size_t i);
    std::vector<Logical_operatorContext *> logical_operator();
    Logical_operatorContext* logical_operator(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  ExpressionContext* expression();

  class FactorContext : public ParserRuleContext {
  public:
    FactorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<PrimaryContext *> primary();
    PrimaryContext* primary(size_t i);
    tree::TerminalNode *DOUBLESTAR();
    tree::TerminalNode *ABS();
    tree::TerminalNode *NOT();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  FactorContext* factor();

  class File_declarationContext : public ParserRuleContext {
  public:
    File_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FILE();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();
    File_open_informationContext *file_open_information();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  File_declarationContext* file_declaration();

  class File_logical_nameContext : public ParserRuleContext {
  public:
    File_logical_nameContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  File_logical_nameContext* file_logical_name();

  class File_open_informationContext : public ParserRuleContext {
  public:
    File_open_informationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *IS();
    File_logical_nameContext *file_logical_name();
    tree::TerminalNode *OPEN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  File_open_informationContext* file_open_information();

  class File_type_definitionContext : public ParserRuleContext {
  public:
    File_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FILE();
    tree::TerminalNode *OF();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  File_type_definitionContext* file_type_definition();

  class Formal_parameter_listContext : public ParserRuleContext {
  public:
    Formal_parameter_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Interface_listContext *interface_list();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Formal_parameter_listContext* formal_parameter_list();

  class Formal_partContext : public ParserRuleContext {
  public:
    Formal_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *LPAREN();
    Explicit_rangeContext *explicit_range();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Formal_partContext* formal_part();

  class Free_quantity_declarationContext : public ParserRuleContext {
  public:
    Free_quantity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *QUANTITY();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Free_quantity_declarationContext* free_quantity_declaration();

  class Generate_statementContext : public ParserRuleContext {
  public:
    Generate_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Label_colonContext *label_colon();
    Generation_schemeContext *generation_scheme();
    std::vector<tree::TerminalNode *> GENERATE();
    tree::TerminalNode* GENERATE(size_t i);
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *BEGIN();
    std::vector<Architecture_statementContext *> architecture_statement();
    Architecture_statementContext* architecture_statement(size_t i);
    IdentifierContext *identifier();
    std::vector<Block_declarative_itemContext *> block_declarative_item();
    Block_declarative_itemContext* block_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Generate_statementContext* generate_statement();

  class Generation_schemeContext : public ParserRuleContext {
  public:
    Generation_schemeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FOR();
    Parameter_specificationContext *parameter_specification();
    tree::TerminalNode *IF();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Generation_schemeContext* generation_scheme();

  class Generic_clauseContext : public ParserRuleContext {
  public:
    Generic_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *GENERIC();
    tree::TerminalNode *LPAREN();
    Generic_listContext *generic_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Generic_clauseContext* generic_clause();

  class Generic_listContext : public ParserRuleContext {
  public:
    Generic_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Interface_constant_declarationContext *> interface_constant_declaration();
    Interface_constant_declarationContext* interface_constant_declaration(size_t i);
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Generic_listContext* generic_list();

  class Generic_map_aspectContext : public ParserRuleContext {
  public:
    Generic_map_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *GENERIC();
    tree::TerminalNode *MAP();
    tree::TerminalNode *LPAREN();
    Association_listContext *association_list();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Generic_map_aspectContext* generic_map_aspect();

  class Group_constituentContext : public ParserRuleContext {
  public:
    Group_constituentContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    tree::TerminalNode *CHARACTER_LITERAL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Group_constituentContext* group_constituent();

  class Group_constituent_listContext : public ParserRuleContext {
  public:
    Group_constituent_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Group_constituentContext *> group_constituent();
    Group_constituentContext* group_constituent(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Group_constituent_listContext* group_constituent_list();

  class Group_declarationContext : public ParserRuleContext {
  public:
    Group_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *GROUP();
    Label_colonContext *label_colon();
    NameContext *name();
    tree::TerminalNode *LPAREN();
    Group_constituent_listContext *group_constituent_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Group_declarationContext* group_declaration();

  class Group_template_declarationContext : public ParserRuleContext {
  public:
    Group_template_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *GROUP();
    IdentifierContext *identifier();
    tree::TerminalNode *IS();
    tree::TerminalNode *LPAREN();
    Entity_class_entry_listContext *entity_class_entry_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Group_template_declarationContext* group_template_declaration();

  class Guarded_signal_specificationContext : public ParserRuleContext {
  public:
    Guarded_signal_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Signal_listContext *signal_list();
    tree::TerminalNode *COLON();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Guarded_signal_specificationContext* guarded_signal_specification();

  class IdentifierContext : public ParserRuleContext {
  public:
    IdentifierContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *BASIC_IDENTIFIER();
    tree::TerminalNode *EXTENDED_IDENTIFIER();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  IdentifierContext* identifier();

  class Identifier_listContext : public ParserRuleContext {
  public:
    Identifier_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Identifier_listContext* identifier_list();

  class If_statementContext : public ParserRuleContext {
  public:
    If_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> IF();
    tree::TerminalNode* IF(size_t i);
    std::vector<ConditionContext *> condition();
    ConditionContext* condition(size_t i);
    std::vector<tree::TerminalNode *> THEN();
    tree::TerminalNode* THEN(size_t i);
    std::vector<Sequence_of_statementsContext *> sequence_of_statements();
    Sequence_of_statementsContext* sequence_of_statements(size_t i);
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    std::vector<tree::TerminalNode *> ELSIF();
    tree::TerminalNode* ELSIF(size_t i);
    tree::TerminalNode *ELSE();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  If_statementContext* if_statement();

  class Index_constraintContext : public ParserRuleContext {
  public:
    Index_constraintContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LPAREN();
    std::vector<Discrete_rangeContext *> discrete_range();
    Discrete_rangeContext* discrete_range(size_t i);
    tree::TerminalNode *RPAREN();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Index_constraintContext* index_constraint();

  class Index_specificationContext : public ParserRuleContext {
  public:
    Index_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Discrete_rangeContext *discrete_range();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Index_specificationContext* index_specification();

  class Index_subtype_definitionContext : public ParserRuleContext {
  public:
    Index_subtype_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    tree::TerminalNode *RANGE();
    tree::TerminalNode *BOX();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Index_subtype_definitionContext* index_subtype_definition();

  class Instantiated_unitContext : public ParserRuleContext {
  public:
    Instantiated_unitContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    tree::TerminalNode *COMPONENT();
    tree::TerminalNode *ENTITY();
    tree::TerminalNode *LPAREN();
    IdentifierContext *identifier();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *CONFIGURATION();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Instantiated_unitContext* instantiated_unit();

  class Instantiation_listContext : public ParserRuleContext {
  public:
    Instantiation_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);
    tree::TerminalNode *OTHERS();
    tree::TerminalNode *ALL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Instantiation_listContext* instantiation_list();

  class Interface_constant_declarationContext : public ParserRuleContext {
  public:
    Interface_constant_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *CONSTANT();
    tree::TerminalNode *IN();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_constant_declarationContext* interface_constant_declaration();

  class Interface_declarationContext : public ParserRuleContext {
  public:
    Interface_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Interface_constant_declarationContext *interface_constant_declaration();
    Interface_signal_declarationContext *interface_signal_declaration();
    Interface_variable_declarationContext *interface_variable_declaration();
    Interface_file_declarationContext *interface_file_declaration();
    Interface_terminal_declarationContext *interface_terminal_declaration();
    Interface_quantity_declarationContext *interface_quantity_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_declarationContext* interface_declaration();

  class Interface_elementContext : public ParserRuleContext {
  public:
    Interface_elementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Interface_declarationContext *interface_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_elementContext* interface_element();

  class Interface_file_declarationContext : public ParserRuleContext {
  public:
    Interface_file_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FILE();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_file_declarationContext* interface_file_declaration();

  class Interface_signal_listContext : public ParserRuleContext {
  public:
    Interface_signal_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Interface_signal_declarationContext *> interface_signal_declaration();
    Interface_signal_declarationContext* interface_signal_declaration(size_t i);
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_signal_listContext* interface_signal_list();

  class Interface_port_listContext : public ParserRuleContext {
  public:
    Interface_port_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Interface_port_declarationContext *> interface_port_declaration();
    Interface_port_declarationContext* interface_port_declaration(size_t i);
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_port_listContext* interface_port_list();

  class Interface_listContext : public ParserRuleContext {
  public:
    Interface_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Interface_elementContext *> interface_element();
    Interface_elementContext* interface_element(size_t i);
    std::vector<tree::TerminalNode *> SEMI();
    tree::TerminalNode* SEMI(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_listContext* interface_list();

  class Interface_quantity_declarationContext : public ParserRuleContext {
  public:
    Interface_quantity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *QUANTITY();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();
    tree::TerminalNode *IN();
    tree::TerminalNode *OUT();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_quantity_declarationContext* interface_quantity_declaration();

  class Interface_port_declarationContext : public ParserRuleContext {
  public:
    Interface_port_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Signal_modeContext *signal_mode();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *BUS();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_port_declarationContext* interface_port_declaration();

  class Interface_signal_declarationContext : public ParserRuleContext {
  public:
    Interface_signal_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SIGNAL();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *BUS();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();
    tree::TerminalNode *IN();
    tree::TerminalNode *OUT();
    tree::TerminalNode *INOUT();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_signal_declarationContext* interface_signal_declaration();

  class Interface_terminal_declarationContext : public ParserRuleContext {
  public:
    Interface_terminal_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TERMINAL();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subnature_indicationContext *subnature_indication();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_terminal_declarationContext* interface_terminal_declaration();

  class Interface_variable_declarationContext : public ParserRuleContext {
  public:
    Interface_variable_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *VARIABLE();
    Signal_modeContext *signal_mode();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Interface_variable_declarationContext* interface_variable_declaration();

  class Iteration_schemeContext : public ParserRuleContext {
  public:
    Iteration_schemeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *WHILE();
    ConditionContext *condition();
    tree::TerminalNode *FOR();
    Parameter_specificationContext *parameter_specification();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Iteration_schemeContext* iteration_scheme();

  class Label_colonContext : public ParserRuleContext {
  public:
    Label_colonContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *COLON();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Label_colonContext* label_colon();

  class Library_clauseContext : public ParserRuleContext {
  public:
    Library_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LIBRARY();
    Logical_name_listContext *logical_name_list();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Library_clauseContext* library_clause();

  class Library_unitContext : public ParserRuleContext {
  public:
    Library_unitContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Secondary_unitContext *secondary_unit();
    Primary_unitContext *primary_unit();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Library_unitContext* library_unit();

  class LiteralContext : public ParserRuleContext {
  public:
    LiteralContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *NULL_SYM();
    tree::TerminalNode *BIT_STRING_LITERAL();
    tree::TerminalNode *STRING_LITERAL();
    Enumeration_literalContext *enumeration_literal();
    Numeric_literalContext *numeric_literal();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  LiteralContext* literal();

  class Logical_nameContext : public ParserRuleContext {
  public:
    Logical_nameContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Logical_nameContext* logical_name();

  class Logical_name_listContext : public ParserRuleContext {
  public:
    Logical_name_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Logical_nameContext *> logical_name();
    Logical_nameContext* logical_name(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Logical_name_listContext* logical_name_list();

  class Logical_operatorContext : public ParserRuleContext {
  public:
    Logical_operatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *AND();
    tree::TerminalNode *OR();
    tree::TerminalNode *NAND();
    tree::TerminalNode *NOR();
    tree::TerminalNode *XOR();
    tree::TerminalNode *XNOR();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Logical_operatorContext* logical_operator();

  class Loop_statementContext : public ParserRuleContext {
  public:
    Loop_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> LOOP();
    tree::TerminalNode* LOOP(size_t i);
    Sequence_of_statementsContext *sequence_of_statements();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Iteration_schemeContext *iteration_scheme();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Loop_statementContext* loop_statement();

  class Signal_modeContext : public ParserRuleContext {
  public:
    Signal_modeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *IN();
    tree::TerminalNode *OUT();
    tree::TerminalNode *INOUT();
    tree::TerminalNode *BUFFER();
    tree::TerminalNode *LINKAGE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Signal_modeContext* signal_mode();

  class Multiplying_operatorContext : public ParserRuleContext {
  public:
    Multiplying_operatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *MUL();
    tree::TerminalNode *DIV();
    tree::TerminalNode *MOD();
    tree::TerminalNode *REM();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Multiplying_operatorContext* multiplying_operator();

  class NameContext : public ParserRuleContext {
  public:
    NameContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Selected_nameContext *selected_name();
    std::vector<Name_partContext *> name_part();
    Name_partContext* name_part(size_t i);
    std::vector<tree::TerminalNode *> DOT();
    tree::TerminalNode* DOT(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  NameContext* name();

  class Name_partContext : public ParserRuleContext {
  public:
    Name_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Selected_nameContext *selected_name();
    std::vector<Name_part_specificatorContext *> name_part_specificator();
    Name_part_specificatorContext* name_part_specificator(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Name_partContext* name_part();

  class Name_part_specificatorContext : public ParserRuleContext {
  public:
    Name_part_specificatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Name_attribute_partContext *name_attribute_part();
    Name_function_call_or_indexed_partContext *name_function_call_or_indexed_part();
    Name_slice_partContext *name_slice_part();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Name_part_specificatorContext* name_part_specificator();

  class Name_attribute_partContext : public ParserRuleContext {
  public:
    Name_attribute_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *APOSTROPHE();
    Attribute_designatorContext *attribute_designator();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Name_attribute_partContext* name_attribute_part();

  class Name_function_call_or_indexed_partContext : public ParserRuleContext {
  public:
    Name_function_call_or_indexed_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LPAREN();
    tree::TerminalNode *RPAREN();
    Actual_parameter_partContext *actual_parameter_part();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Name_function_call_or_indexed_partContext* name_function_call_or_indexed_part();

  class Name_slice_partContext : public ParserRuleContext {
  public:
    Name_slice_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LPAREN();
    std::vector<Explicit_rangeContext *> explicit_range();
    Explicit_rangeContext* explicit_range(size_t i);
    tree::TerminalNode *RPAREN();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Name_slice_partContext* name_slice_part();

  class Selected_nameContext : public ParserRuleContext {
  public:
    Selected_nameContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    std::vector<tree::TerminalNode *> DOT();
    tree::TerminalNode* DOT(size_t i);
    std::vector<SuffixContext *> suffix();
    SuffixContext* suffix(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Selected_nameContext* selected_name();

  class Nature_declarationContext : public ParserRuleContext {
  public:
    Nature_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *NATURE();
    IdentifierContext *identifier();
    tree::TerminalNode *IS();
    Nature_definitionContext *nature_definition();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Nature_declarationContext* nature_declaration();

  class Nature_definitionContext : public ParserRuleContext {
  public:
    Nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Scalar_nature_definitionContext *scalar_nature_definition();
    Composite_nature_definitionContext *composite_nature_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Nature_definitionContext* nature_definition();

  class Nature_element_declarationContext : public ParserRuleContext {
  public:
    Nature_element_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Element_subnature_definitionContext *element_subnature_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Nature_element_declarationContext* nature_element_declaration();

  class Next_statementContext : public ParserRuleContext {
  public:
    Next_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *NEXT();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    IdentifierContext *identifier();
    tree::TerminalNode *WHEN();
    ConditionContext *condition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Next_statementContext* next_statement();

  class Numeric_literalContext : public ParserRuleContext {
  public:
    Numeric_literalContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Abstract_literalContext *abstract_literal();
    Physical_literalContext *physical_literal();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Numeric_literalContext* numeric_literal();

  class Object_declarationContext : public ParserRuleContext {
  public:
    Object_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Constant_declarationContext *constant_declaration();
    Signal_declarationContext *signal_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Terminal_declarationContext *terminal_declaration();
    Quantity_declarationContext *quantity_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Object_declarationContext* object_declaration();

  class OptsContext : public ParserRuleContext {
  public:
    OptsContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *GUARDED();
    Delay_mechanismContext *delay_mechanism();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  OptsContext* opts();

  class Package_bodyContext : public ParserRuleContext {
  public:
    Package_bodyContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> PACKAGE();
    tree::TerminalNode* PACKAGE(size_t i);
    std::vector<tree::TerminalNode *> BODY();
    tree::TerminalNode* BODY(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *IS();
    Package_body_declarative_partContext *package_body_declarative_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_bodyContext* package_body();

  class Package_body_declarative_itemContext : public ParserRuleContext {
  public:
    Package_body_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_body_declarative_itemContext* package_body_declarative_item();

  class Package_body_declarative_partContext : public ParserRuleContext {
  public:
    Package_body_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Package_body_declarative_itemContext *> package_body_declarative_item();
    Package_body_declarative_itemContext* package_body_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_body_declarative_partContext* package_body_declarative_part();

  class Package_declarationContext : public ParserRuleContext {
  public:
    Package_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> PACKAGE();
    tree::TerminalNode* PACKAGE(size_t i);
    std::vector<IdentifierContext *> identifier();
    IdentifierContext* identifier(size_t i);
    tree::TerminalNode *IS();
    Package_declarative_partContext *package_declarative_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_declarationContext* package_declaration();

  class Package_declarative_itemContext : public ParserRuleContext {
  public:
    Package_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Signal_declarationContext *signal_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Component_declarationContext *component_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Disconnection_specificationContext *disconnection_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();
    Nature_declarationContext *nature_declaration();
    Subnature_declarationContext *subnature_declaration();
    Terminal_declarationContext *terminal_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_declarative_itemContext* package_declarative_item();

  class Package_declarative_partContext : public ParserRuleContext {
  public:
    Package_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Package_declarative_itemContext *> package_declarative_item();
    Package_declarative_itemContext* package_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Package_declarative_partContext* package_declarative_part();

  class Parameter_specificationContext : public ParserRuleContext {
  public:
    Parameter_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *IN();
    Discrete_rangeContext *discrete_range();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Parameter_specificationContext* parameter_specification();

  class Physical_literalContext : public ParserRuleContext {
  public:
    Physical_literalContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Abstract_literalContext *abstract_literal();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Physical_literalContext* physical_literal();

  class Physical_type_definitionContext : public ParserRuleContext {
  public:
    Physical_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Range_constraintContext *range_constraint();
    std::vector<tree::TerminalNode *> UNITS();
    tree::TerminalNode* UNITS(size_t i);
    Base_unit_declarationContext *base_unit_declaration();
    tree::TerminalNode *END();
    std::vector<Secondary_unit_declarationContext *> secondary_unit_declaration();
    Secondary_unit_declarationContext* secondary_unit_declaration(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Physical_type_definitionContext* physical_type_definition();

  class Port_clauseContext : public ParserRuleContext {
  public:
    Port_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *PORT();
    tree::TerminalNode *LPAREN();
    Port_listContext *port_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Port_clauseContext* port_clause();

  class Port_listContext : public ParserRuleContext {
  public:
    Port_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Interface_port_listContext *interface_port_list();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Port_listContext* port_list();

  class Port_map_aspectContext : public ParserRuleContext {
  public:
    Port_map_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *PORT();
    tree::TerminalNode *MAP();
    tree::TerminalNode *LPAREN();
    Association_listContext *association_list();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Port_map_aspectContext* port_map_aspect();

  class PrimaryContext : public ParserRuleContext {
  public:
    PrimaryContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    Qualified_expressionContext *qualified_expression();
    tree::TerminalNode *LPAREN();
    ExpressionContext *expression();
    tree::TerminalNode *RPAREN();
    AllocatorContext *allocator();
    AggregateContext *aggregate();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  PrimaryContext* primary();

  class Primary_unitContext : public ParserRuleContext {
  public:
    Primary_unitContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Entity_declarationContext *entity_declaration();
    Configuration_declarationContext *configuration_declaration();
    Package_declarationContext *package_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Primary_unitContext* primary_unit();

  class Procedural_declarative_itemContext : public ParserRuleContext {
  public:
    Procedural_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Variable_declarationContext *variable_declaration();
    Alias_declarationContext *alias_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedural_declarative_itemContext* procedural_declarative_item();

  class Procedural_declarative_partContext : public ParserRuleContext {
  public:
    Procedural_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Procedural_declarative_itemContext *> procedural_declarative_item();
    Procedural_declarative_itemContext* procedural_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedural_declarative_partContext* procedural_declarative_part();

  class Procedural_statement_partContext : public ParserRuleContext {
  public:
    Procedural_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Sequential_statementContext *> sequential_statement();
    Sequential_statementContext* sequential_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedural_statement_partContext* procedural_statement_part();

  class Procedure_callContext : public ParserRuleContext {
  public:
    Procedure_callContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Selected_nameContext *selected_name();
    tree::TerminalNode *LPAREN();
    Actual_parameter_partContext *actual_parameter_part();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedure_callContext* procedure_call();

  class Procedure_call_statementContext : public ParserRuleContext {
  public:
    Procedure_call_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Procedure_callContext *procedure_call();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedure_call_statementContext* procedure_call_statement();

  class Process_declarative_itemContext : public ParserRuleContext {
  public:
    Process_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Process_declarative_itemContext* process_declarative_item();

  class Process_declarative_partContext : public ParserRuleContext {
  public:
    Process_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Process_declarative_itemContext *> process_declarative_item();
    Process_declarative_itemContext* process_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Process_declarative_partContext* process_declarative_part();

  class Process_statementContext : public ParserRuleContext {
  public:
    Process_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> PROCESS();
    tree::TerminalNode* PROCESS(size_t i);
    Process_declarative_partContext *process_declarative_part();
    tree::TerminalNode *BEGIN();
    Process_statement_partContext *process_statement_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    std::vector<tree::TerminalNode *> POSTPONED();
    tree::TerminalNode* POSTPONED(size_t i);
    tree::TerminalNode *LPAREN();
    Sensitivity_listContext *sensitivity_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *IS();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Process_statementContext* process_statement();

  class Process_statement_partContext : public ParserRuleContext {
  public:
    Process_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Sequential_statementContext *> sequential_statement();
    Sequential_statementContext* sequential_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Process_statement_partContext* process_statement_part();

  class Qualified_expressionContext : public ParserRuleContext {
  public:
    Qualified_expressionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *APOSTROPHE();
    AggregateContext *aggregate();
    tree::TerminalNode *LPAREN();
    ExpressionContext *expression();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Qualified_expressionContext* qualified_expression();

  class Quantity_declarationContext : public ParserRuleContext {
  public:
    Quantity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Free_quantity_declarationContext *free_quantity_declaration();
    Branch_quantity_declarationContext *branch_quantity_declaration();
    Source_quantity_declarationContext *source_quantity_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Quantity_declarationContext* quantity_declaration();

  class Quantity_listContext : public ParserRuleContext {
  public:
    Quantity_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);
    tree::TerminalNode *OTHERS();
    tree::TerminalNode *ALL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Quantity_listContext* quantity_list();

  class Quantity_specificationContext : public ParserRuleContext {
  public:
    Quantity_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Quantity_listContext *quantity_list();
    tree::TerminalNode *COLON();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Quantity_specificationContext* quantity_specification();

  class RangeContext : public ParserRuleContext {
  public:
    RangeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Explicit_rangeContext *explicit_range();
    NameContext *name();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  RangeContext* range();

  class Explicit_rangeContext : public ParserRuleContext {
  public:
    Explicit_rangeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Simple_expressionContext *> simple_expression();
    Simple_expressionContext* simple_expression(size_t i);
    DirectionContext *direction();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Explicit_rangeContext* explicit_range();

  class Range_constraintContext : public ParserRuleContext {
  public:
    Range_constraintContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *RANGE();
    RangeContext *range();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Range_constraintContext* range_constraint();

  class Record_nature_definitionContext : public ParserRuleContext {
  public:
    Record_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> RECORD();
    tree::TerminalNode* RECORD(size_t i);
    tree::TerminalNode *END();
    std::vector<Nature_element_declarationContext *> nature_element_declaration();
    Nature_element_declarationContext* nature_element_declaration(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Record_nature_definitionContext* record_nature_definition();

  class Record_type_definitionContext : public ParserRuleContext {
  public:
    Record_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> RECORD();
    tree::TerminalNode* RECORD(size_t i);
    tree::TerminalNode *END();
    std::vector<Element_declarationContext *> element_declaration();
    Element_declarationContext* element_declaration(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Record_type_definitionContext* record_type_definition();

  class RelationContext : public ParserRuleContext {
  public:
    RelationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Shift_expressionContext *> shift_expression();
    Shift_expressionContext* shift_expression(size_t i);
    Relational_operatorContext *relational_operator();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  RelationContext* relation();

  class Relational_operatorContext : public ParserRuleContext {
  public:
    Relational_operatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *EQ();
    tree::TerminalNode *NEQ();
    tree::TerminalNode *LOWERTHAN();
    tree::TerminalNode *LE();
    tree::TerminalNode *GREATERTHAN();
    tree::TerminalNode *GE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Relational_operatorContext* relational_operator();

  class Report_statementContext : public ParserRuleContext {
  public:
    Report_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *REPORT();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    tree::TerminalNode *SEVERITY();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Report_statementContext* report_statement();

  class Return_statementContext : public ParserRuleContext {
  public:
    Return_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *RETURN();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Return_statementContext* return_statement();

  class Scalar_nature_definitionContext : public ParserRuleContext {
  public:
    Scalar_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    tree::TerminalNode *ACROSS();
    tree::TerminalNode *THROUGH();
    tree::TerminalNode *REFERENCE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Scalar_nature_definitionContext* scalar_nature_definition();

  class Scalar_type_definitionContext : public ParserRuleContext {
  public:
    Scalar_type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Physical_type_definitionContext *physical_type_definition();
    Enumeration_type_definitionContext *enumeration_type_definition();
    Range_constraintContext *range_constraint();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Scalar_type_definitionContext* scalar_type_definition();

  class Secondary_unitContext : public ParserRuleContext {
  public:
    Secondary_unitContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Architecture_bodyContext *architecture_body();
    Package_bodyContext *package_body();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Secondary_unitContext* secondary_unit();

  class Secondary_unit_declarationContext : public ParserRuleContext {
  public:
    Secondary_unit_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *EQ();
    Physical_literalContext *physical_literal();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Secondary_unit_declarationContext* secondary_unit_declaration();

  class Selected_signal_assignmentContext : public ParserRuleContext {
  public:
    Selected_signal_assignmentContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *WITH();
    ExpressionContext *expression();
    tree::TerminalNode *SELECT();
    TargetContext *target();
    tree::TerminalNode *LE();
    OptsContext *opts();
    Selected_waveformsContext *selected_waveforms();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Selected_signal_assignmentContext* selected_signal_assignment();

  class Selected_waveformsContext : public ParserRuleContext {
  public:
    Selected_waveformsContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<WaveformContext *> waveform();
    WaveformContext* waveform(size_t i);
    std::vector<tree::TerminalNode *> WHEN();
    tree::TerminalNode* WHEN(size_t i);
    std::vector<ChoicesContext *> choices();
    ChoicesContext* choices(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Selected_waveformsContext* selected_waveforms();

  class Sensitivity_clauseContext : public ParserRuleContext {
  public:
    Sensitivity_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ON();
    Sensitivity_listContext *sensitivity_list();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Sensitivity_clauseContext* sensitivity_clause();

  class Sensitivity_listContext : public ParserRuleContext {
  public:
    Sensitivity_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Sensitivity_listContext* sensitivity_list();

  class Sequence_of_statementsContext : public ParserRuleContext {
  public:
    Sequence_of_statementsContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Sequential_statementContext *> sequential_statement();
    Sequential_statementContext* sequential_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Sequence_of_statementsContext* sequence_of_statements();

  class Sequential_statementContext : public ParserRuleContext {
  public:
    Sequential_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Wait_statementContext *wait_statement();
    Assertion_statementContext *assertion_statement();
    Report_statementContext *report_statement();
    Signal_assignment_statementContext *signal_assignment_statement();
    Variable_assignment_statementContext *variable_assignment_statement();
    If_statementContext *if_statement();
    Case_statementContext *case_statement();
    Loop_statementContext *loop_statement();
    Next_statementContext *next_statement();
    Exit_statementContext *exit_statement();
    Return_statementContext *return_statement();
    tree::TerminalNode *NULL_SYM();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Break_statementContext *break_statement();
    Procedure_call_statementContext *procedure_call_statement();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Sequential_statementContext* sequential_statement();

  class Shift_expressionContext : public ParserRuleContext {
  public:
    Shift_expressionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Simple_expressionContext *> simple_expression();
    Simple_expressionContext* simple_expression(size_t i);
    Shift_operatorContext *shift_operator();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Shift_expressionContext* shift_expression();

  class Shift_operatorContext : public ParserRuleContext {
  public:
    Shift_operatorContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SLL();
    tree::TerminalNode *SRL();
    tree::TerminalNode *SLA();
    tree::TerminalNode *SRA();
    tree::TerminalNode *ROL();
    tree::TerminalNode *ROR();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Shift_operatorContext* shift_operator();

  class Signal_assignment_statementContext : public ParserRuleContext {
  public:
    Signal_assignment_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TargetContext *target();
    tree::TerminalNode *LE();
    WaveformContext *waveform();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Delay_mechanismContext *delay_mechanism();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Signal_assignment_statementContext* signal_assignment_statement();

  class Signal_declarationContext : public ParserRuleContext {
  public:
    Signal_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SIGNAL();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();
    Signal_kindContext *signal_kind();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Signal_declarationContext* signal_declaration();

  class Signal_kindContext : public ParserRuleContext {
  public:
    Signal_kindContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *REGISTER();
    tree::TerminalNode *BUS();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Signal_kindContext* signal_kind();

  class Signal_listContext : public ParserRuleContext {
  public:
    Signal_listContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);
    tree::TerminalNode *OTHERS();
    tree::TerminalNode *ALL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Signal_listContext* signal_list();

  class SignatureContext : public ParserRuleContext {
  public:
    SignatureContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LBRACKET();
    tree::TerminalNode *RBRACKET();
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    tree::TerminalNode *RETURN();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  SignatureContext* signature();

  class Simple_expressionContext : public ParserRuleContext {
  public:
    Simple_expressionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TermContext *> term();
    TermContext* term(size_t i);
    std::vector<Adding_operatorContext *> adding_operator();
    Adding_operatorContext* adding_operator(size_t i);
    tree::TerminalNode *PLUS();
    tree::TerminalNode *MINUS();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simple_expressionContext* simple_expression();

  class Simple_simultaneous_statementContext : public ParserRuleContext {
  public:
    Simple_simultaneous_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Simple_expressionContext *> simple_expression();
    Simple_expressionContext* simple_expression(size_t i);
    tree::TerminalNode *ASSIGN();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Tolerance_aspectContext *tolerance_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simple_simultaneous_statementContext* simple_simultaneous_statement();

  class Simultaneous_alternativeContext : public ParserRuleContext {
  public:
    Simultaneous_alternativeContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *WHEN();
    ChoicesContext *choices();
    tree::TerminalNode *ARROW();
    Simultaneous_statement_partContext *simultaneous_statement_part();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_alternativeContext* simultaneous_alternative();

  class Simultaneous_case_statementContext : public ParserRuleContext {
  public:
    Simultaneous_case_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> CASE();
    tree::TerminalNode* CASE(size_t i);
    ExpressionContext *expression();
    tree::TerminalNode *USE();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    std::vector<Simultaneous_alternativeContext *> simultaneous_alternative();
    Simultaneous_alternativeContext* simultaneous_alternative(size_t i);
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_case_statementContext* simultaneous_case_statement();

  class Simultaneous_if_statementContext : public ParserRuleContext {
  public:
    Simultaneous_if_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *IF();
    std::vector<ConditionContext *> condition();
    ConditionContext* condition(size_t i);
    std::vector<tree::TerminalNode *> USE();
    tree::TerminalNode* USE(size_t i);
    std::vector<Simultaneous_statement_partContext *> simultaneous_statement_part();
    Simultaneous_statement_partContext* simultaneous_statement_part(size_t i);
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    std::vector<tree::TerminalNode *> ELSIF();
    tree::TerminalNode* ELSIF(size_t i);
    tree::TerminalNode *ELSE();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_if_statementContext* simultaneous_if_statement();

  class Simultaneous_procedural_statementContext : public ParserRuleContext {
  public:
    Simultaneous_procedural_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<tree::TerminalNode *> PROCEDURAL();
    tree::TerminalNode* PROCEDURAL(size_t i);
    Procedural_declarative_partContext *procedural_declarative_part();
    tree::TerminalNode *BEGIN();
    Procedural_statement_partContext *procedural_statement_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    tree::TerminalNode *IS();
    IdentifierContext *identifier();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_procedural_statementContext* simultaneous_procedural_statement();

  class Simultaneous_statementContext : public ParserRuleContext {
  public:
    Simultaneous_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Simple_simultaneous_statementContext *simple_simultaneous_statement();
    Simultaneous_if_statementContext *simultaneous_if_statement();
    Simultaneous_case_statementContext *simultaneous_case_statement();
    Simultaneous_procedural_statementContext *simultaneous_procedural_statement();
    tree::TerminalNode *NULL_SYM();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_statementContext* simultaneous_statement();

  class Simultaneous_statement_partContext : public ParserRuleContext {
  public:
    Simultaneous_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Simultaneous_statementContext *> simultaneous_statement();
    Simultaneous_statementContext* simultaneous_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Simultaneous_statement_partContext* simultaneous_statement_part();

  class Source_aspectContext : public ParserRuleContext {
  public:
    Source_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SPECTRUM();
    std::vector<Simple_expressionContext *> simple_expression();
    Simple_expressionContext* simple_expression(size_t i);
    tree::TerminalNode *COMMA();
    tree::TerminalNode *NOISE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Source_aspectContext* source_aspect();

  class Source_quantity_declarationContext : public ParserRuleContext {
  public:
    Source_quantity_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *QUANTITY();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    Source_aspectContext *source_aspect();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Source_quantity_declarationContext* source_quantity_declaration();

  class Step_limit_specificationContext : public ParserRuleContext {
  public:
    Step_limit_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *LIMIT();
    Quantity_specificationContext *quantity_specification();
    tree::TerminalNode *WITH();
    ExpressionContext *expression();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Step_limit_specificationContext* step_limit_specification();

  class Subnature_declarationContext : public ParserRuleContext {
  public:
    Subnature_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SUBNATURE();
    IdentifierContext *identifier();
    tree::TerminalNode *IS();
    Subnature_indicationContext *subnature_indication();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subnature_declarationContext* subnature_declaration();

  class Subnature_indicationContext : public ParserRuleContext {
  public:
    Subnature_indicationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    Index_constraintContext *index_constraint();
    tree::TerminalNode *TOLERANCE();
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    tree::TerminalNode *ACROSS();
    tree::TerminalNode *THROUGH();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subnature_indicationContext* subnature_indication();

  class Subprogram_bodyContext : public ParserRuleContext {
  public:
    Subprogram_bodyContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_specificationContext *subprogram_specification();
    tree::TerminalNode *IS();
    Subprogram_declarative_partContext *subprogram_declarative_part();
    tree::TerminalNode *BEGIN();
    Subprogram_statement_partContext *subprogram_statement_part();
    tree::TerminalNode *END();
    tree::TerminalNode *SEMI();
    Subprogram_kindContext *subprogram_kind();
    DesignatorContext *designator();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_bodyContext* subprogram_body();

  class Subprogram_declarationContext : public ParserRuleContext {
  public:
    Subprogram_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_specificationContext *subprogram_specification();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_declarationContext* subprogram_declaration();

  class Subprogram_declarative_itemContext : public ParserRuleContext {
  public:
    Subprogram_declarative_itemContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Subprogram_declarationContext *subprogram_declaration();
    Subprogram_bodyContext *subprogram_body();
    Type_declarationContext *type_declaration();
    Subtype_declarationContext *subtype_declaration();
    Constant_declarationContext *constant_declaration();
    Variable_declarationContext *variable_declaration();
    File_declarationContext *file_declaration();
    Alias_declarationContext *alias_declaration();
    Attribute_declarationContext *attribute_declaration();
    Attribute_specificationContext *attribute_specification();
    Use_clauseContext *use_clause();
    Group_template_declarationContext *group_template_declaration();
    Group_declarationContext *group_declaration();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_declarative_itemContext* subprogram_declarative_item();

  class Subprogram_declarative_partContext : public ParserRuleContext {
  public:
    Subprogram_declarative_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Subprogram_declarative_itemContext *> subprogram_declarative_item();
    Subprogram_declarative_itemContext* subprogram_declarative_item(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_declarative_partContext* subprogram_declarative_part();

  class Subprogram_kindContext : public ParserRuleContext {
  public:
    Subprogram_kindContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *PROCEDURE();
    tree::TerminalNode *FUNCTION();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_kindContext* subprogram_kind();

  class Subprogram_specificationContext : public ParserRuleContext {
  public:
    Subprogram_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Procedure_specificationContext *procedure_specification();
    Function_specificationContext *function_specification();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_specificationContext* subprogram_specification();

  class Procedure_specificationContext : public ParserRuleContext {
  public:
    Procedure_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *PROCEDURE();
    DesignatorContext *designator();
    tree::TerminalNode *LPAREN();
    Formal_parameter_listContext *formal_parameter_list();
    tree::TerminalNode *RPAREN();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Procedure_specificationContext* procedure_specification();

  class Function_specificationContext : public ParserRuleContext {
  public:
    Function_specificationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FUNCTION();
    DesignatorContext *designator();
    tree::TerminalNode *RETURN();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *LPAREN();
    Formal_parameter_listContext *formal_parameter_list();
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *PURE();
    tree::TerminalNode *IMPURE();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Function_specificationContext* function_specification();

  class Subprogram_statement_partContext : public ParserRuleContext {
  public:
    Subprogram_statement_partContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Sequential_statementContext *> sequential_statement();
    Sequential_statementContext* sequential_statement(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subprogram_statement_partContext* subprogram_statement_part();

  class Subtype_declarationContext : public ParserRuleContext {
  public:
    Subtype_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *SUBTYPE();
    IdentifierContext *identifier();
    tree::TerminalNode *IS();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subtype_declarationContext* subtype_declaration();

  class Subtype_indicationContext : public ParserRuleContext {
  public:
    Subtype_indicationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Selected_nameContext *> selected_name();
    Selected_nameContext* selected_name(size_t i);
    ConstraintContext *constraint();
    Tolerance_aspectContext *tolerance_aspect();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Subtype_indicationContext* subtype_indication();

  class SuffixContext : public ParserRuleContext {
  public:
    SuffixContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    tree::TerminalNode *CHARACTER_LITERAL();
    tree::TerminalNode *STRING_LITERAL();
    tree::TerminalNode *ALL();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  SuffixContext* suffix();

  class TargetContext : public ParserRuleContext {
  public:
    TargetContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NameContext *name();
    AggregateContext *aggregate();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  TargetContext* target();

  class TermContext : public ParserRuleContext {
  public:
    TermContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<FactorContext *> factor();
    FactorContext* factor(size_t i);
    std::vector<Multiplying_operatorContext *> multiplying_operator();
    Multiplying_operatorContext* multiplying_operator(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  TermContext* term();

  class Terminal_aspectContext : public ParserRuleContext {
  public:
    Terminal_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<NameContext *> name();
    NameContext* name(size_t i);
    tree::TerminalNode *TO();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Terminal_aspectContext* terminal_aspect();

  class Terminal_declarationContext : public ParserRuleContext {
  public:
    Terminal_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TERMINAL();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subnature_indicationContext *subnature_indication();
    tree::TerminalNode *SEMI();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Terminal_declarationContext* terminal_declaration();

  class Through_aspectContext : public ParserRuleContext {
  public:
    Through_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Identifier_listContext *identifier_list();
    tree::TerminalNode *THROUGH();
    Tolerance_aspectContext *tolerance_aspect();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Through_aspectContext* through_aspect();

  class Timeout_clauseContext : public ParserRuleContext {
  public:
    Timeout_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *FOR();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Timeout_clauseContext* timeout_clause();

  class Tolerance_aspectContext : public ParserRuleContext {
  public:
    Tolerance_aspectContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TOLERANCE();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Tolerance_aspectContext* tolerance_aspect();

  class Type_declarationContext : public ParserRuleContext {
  public:
    Type_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *TYPE();
    IdentifierContext *identifier();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *IS();
    Type_definitionContext *type_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Type_declarationContext* type_declaration();

  class Type_definitionContext : public ParserRuleContext {
  public:
    Type_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Scalar_type_definitionContext *scalar_type_definition();
    Composite_type_definitionContext *composite_type_definition();
    Access_type_definitionContext *access_type_definition();
    File_type_definitionContext *file_type_definition();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Type_definitionContext* type_definition();

  class Unconstrained_array_definitionContext : public ParserRuleContext {
  public:
    Unconstrained_array_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ARRAY();
    tree::TerminalNode *LPAREN();
    std::vector<Index_subtype_definitionContext *> index_subtype_definition();
    Index_subtype_definitionContext* index_subtype_definition(size_t i);
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *OF();
    Subtype_indicationContext *subtype_indication();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Unconstrained_array_definitionContext* unconstrained_array_definition();

  class Unconstrained_nature_definitionContext : public ParserRuleContext {
  public:
    Unconstrained_nature_definitionContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *ARRAY();
    tree::TerminalNode *LPAREN();
    std::vector<Index_subtype_definitionContext *> index_subtype_definition();
    Index_subtype_definitionContext* index_subtype_definition(size_t i);
    tree::TerminalNode *RPAREN();
    tree::TerminalNode *OF();
    Subnature_indicationContext *subnature_indication();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Unconstrained_nature_definitionContext* unconstrained_nature_definition();

  class Use_clauseContext : public ParserRuleContext {
  public:
    Use_clauseContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *USE();
    std::vector<Selected_nameContext *> selected_name();
    Selected_nameContext* selected_name(size_t i);
    tree::TerminalNode *SEMI();
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Use_clauseContext* use_clause();

  class Variable_assignment_statementContext : public ParserRuleContext {
  public:
    Variable_assignment_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    TargetContext *target();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Variable_assignment_statementContext* variable_assignment_statement();

  class Variable_declarationContext : public ParserRuleContext {
  public:
    Variable_declarationContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *VARIABLE();
    Identifier_listContext *identifier_list();
    tree::TerminalNode *COLON();
    Subtype_indicationContext *subtype_indication();
    tree::TerminalNode *SEMI();
    tree::TerminalNode *SHARED();
    tree::TerminalNode *VARASGN();
    ExpressionContext *expression();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Variable_declarationContext* variable_declaration();

  class Wait_statementContext : public ParserRuleContext {
  public:
    Wait_statementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    tree::TerminalNode *WAIT();
    tree::TerminalNode *SEMI();
    Label_colonContext *label_colon();
    Sensitivity_clauseContext *sensitivity_clause();
    Condition_clauseContext *condition_clause();
    Timeout_clauseContext *timeout_clause();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Wait_statementContext* wait_statement();

  class WaveformContext : public ParserRuleContext {
  public:
    WaveformContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Waveform_elementContext *> waveform_element();
    Waveform_elementContext* waveform_element(size_t i);
    std::vector<tree::TerminalNode *> COMMA();
    tree::TerminalNode* COMMA(size_t i);
    tree::TerminalNode *UNAFFECTED();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  WaveformContext* waveform();

  class Waveform_elementContext : public ParserRuleContext {
  public:
    Waveform_elementContext(ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExpressionContext *> expression();
    ExpressionContext* expression(size_t i);
    tree::TerminalNode *AFTER();

    virtual void enterRule(tree::ParseTreeListener *listener) override;
    virtual void exitRule(tree::ParseTreeListener *listener) override;

    virtual antlrcpp::Any accept(tree::ParseTreeVisitor *visitor) override;
   
  };

  Waveform_elementContext* waveform_element();


private:
  static std::vector<dfa::DFA> _decisionToDFA;
  static atn::PredictionContextCache _sharedContextCache;
  static std::vector<std::string> _ruleNames;
  static std::vector<std::string> _tokenNames;

  static std::vector<std::string> _literalNames;
  static std::vector<std::string> _symbolicNames;
  static dfa::Vocabulary _vocabulary;
  static atn::ATN _atn;
  static std::vector<uint16_t> _serializedATN;


  struct Initializer {
    Initializer();
  };
  static Initializer _init;
};

}  // namespace vhdl
