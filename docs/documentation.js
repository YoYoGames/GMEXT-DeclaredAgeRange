/**
 * @module home
 * @title Declared Age Range Extension
 * @desc Welcome to the Declared Age Range extension wiki!
 * 
 * Declared Age Range is a GameMaker extension that wraps Apple's
 * DeclaredAgeRange framework on iOS.
 * 
 * The extension presents the system age range sheet and returns an
 * age range result describing the user's declared age bracket, along
 * with the declaration method reported by the platform.
 * 
 * This is useful for:
 * 
 * - Presenting an Apple-provided age range request flow
 * - Adapting content to broad age brackets instead of exact age
 * - Supporting parental or guardian declaration flows when available
 * - Keeping age checks inside the native platform experience
 * 
 * ## Notes
 * 
 * - This extension is only supported on iOS 26.2 and newer.
 * 
 * - ${func.declared_age_range_is_supported} can be used to check
 *   whether the current device and OS version support the API.
 * 
 * - ${func.declared_age_range_request} is asynchronous and always
 *   returns its result through the callback.
 * 
 * - `age_gate_1` is required and must be greater than or equal to `0`.
 * 
 * - `age_gate_2` and `age_gate_3` are optional. Pass `-1` for either
 *   value to omit that age gate.
 * 
 * Basic example of usage:
 * 
 * ```gml
 * if (declared_age_range_is_supported())
 * {
 *     declared_age_range_request(13, 16, 18, function(result)
 *     {
 *         if (!result.success)
 *         {
 *             show_debug_message("DeclaredAgeRange failed: " + result.error);
 *             return;
 *         }
 * 
 *         show_debug_message("Lower: " + string(result.age_lower));
 *         show_debug_message("Upper: " + string(result.age_upper));
 *         show_debug_message("Declaration: " + string(result.declaration));
 *     });
 * }
 * else
 * {
 *     show_debug_message("DeclaredAgeRange requires iOS 26.2+");
 * }
 * ```
 * 
 * @section_func
 * @ref declared_age_range_is_supported
 * @ref declared_age_range_request
 * @section_end
 * 
 * @section_struct
 * @ref DeclaredAgeRangeResult
 * @section_end
 * 
 * @section_const
 * @ref DeclaredAgeRangeDeclaration
 * @section_end
 * 
 * @module_end
 */

/**
 * @function declared_age_range_is_supported
 * @desc Returns whether the Declared Age Range API is supported on the current device. This currently requires iOS 26.2 or newer.
 * @returns {Bool}
 * @example
 * ```gml
 * if (declared_age_range_is_supported())
 * {
 *     show_debug_message("DeclaredAgeRange is available");
 * }
 * else
 * {
 *     show_debug_message("DeclaredAgeRange is not available on this device");
 * }
 * ```
 * @func_end
 */

/**
 * @function declared_age_range_request
 * @desc Requests the user's age range using up to 3 age thresholds.
 * 
 * > [!IMPORTANT]
 * > This API may present Apple-controlled UI to the user.
 * 
 * ### System UI
 * - Call from a valid UI flow
 * - Do NOT call during startup splash
 * - Do NOT call while backgrounded
 * - Avoid unstable transitions
 * 
 * ---
 * 
 * > [!WARNING]
 * > Do not repeatedly call this function.
 * 
 * ### Repeated Calls
 * - Do NOT call every frame
 * - Do NOT call in Step events
 * - Cache results when possible
 * 
 * ---
 * 
 * > [!CAUTION]
 * > Age range data is privacy-sensitive.
 * 
 * ### Privacy
 * - Do not store unnecessarily
 * - Do not transmit unnecessarily
 * - Follow store policies and regulations
 * 
 * ---
 * 
 * > [!NOTE]
 * > The request may fail even when supported.
 * 
 * Possible reasons:
 * - User declined sharing
 * - Guardian declined sharing
 * - No valid UI context
 * - System/runtime error
 * 
 * Always inspect `result.error`.
 * 
 * ---
 * 
 * @param {Real} age_gate_1 REQUIRED (must be >= 0)
 * @param {Real} age_gate_2 OPTIONAL (use -1 to ignore)
 * @param {Real} age_gate_3 OPTIONAL (use -1 to ignore)
 * @param {Function} callback Receives ${struct.DeclaredAgeRangeResult}
 * 
 * @event callback
 * @member {Struct.DeclaredAgeRangeResult} result
 * @event_end
 * 
 * @example
 * ```gml
 * declared_age_range_request(13, 16, 18, function(result)
 * {
 *     if (!result.success)
 *     {
 *         if (result.error != "")
 *         {
 *             show_debug_message("DeclaredAgeRange error: " + result.error);
 *         }
 *         else
 *         {
 *             show_debug_message("User declined to share an age range");
 *         }
 *         return;
 *     }
 * 
 *     show_debug_message("Age lower: " + string(result.age_lower));
 *     show_debug_message("Age upper: " + string(result.age_upper));
 * 
 *     switch (result.declaration)
 *     {
 *         case DeclaredAgeRangeDeclaration.SelfDeclared:
 *             show_debug_message("Age range was self declared");
 *         break;
 * 
 *         case DeclaredAgeRangeDeclaration.GuardianDeclared:
 *             show_debug_message("Age range was guardian declared");
 *         break;
 * 
 *         default:
 *             show_debug_message("Declaration type: " + string(result.declaration));
 *         break;
 *     }
 * });
 * 
 * /// Example result (success):
 * {
 *     success: true,
 *     age_lower: 13,
 *     age_upper: 15,
 *     declaration: DeclaredAgeRangeDeclaration.SelfDeclared,
 *     error: ""
 * }
 * 
 * /// Example result (failure - unsupported OS):
 * {
 *     success: false,
 *     age_lower: -1,
 *     age_upper: -1,
 *     declaration: DeclaredAgeRangeDeclaration.Unknown,
 *     error: "DeclaredAgeRange requires iOS 26.2+."
 * }
 * ```
 * 
 * @func_end
 */


/**
 * @struct DeclaredAgeRangeResult
 * @desc Represents the result of a declared age range request. 
 * 
 * > [!NOTE]
 * > The API returns an age range, not an exact age.
 * 
 * Example:
 * - age_lower = 13
 * - age_upper = 17
 * 
 * This means the user is within that range.
 * 
 * ---
 * 
 * > [!IMPORTANT]
 * > `success == false` does NOT always mean an error.
 * 
 * It may indicate:
 * - User declined sharing
 * - Guardian declined sharing
 * - Unsupported device
 * - Runtime/UI issue
 * 
 * ---
 * 
 * > [!TIP]
 * > Use `declaration` to estimate trust level in your logic.
 * 
 * Suggested interpretation:
 * 
 * Lower trust:
 * - SelfDeclared
 * - GuardianDeclared
 * 
 * Medium:
 * - CheckedByOtherMethod
 * - GuardianCheckedByOtherMethod
 * 
 * Higher:
 * - GovernmentIDChecked
 * - GuardianGovernmentIDChecked
 * - PaymentChecked
 * - GuardianPaymentChecked
 * 
 * ---
 * 
 * @member {Bool} success True if request succeeded
 * @member {Real} age_lower Lower bound (-1 if unavailable)
 * @member {Real} age_upper Upper bound (-1 if unavailable)
 * @member {Enum.DeclaredAgeRangeDeclaration} declaration Verification method
 * @member {String} error Error message if failed
 * @struct_end
 */

/**
 * @const DeclaredAgeRangeDeclaration
 * @desc Describes how the reported age range was declared or checked.
 * @member Unknown No declaration information is available.
 * @member SelfDeclared The age range was declared by the user.
 * @member GuardianDeclared The age range was declared by a guardian.
 * @member CheckedByOtherMethod The age range was checked by another method.
 * @member GuardianCheckedByOtherMethod The age range was guardian-checked by another method.
 * @member GovernmentIDChecked The age range was checked using government ID.
 * @member GuardianGovernmentIDChecked The age range was guardian-checked using government ID.
 * @member PaymentChecked The age range was checked using a payment method.
 * @member GuardianPaymentChecked The age range was guardian-checked using a payment method.
 * @const_end
 */