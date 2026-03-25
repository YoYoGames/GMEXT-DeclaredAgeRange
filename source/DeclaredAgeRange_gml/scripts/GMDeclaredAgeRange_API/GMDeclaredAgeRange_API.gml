// ##### extgen :: Auto-generated file do not edit!! #####

// #####################################################################
// # Macros
// #####################################################################

// #####################################################################
// # Enums
// #####################################################################

enum DeclaredAgeRangeDeclaration
{
    Unknown = 0,
    SelfDeclared = 1,
    GuardianDeclared = 2,
    CheckedByOtherMethod = 3,
    GuardianCheckedByOtherMethod = 4,
    GovernmentIDChecked = 5,
    GuardianGovernmentIDChecked = 6,
    PaymentChecked = 7,
    GuardianPaymentChecked = 8
}

// #####################################################################
// # Constructors
// #####################################################################

/**
 * @returns {Struct.DeclaredAgeRangeResult} 
 */
function DeclaredAgeRangeResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore 
     */
    static __uid = 1654036550;

    self.success = undefined;
    self.age_lower = undefined;
    self.age_upper = undefined;
    self.declaration = undefined;
    self.error = undefined;

}

// #####################################################################
// # Codecs
// #####################################################################

/**
 * @func __DeclaredAgeRangeResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.DeclaredAgeRangeResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore 
 */
function __DeclaredAgeRangeResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: age_lower, type: Float64
        if (!is_numeric(self.age_lower)) show_error($"{_where} :: self.age_lower expected number", true);
        buffer_write(_buffer, buffer_f64, self.age_lower);

        // field: age_upper, type: Float64
        if (!is_numeric(self.age_upper)) show_error($"{_where} :: self.age_upper expected number", true);
        buffer_write(_buffer, buffer_f64, self.age_upper);

        // field: declaration, type: enum DeclaredAgeRangeDeclaration

        if (!is_numeric(self.declaration)) show_error($"{_where} :: self.declaration expected number", true);
        buffer_write(_buffer, buffer_u32, self.declaration);

        // field: error, type: String
        if (!is_string(self.error)) show_error($"{_where} :: self.error expected string", true);
        buffer_write(_buffer, buffer_u32, string_length(self.error));
        buffer_write(_buffer, buffer_string, self.error);

    }
}

/**
 * @func __DeclaredAgeRangeResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.DeclaredAgeRangeResult} 
 * @ignore 
 */
function __DeclaredAgeRangeResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new DeclaredAgeRangeResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: age_lower, type: Float64
        self.age_lower = buffer_read(_buffer, buffer_f64);

        // field: age_upper, type: Float64
        self.age_upper = buffer_read(_buffer, buffer_f64);

        // field: declaration, type: enum DeclaredAgeRangeDeclaration
        self.declaration = buffer_read(_buffer, buffer_u32);

        // field: error, type: String
        buffer_read(_buffer, buffer_u32);
        self.error = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

// #####################################################################
// # Functions
// #####################################################################

// Skipping function declared_age_range_is_supported (no wrapper is required)


/**
 * @param {Real} _age_gate_1
 * @param {Real} _age_gate_2
 * @param {Real} _age_gate_3
 * @param {Function} _callback
 */
function declared_age_range_request(_age_gate_1, _age_gate_2, _age_gate_3, _callback)
{
    static __dispatcher = __GMDeclaredAgeRange_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _age_gate_1, type: Int32
    if (!is_numeric(_age_gate_1)) show_error($"{_GMFUNCTION_} :: _age_gate_1 expected number", true);
    buffer_write(__args_buffer, buffer_s32, _age_gate_1);

    // param: _age_gate_2, type: Int32
    if (!is_numeric(_age_gate_2)) show_error($"{_GMFUNCTION_} :: _age_gate_2 expected number", true);
    buffer_write(__args_buffer, buffer_s32, _age_gate_2);

    // param: _age_gate_3, type: Int32
    if (!is_numeric(_age_gate_3)) show_error($"{_GMFUNCTION_} :: _age_gate_3 expected number", true);
    buffer_write(__args_buffer, buffer_s32, _age_gate_3);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var _return_value = __declared_age_range_request(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return _return_value;
}

/// @ignore
function __GMDeclaredAgeRange_get_decoders()
{
    static __decoders = [
        __DeclaredAgeRangeResult_decode
    ];
    return __decoders;
}
/// @ignore
function __GMDeclaredAgeRange_get_dispatcher()
{
    static __dispatcher = new __GMNativeFunctionDispatcher(__GMDeclaredAgeRange_invocation_handler, __GMDeclaredAgeRange_get_decoders());
    return __dispatcher;
}
