public enum DeclaredAgeRangeDeclaration: UInt32
{
    case Unknown = 0
    case SelfDeclared = 1
    case GuardianDeclared = 2
    case CheckedByOtherMethod = 3
    case GuardianCheckedByOtherMethod = 4
    case GovernmentIDChecked = 5
    case GuardianGovernmentIDChecked = 6
    case PaymentChecked = 7
    case GuardianPaymentChecked = 8
}

public struct DeclaredAgeRangeResult: ITypedStruct
{
    public var success: Bool
    public var age_lower: Double
    public var age_upper: Double
    public var declaration: DeclaredAgeRangeDeclaration
    public var error: String
}

extension DeclaredAgeRangeResult
{
    public static let codecID: UInt32 = 0

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.age_lower = try r.readRaw(Double.self)
        self.age_upper = try r.readRaw(Double.self)
        self.declaration = (DeclaredAgeRangeDeclaration(rawValue: try r.readRaw(UInt32.self))!)
        self.error = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.age_lower)
        try w.writeRaw(self.age_upper)
        try w.writeRaw(self.declaration.rawValue)
        try w.writeRaw(self.error)
    }
}

