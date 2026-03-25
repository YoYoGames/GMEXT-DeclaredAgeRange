import Foundation
import UIKit
import DeclaredAgeRange

public class GMDeclaredAgeRangeSwift: GMDeclaredAgeRangeInternalSwift
{
    public override init()
    {
        super.init()
    }

    public override func declared_age_range_is_supported() -> Bool
    {
        if #available(iOS 26.2, *)
        {
            return 1
        }

        return 0
    }

    private var my_callback: GMFunction?

    public override func declared_age_range_request(
        age_gate_1: Int32,
        age_gate_2: Int32,
        age_gate_3: Int32,
        callback: GMFunction
    )
    {
        my_callback = callback

        if age_gate_1 < 0
        {
            my_callback?.call(
                DeclaredAgeRangeResult(
                    success: false,
                    age_lower: -1,
                    age_upper: -1,
                    declaration: DeclaredAgeRangeDeclaration.Unknown,
                    error: "age_gate_1 must be >= 0."
                )
            )
            return
        }

        if #available(iOS 26.2, *)
        {
            guard let viewController = dar_topViewController() else
            {
                my_callback?.call(
                    DeclaredAgeRangeResult(
                        success: false,
                        age_lower: -1,
                        age_upper: -1,
                        declaration: DeclaredAgeRangeDeclaration.Unknown,
                        error: "No active UIViewController."
                    )
                )
                return
            }

            Task { @MainActor in
                do
                {
                    let g1: Int = Int(age_gate_1)
                    let g2: Int? = age_gate_2 >= 0 ? Int(age_gate_2) : nil
                    let g3: Int? = age_gate_3 >= 0 ? Int(age_gate_3) : nil

                    let response: AgeRangeService.Response =
                        try await AgeRangeService.shared.requestAgeRange(
                            ageGates: g1, g2, g3,
                            in: viewController
                        )

                    switch response
                    {
                        case let .sharing(range):
                            self.my_callback?.call(
                                DeclaredAgeRangeResult(
                                    success: true,
                                    age_lower: Double(range.lowerBound ?? -1),
                                    age_upper: Double(range.upperBound ?? -1),
                                    declaration: self.mapDeclaration(range.ageRangeDeclaration),
                                    error: ""
                                )
                            )

                        case .declinedSharing:
                            self.my_callback?.call(
                                DeclaredAgeRangeResult(
                                    success: false,
                                    age_lower: -1,
                                    age_upper: -1,
                                    declaration: DeclaredAgeRangeDeclaration.Unknown,
                                    error: ""
                                )
                            )

                        @unknown default:
                            self.my_callback?.call(
                                DeclaredAgeRangeResult(
                                    success: false,
                                    age_lower: -1,
                                    age_upper: -1,
                                    declaration: DeclaredAgeRangeDeclaration.Unknown,
                                    error: "Unknown DeclaredAgeRange response."
                                )
                            )
                    }
                }
                catch
                {
                    self.my_callback?.call(
                        DeclaredAgeRangeResult(
                            success: false,
                            age_lower: -1,
                            age_upper: -1,
                            declaration: DeclaredAgeRangeDeclaration.Unknown,
                            error: String(describing: error)
                        )
                    )
                }
            }
        }
        else
        {
            my_callback?.call(
                DeclaredAgeRangeResult(
                    success: false,
                    age_lower: -1,
                    age_upper: -1,
                    declaration: DeclaredAgeRangeDeclaration.Unknown,
                    error: "DeclaredAgeRange requires iOS 26.2+."
                )
            )
        }
    }

    @available(iOS 26.2, *)
    private func mapDeclaration(
        _ declaration: AgeRangeService.AgeRangeDeclaration?
    ) -> DeclaredAgeRangeDeclaration
    {
        guard let declaration else
        {
            return .Unknown
        }

        switch declaration
        {
            case .selfDeclared:
                return .SelfDeclared

            case .guardianDeclared:
                return .GuardianDeclared

            case .checkedByOtherMethod:
                return .CheckedByOtherMethod

            case .guardianCheckedByOtherMethod:
                return .GuardianCheckedByOtherMethod

            case .governmentIDChecked:
                return .GovernmentIDChecked

            case .guardianGovernmentIDChecked:
                return .GuardianGovernmentIDChecked

            case .paymentChecked:
                return .PaymentChecked

            case .guardianPaymentChecked:
                return .GuardianPaymentChecked

            @unknown default:
                return .Unknown
        }
    }

    private func dar_topViewController(
        base: UIViewController? = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?
            .rootViewController
    ) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return dar_topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController
        {
            return dar_topViewController(base: tab.selectedViewController)
        }

        if let presented = base?.presentedViewController
        {
            return dar_topViewController(base: presented)
        }

        return base
    }
}