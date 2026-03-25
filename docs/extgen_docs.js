/**
 * @function_partial declared_age_range_is_supported
 * @returns {Bool} 
 * @function_end 
 */

/**
 * @function_partial declared_age_range_request
 * @param {Real} age_gate_1
 * @param {Real} age_gate_2
 * @param {Real} age_gate_3
 * @param {Function} callback
 * @function_end 
 */

/**
 * @struct_partial DeclaredAgeRangeResult
 * @member {Bool} success
 * @member {Real} age_lower
 * @member {Real} age_upper
 * @member {Enum.DeclaredAgeRangeDeclaration} declaration
 * @member {String} error
 * @struct_end 
 */

/**
 * @enum_partial DeclaredAgeRangeDeclaration
 * @member Unknown
 * @member SelfDeclared
 * @member GuardianDeclared
 * @member CheckedByOtherMethod
 * @member GuardianCheckedByOtherMethod
 * @member GovernmentIDChecked
 * @member GuardianGovernmentIDChecked
 * @member PaymentChecked
 * @member GuardianPaymentChecked
 * @enum_end 
 */

/**
 * @const_partial macros
 * @const_end 
 */

