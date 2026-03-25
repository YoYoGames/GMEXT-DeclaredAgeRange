import Foundation
import os.log
import CxxStdlib

open class GMDeclaredAgeRangeInternalSwift
{
    internal var __dispatch_queue: GMDispatchQueue = GMDispatchQueue()

    public init()
    {
    }

    open func declared_age_range_is_supported() -> Bool
    {
        // default stub for declared_age_range_is_supported
        return false
    }

    open func declared_age_range_request(age_gate_1: Int32, age_gate_2: Int32, age_gate_3: Int32, callback: GMFunction)
    {
        // default stub for declared_age_range_request
    }

    public func __EXT_SWIFT__declared_age_range_is_supported() -> Double
    {
        let __result = self.declared_age_range_is_supported()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__declared_age_range_request(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: age_gate_1, type: Int32
            let age_gate_1: Int32 = try __br.readRaw(Int32.self)

            // field: age_gate_2, type: Int32
            let age_gate_2: Int32 = try __br.readRaw(Int32.self)

            // field: age_gate_3, type: Int32
            let age_gate_3: Int32 = try __br.readRaw(Int32.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.declared_age_range_request(age_gate_1: age_gate_1, age_gate_2: age_gate_2, age_gate_3: age_gate_3, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'declared_age_range_request'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__GMDeclaredAgeRange_invocation_handler(_ __ret_buffer: UnsafeMutablePointer<CChar>?, arg1 __ret_buffer_length: Double) -> Double
    {
        var __bw = BufferWriter(base: UnsafeMutableRawPointer(__ret_buffer!), size: Int(__ret_buffer_length))
        return __dispatch_queue.fetch(into: &__bw)
    }

}
