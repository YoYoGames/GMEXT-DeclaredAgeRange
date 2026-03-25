## IMPORTANT

* This extension is compatible with **GameMaker 2023.1 and newer**
* Requires **iOS 26.2 or newer**
* Target platform: **iOS only**
* Uses Apple's **Declared Age Range API**
* Not supported on **Android or other platforms**

---

## CHANGES SINCE ${releaseOldVersion}

https://github.com/YoYoGames/GMEXT-DeclaredAgeRange/compare/${releaseOldVersion}...${releaseNewVersion}

---

## DESCRIPTION

Declared Age Range is an Apple-provided system that allows apps to request a user’s age range in a privacy-preserving way.

Instead of exposing an exact age, the system returns a **bounded age range** along with metadata describing **how that age was declared or verified** (e.g. self-declared, guardian-provided, government ID, etc).

This extension integrates the Declared Age Range API into GameMaker, enabling developers to request and use age range data for compliance, content gating, and user experience adaptation.

---

## FEATURES

* Request **user age range via Apple system UI**
* Supports **custom age thresholds (1–3 gates)**
* Returns both:

  * Age range (lower / upper bounds)
  * Declaration / verification method
* Includes **guardian-aware signals**
* Privacy-focused (no exact age exposed)
* Designed to support:

  * App Store policy compliance
  * GDPR / COPPA-style considerations
* Simple asynchronous API for GameMaker

---

## USAGE NOTES

* Age range data is **not guaranteed**
* Users or guardians may **decline sharing**
* Even on supported devices, results may be:

  * unavailable
  * partial
  * unknown declaration type
* This API returns a **range**, not an exact age
* Results should be used to **adapt content**, not identify users

---

## DOCUMENTATION

The full API documentation is included in the extension package (included files), along with usage examples and implementation guidance.

---