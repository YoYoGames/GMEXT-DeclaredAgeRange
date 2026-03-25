if (!declared_age_range_is_supported())
{
    show_message_async("DeclaredAgeRange Unsupported");
    exit;
}

declared_age_range_request(13, 16, 18, function(data)
{
    if (!data.success)
    {
        show_debug_message("DeclaredAgeRange error: " + data.error);
        return;
    }

    show_debug_message("age_lower: " + string(data.age_lower));
    show_debug_message("age_upper: " + string(data.age_upper));

    switch (data.declaration)
    {
        case DeclaredAgeRangeDeclaration.SelfDeclared:
            show_debug_message("SelfDeclared → User entered age manually");
        break;

        case DeclaredAgeRangeDeclaration.GuardianDeclared:
            show_debug_message("GuardianDeclared → Parent/guardian provided age");
        break;

        case DeclaredAgeRangeDeclaration.CheckedByOtherMethod:
            show_debug_message("CheckedByOtherMethod → Verified by system method");
        break;

        case DeclaredAgeRangeDeclaration.GuardianCheckedByOtherMethod:
            show_debug_message("GuardianCheckedByOtherMethod → Guardian verified via system method");
        break;

        case DeclaredAgeRangeDeclaration.GovernmentIDChecked:
            show_debug_message("GovernmentIDChecked → Verified with government ID");
        break;

        case DeclaredAgeRangeDeclaration.GuardianGovernmentIDChecked:
            show_debug_message("GuardianGovernmentIDChecked → Guardian verified via government ID");
        break;

        case DeclaredAgeRangeDeclaration.PaymentChecked:
            show_debug_message("PaymentChecked → Verified via payment method");
        break;

        case DeclaredAgeRangeDeclaration.GuardianPaymentChecked:
            show_debug_message("GuardianPaymentChecked → Guardian verified via payment method");
        break;

        case DeclaredAgeRangeDeclaration.Unknown:
            show_debug_message("Unknown → No declaration info");
        break;

        default:
            show_debug_message("Unhandled declaration: " + string(data.declaration));
        break;
    }
});

